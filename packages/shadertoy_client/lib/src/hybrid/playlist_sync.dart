import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';

import 'hybrid_client.dart';
import 'sync.dart';

class PlaylistSyncTask extends SyncTask<FindPlaylistResponse> {
  PlaylistSyncTask(FindPlaylistResponse response) : super.one(response);
}

class PlaylistSyncResult extends SyncResult<PlaylistSyncTask> {
  final List<PlaylistSyncTask> current;

  Set<String> get currentPlaylistIds => current
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  Set<String> get addedPlaylistIds => added
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  Set<String> get removedPlaylistIds => removed
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  PlaylistSyncResult(
      {this.current = const [],
      List<PlaylistSyncTask>? added,
      List<PlaylistSyncTask>? removed})
      : super(added: added, removed: removed);
}

class PlaylistSyncProcessor extends SyncProcessor {
  PlaylistSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            runner: runner, concurrency: concurrency, timeout: timeout);

  FindPlaylistResponse getPlaylistError(dynamic e, String playlistId) {
    return FindPlaylistResponse(
        error: ResponseError.unknown(
            message: e.toString(),
            context: CONTEXT_PLAYLIST,
            target: playlistId));
  }

  Future<PlaylistSyncTask> _addPlaylist(String playlistId) {
    return client
        .findPlaylistById(playlistId)
        .then((apiPlaylist) {
          if (apiPlaylist.ok) {
            return client
                .findAllShaderIdsByPlaylistId(playlistId)
                .then((apiShaders) {
              final playlist = apiPlaylist.playlist;
              final shaderIds = apiShaders.ids;
              var pre = Future.value();
              if (playlist != null && shaderIds != null) {
                pre = store.savePlaylist(playlist, shaderIds: shaderIds);
              }

              return pre.then((value) => apiPlaylist);
            });
          }

          return Future.value(apiPlaylist);
        })
        .then((pr) => PlaylistSyncTask(pr))
        .catchError((e) => PlaylistSyncTask(getPlaylistError(e, playlistId)));
  }

  Future<List<PlaylistSyncTask>> _addPlaylists(Set<String> playlistIds) async {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlistId in playlistIds) {
      tasks.add(taskPool.withResource(() => _addPlaylist(playlistId)));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Saving ${playlistIds.length} playlist(s): ');
  }

  Future<PlaylistSyncTask> _deletePlaylist(String playlistId) {
    return store
        .findPlaylistById(playlistId)
        .then((fpr) => store
            .deletePlaylistById(playlistId)
            .then((value) => PlaylistSyncTask(fpr)))
        .catchError((e) => PlaylistSyncTask(getPlaylistError(e, playlistId)));
  }

  Future<List<PlaylistSyncTask>> _deletePlaylists(
      Set<String> playlistIds) async {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlistId in playlistIds) {
      tasks.add(taskPool.withResource(() => _deletePlaylist(playlistId)));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Deleting ${playlistIds.length} playlist(s): ');
  }

  Future<PlaylistSyncResult> _syncPlaylists(List<String> playlistIds) async {
    final localResponse = await store.findAllPlaylists();
    if (localResponse.ok) {
      final localPlaylists = localResponse.playlists ?? [];
      final localPlaylistIds = localPlaylists
          .map((fpr) => fpr.playlist?.id)
          .whereType<String>()
          .toSet();
      final remotePlaylistIds = playlistIds.toSet();

      final addPlaylistIds = remotePlaylistIds.difference(localPlaylistIds);
      final removePlaylistIds = localPlaylistIds.difference(remotePlaylistIds);
      final local = localPlaylists.map((fpr) => PlaylistSyncTask(fpr));
      final added = await _addPlaylists(addPlaylistIds)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deletePlaylists(removePlaylistIds)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removedPlaylistIds = removed
          .map((PlaylistSyncTask task) => task.response.playlist?.id)
          .whereType<String>();
      final currentPlaylists = [...local, ...added]..removeWhere((element) =>
          removedPlaylistIds.contains(element.response.playlist?.id ?? ''));

      return PlaylistSyncResult(
          current: currentPlaylists, added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining shader ids from the local store: ${localResponse.error?.message}');
    }

    return PlaylistSyncResult();
  }

  Future<PlaylistSyncResult> syncPlaylists(List<String> playlistIds) async {
    final playlistSyncResult = await _syncPlaylists(playlistIds);

    return playlistSyncResult;
  }
}
