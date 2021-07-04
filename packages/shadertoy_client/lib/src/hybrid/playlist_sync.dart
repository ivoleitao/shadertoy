import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';

import 'hybrid_client.dart';
import 'sync.dart';

/// A playlist synchronization task
class PlaylistSyncTask extends SyncTask<FindPlaylistResponse> {
  /// The [PlaylistSyncTask] constructor
  ///
  /// * [response]: The [FindPlaylistResponse] associated with this task
  PlaylistSyncTask(FindPlaylistResponse response) : super.one(response);
}

/// The result of a playlist synchronization task
class PlaylistSyncResult extends SyncResult<PlaylistSyncTask> {
  /// The current task
  final List<PlaylistSyncTask> current;

  /// The current playlist ids
  Set<String> get currentPlaylistIds => current
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  /// The added playlist ids
  Set<String> get addedPlaylistIds => added
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  /// The removed playlist ids
  Set<String> get removedPlaylistIds => removed
      .map((task) => task.response.playlist?.id)
      .whereType<String>()
      .toSet();

  /// The [PlaylistSyncResult] constructor
  ///
  /// * [current]: The current [PlaylistSyncTask]
  /// * [added]: The list of added [PlaylistSyncTask]s
  /// * [removed]: The list of removed [PlaylistSyncTask]s
  PlaylistSyncResult(
      {this.current = const [],
      List<PlaylistSyncTask>? added,
      List<PlaylistSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// The processor of playlist synchronization tasks
class PlaylistSyncProcessor extends SyncProcessor {
  /// The [PlaylistSyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [store]: The [ShadertoyStore] instance
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  PlaylistSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            runner: runner, concurrency: concurrency, timeout: timeout);

  /// Creates a [FindPlaylistResponse] with a error
  ///
  /// * [e]: The error cause
  /// * [playlistId]: The playlist id
  FindPlaylistResponse getPlaylistError(dynamic e, String playlistId) {
    return FindPlaylistResponse(
        error: ResponseError.unknown(
            message: e.toString(),
            context: contextPlaylist,
            target: playlistId));
  }

  /// Saves a playlist with id equal to [playlistId]
  ///
  /// * [playlistId]: The playlist id
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

  /// Saves a list of playlists with [playlistIds]
  ///
  /// * [playlistIds]: The list playlist ids
  Future<List<PlaylistSyncTask>> _addPlaylists(Set<String> playlistIds) async {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlistId in playlistIds) {
      tasks.add(taskPool.withResource(() => _addPlaylist(playlistId)));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Saving ${playlistIds.length} playlist(s): ');
  }

  /// Deletes a playlist with id [playlistId]
  ///
  /// * [playlistId]: The playlist id
  Future<PlaylistSyncTask> _deletePlaylist(String playlistId) {
    return store
        .findPlaylistById(playlistId)
        .then((fpr) => store
            .deletePlaylistById(playlistId)
            .then((value) => PlaylistSyncTask(fpr)))
        .catchError((e) => PlaylistSyncTask(getPlaylistError(e, playlistId)));
  }

  /// Deletes a list of playlists with [playlistIds]
  ///
  /// * [playlistIds]: The list playlist ids
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

  /// Synchronizes a list of [playlistIds]
  ///
  /// * [playlistIds]: The list playlist ids
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

  /// Synchronizes a list of [playlistIds]
  ///
  /// * [playlistIds]: The list playlist ids
  Future<PlaylistSyncResult> syncPlaylists(List<String> playlistIds) async {
    final playlistSyncResult = await _syncPlaylists(playlistIds);

    return playlistSyncResult;
  }
}
