import 'dart:collection';

import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/hybrid/user_sync.dart';
import 'package:stash/stash_api.dart' show VaultStore;

import 'hybrid_client.dart';
import 'shader_sync.dart';
import 'sync.dart';

/// A playlist synchronization task
class PlaylistSyncTask extends SyncTask<FindPlaylistResponse> {
  final FindShaderIdsResponse? extraResponse;

  /// The [PlaylistSyncTask] constructor
  ///
  /// * [response]: The [FindPlaylistResponse] associated with this task
  /// * [extraResponse]: The [FindShaderIdsResponse] associated with this task
  PlaylistSyncTask(super.response, {this.extraResponse}) : super.one();
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
  PlaylistSyncResult({this.current = const [], super.added, super.removed});
}

/// The processor of playlist synchronization tasks
class PlaylistSyncProcessor extends SyncProcessor {
  /// The [PlaylistSyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [metadataStore]: A [ShadertoyStore] implementation to store the metadata
  /// * [assetStore]: A [VaultStore] implementation to store shader and user assets
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  PlaylistSyncProcessor(super.client, super.metadataStore, super.assetStore,
      {super.runner, super.concurrency, super.timeout});

  /// Creates a [FindPlaylistResponse] with a error
  ///
  /// * [playlist]: The playlist
  /// * [fplaylist]: The playlist response
  /// * [response]: The response
  /// * [e]: The error cause
  FindPlaylistResponse _getPlaylistResponse(Playlist playlist,
      {FindPlaylistResponse? fplaylist, APIResponse? response, dynamic e}) {
    if (response != null && response.ok) {
      return fplaylist ?? FindPlaylistResponse(playlist: playlist);
    }

    return FindPlaylistResponse(
        error: response?.error ??
            ResponseError.unknown(
                message: e.toString(),
                context: contextPlaylist,
                target: playlist.id));
  }

  /// Saves a playlist with id equal to [playlistId]
  ///
  /// * [playlist]: The playlist
  /// * [shaderIds]: The playlist shaders
  Future<FindPlaylistResponse> _addPlaylist(
      Playlist playlist, List<String> shaderIds) {
    return metadataStore.savePlaylist(playlist, shaderIds: shaderIds).then(
        (splaylist) => _getPlaylistResponse(playlist, response: splaylist));
  }

  /// Syncs a [playlist] with [shaderIds]
  ///
  /// * [playlist]: The playlist
  /// * [shaderIds]: The playlist shaders
  Future<PlaylistSyncTask> _syncPlaylist(
      Playlist playlist, List<String> shaderIds) {
    final playlistId = playlist.id;
    return metadataStore
        .findSyncById(SyncType.playlist, playlistId)
        .then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: SyncType.playlist,
                target: playlistId,
                status: SyncStatus.pending,
                creationTime: DateTime.now());

        return metadataStore.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addPlaylist(playlist, shaderIds)
                .then((FindPlaylistResponse fplaylist) {
              final posSync = fplaylist.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: fplaylist.error?.message,
                      updateTime: DateTime.now());

              return metadataStore.saveSync(posSync).then((ssync2) {
                return Future.value(PlaylistSyncTask(_getPlaylistResponse(
                    playlist,
                    fplaylist: fplaylist,
                    response: ssync2)));
              });
            });
          }

          return Future.value(PlaylistSyncTask(
              _getPlaylistResponse(playlist, response: ssync1)));
        });
      }

      return Future.value(
          PlaylistSyncTask(_getPlaylistResponse(playlist, response: fsync)));
    }).catchError(
            (e) => PlaylistSyncTask(_getPlaylistResponse(playlist, e: e)));
  }

  /// Saves a list of playlists with [playlistIds]
  ///
  /// * [playlists]: The map of playlists to shaders ids
  Future<List<PlaylistSyncTask>> _addPlaylists(
      Map<Playlist, Set<String>> playlists) {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlistEntry in playlists.entries) {
      tasks.add(taskPool.withResource(() =>
          _syncPlaylist(playlistEntry.key, playlistEntry.value.toList())));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Saving ${playlists.length} playlist(s)');
  }

  /// Deletes a playlist
  ///
  /// * [playlist]: The playlist
  Future<PlaylistSyncTask> _deletePlaylist(Playlist playlist) {
    final playlistId = playlist.id;
    return metadataStore
        .findPlaylistById(playlistId)
        .then((fpr) => metadataStore
            .deletePlaylistById(playlistId)
            .then((value) => PlaylistSyncTask(fpr)))
        .catchError(
            (e) => PlaylistSyncTask(_getPlaylistResponse(playlist, e: e)));
  }

  /// Deletes a list of playlists with [playlistIds]
  ///
  /// * [playlists]: The map of playlists to shaders ids
  Future<List<PlaylistSyncTask>> _deletePlaylists(
      Map<Playlist, Set<String>> playlists) {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlist in playlists.keys) {
      tasks.add(taskPool.withResource(() => _deletePlaylist(playlist)));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Deleting ${playlists.length} playlist(s)');
  }

  Future<List<PlaylistSyncTask>> _clientPlaylists(Set<String> playlistIds) {
    final tasks = <Future<PlaylistSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final playlistId in playlistIds) {
      tasks.add(taskPool.withResource(() =>
          client.findPlaylistById(playlistId).then((apiPlaylist) {
            if (apiPlaylist.ok) {
              return client
                  .findAllShaderIdsByPlaylistId(playlistId)
                  .then((apiShaders) {
                return PlaylistSyncTask(apiPlaylist, extraResponse: apiShaders);
              });
            }

            return Future.value(PlaylistSyncTask(apiPlaylist));
          })));
    }

    return runner.process<PlaylistSyncTask>(tasks,
        message: 'Downloading ${playlistIds.length} playlist(s)');
  }

  /// Synchronizes a list of [playlistIds]
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [userSync]: The user synchronization result
  /// * [playlistIds]: The list playlist ids
  Future<PlaylistSyncResult> _syncPlaylists(ShaderSyncResult shaderSync,
      UserSyncResult userSync, List<String> playlistIds) async {
    final storeSyncsResponse = await metadataStore.findSyncs(
        type: SyncType.playlist,
        status: {SyncStatus.pending, SyncStatus.error});
    final storePlaylistResponse = await metadataStore.findAllPlaylists();

    if (storeSyncsResponse.ok && storePlaylistResponse.ok) {
      final storeSyncs = storeSyncsResponse.syncs ?? [];
      final storePlaylistIdsError =
          storeSyncs.map((fsr) => fsr.sync?.target).whereType<String>();
      final storePlaylists = storePlaylistResponse.playlists ?? [];
      final storePlaylistIdsOk = storePlaylists
          .map((fpr) => fpr.playlist?.id)
          .whereType<String>()
          .toSet();

      final requestedPlaylistIds = playlistIds.toSet();
      final addPlaylistIds = {
        ...requestedPlaylistIds.difference(storePlaylistIdsOk),
        ...storePlaylistIdsError
      };
      final clientPlaylistShaderIds =
          LinkedHashMap.of(<Playlist, Set<String>>{});
      for (var playlistTask in await _clientPlaylists(addPlaylistIds)) {
        final playlistResponse = playlistTask.response;
        final playlistShaderIdsResponse = playlistTask.extraResponse;
        if (playlistResponse.ok &&
            playlistShaderIdsResponse != null &&
            playlistShaderIdsResponse.ok) {
          final shaderIds = shaderSync.currentShaderIds;
          final userIds = userSync.currentUserIds;
          final playlist = playlistResponse.playlist;
          final playlistShaderIds =
              (playlistShaderIdsResponse.ids ?? []).toSet();

          if (playlist != null && userIds.contains(playlist.userId)) {
            final filteredShaderIds = playlistShaderIds.intersection(shaderIds);
            if (filteredShaderIds.isNotEmpty) {
              clientPlaylistShaderIds[playlist] = filteredShaderIds;
            }
          }
        }
      }

      final addPlaylists =
          LinkedHashMap<Playlist, Set<String>>.from(clientPlaylistShaderIds)
            ..removeWhere((key, value) => storePlaylistIdsOk.contains(key.id));
      final removePlaylists =
          LinkedHashMap<Playlist, Set<String>>.from(clientPlaylistShaderIds)
            ..removeWhere((key, value) => !storePlaylistIdsOk.contains(key.id));
      final local = storePlaylists.map((fpr) => PlaylistSyncTask(fpr));
      final added = await _addPlaylists(addPlaylists)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deletePlaylists(removePlaylists)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removedPlaylistIds = removed
          .map((PlaylistSyncTask task) => task.response.playlist?.id)
          .whereType<String>();
      final currentPlaylists = [...local, ...added]..removeWhere((element) =>
          removedPlaylistIds.contains(element.response.playlist?.id ?? ''));

      return PlaylistSyncResult(
          current: currentPlaylists, added: added, removed: removed);
    } else {
      if (!storeSyncsResponse.ok) {
        runner.log(
            'Error obtaining syncs from the local store: ${storeSyncsResponse.error?.message}');
      } else {
        runner.log(
            'Error obtaining playlist ids from the local store: ${storePlaylistResponse.error?.message}');
      }
    }

    return PlaylistSyncResult();
  }

  /// Synchronizes a list of [playlistIds]
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [userSync]: The user synchronization result
  /// * [playlistIds]: The list playlist ids
  Future<PlaylistSyncResult> syncPlaylists(ShaderSyncResult shaderSync,
      UserSyncResult userSync, List<String> playlistIds) async {
    final playlistSyncResult =
        await _syncPlaylists(shaderSync, userSync, playlistIds);

    return playlistSyncResult;
  }
}
