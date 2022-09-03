import 'dart:collection';
import 'dart:typed_data';

import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:stash/stash_api.dart';

import 'hybrid_client.dart';

/// A default task runner which prints to stdout the logs and does a simple
/// `Future.wait` on the tasks
class DefaultTaskRunner implements SyncTaskRunner {
  /// The [DefaultTaskRunner] constructor
  const DefaultTaskRunner();

  @override
  void log(String? message) {
    print(message);
  }

  @override
  Future<List<T>> process<T extends IterableMixin<APIResponse>>(
      List<Future<T>> tasks,
      {String? message}) {
    log(message);
    return Future.wait(tasks);
  }
}

/// Base definition of a synchronization task
abstract class SyncTask<T extends APIResponse> with IterableMixin<APIResponse> {
  /// The list of responses
  final List<T> responses;

  /// The first response
  T get response => responses.first;

  /// Initializes the [SyncTask] with a list of responses
  ///
  /// * [responses]: The list of responses
  SyncTask._(this.responses);

  /// Initializes the [SyncTask] with a singular response
  ///
  /// * [response]: The response
  SyncTask.one(T response) : this._([response]);

  @override
  Iterator<APIResponse> get iterator => responses.iterator;
}

/// A download synchronization task
class DownloadSyncTask extends SyncTask<DownloadFileResponse> {
  /// The [DownloadSyncTask] constructor
  ///
  /// * [response]: The [DownloadFileResponse] associated with this task
  DownloadSyncTask(DownloadFileResponse response) : super.one(response);
}

/// A base class defining the result of a synchronization task
class SyncResult<T extends SyncTask> {
  /// The list of added tasks
  final List<T> added;

  /// The list of removed tasks
  final List<T> removed;

  /// The [SyncResult] constructur
  ///
  /// * [added]: The list of added entities
  /// * [removed]: The list of removed entities
  SyncResult({List<T>? added, List<T>? removed})
      : added = added ?? const [],
        removed = removed ?? const [];
}

/// The result of a download synchronization task
class DownloadSyncResult extends SyncResult<DownloadSyncTask> {
  /// The [DownloadSyncResult] constructor
  ///
  /// * [added]: The list of added [DownloadSyncTask]s
  /// * [removed]: The list of removed [DownloadSyncTask]s
  DownloadSyncResult(
      {List<DownloadSyncTask>? added, List<DownloadSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// The processor of synchronization tasks
abstract class SyncProcessor {
  /// The [ShadertoyHybridClient] instance
  final ShadertoyHybridClient client;

  /// The [ShadertoyStore] instance
  final ShadertoyStore metadataStore;

  /// The [VaultStore] instance
  final VaultStore assetStore;

  /// The [SyncTaskRunner] that will be used in this processor
  final SyncTaskRunner runner;

  /// The number of concurrent tasks
  final int concurrency;

  /// The maximum timeout waiting for a task completion
  final int timeout;

  /// The [SyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [metadataStore]: A [ShadertoyStore] implementation to store the metadata
  /// * [assetStore]: A [VaultStore] implementation to store shader and user assets
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  SyncProcessor(this.client, this.metadataStore, this.assetStore,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : runner = runner ?? const DefaultTaskRunner(),
        concurrency = concurrency ?? 10,
        timeout = timeout ?? 30;

  /// Lists the files on a vault according with a [Glob] expression
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [glob]: The glob class
  @protected
  Future<Iterable<String>> listPaths(Vault<Uint8List> vault, Glob glob) {
    return vault.keys.then((keys) {
      return keys.where((key) => glob.matches(key));
    });
  }

  /// Reads the bytes from the [Vault] creates a [DownloadFileResponse] from them
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [mediaFilePath]: The media file path
  Future<DownloadFileResponse> _getDownloadFileResponse(
      Vault<Uint8List> vault, String mediaFilePath) {
    return vault
        .get(mediaFilePath)
        .then((bytes) => DownloadFileResponse(bytes: bytes));
  }

  /// Creates a [DownloadFileResponse]
  ///
  /// * [context]: The context
  /// * [mediaPath]: The media path
  /// * [dfile]: The download file response
  /// * [response]: The response
  /// * [e]: The error cause
  DownloadFileResponse _getDownloadResponse(String context, String mediaPath,
      {DownloadFileResponse? dfile, APIResponse? response, dynamic e}) {
    if (dfile != null && response != null && response.ok) {
      return dfile;
    }
    return DownloadFileResponse(
        error: response?.error ??
            ResponseError.unknown(
                message: e.toString(), context: context, target: mediaPath));
  }

  /// Creates a media file on a [FileSystem]
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [context]: The context
  /// * [mediaPath]: The media path
  /// * [mediaFilePath]: The media file path
  Future<DownloadFileResponse> _addMedia(Vault<Uint8List> vault, String context,
      String mediaPath, String mediaFilePath) {
    return vault.containsKey(mediaFilePath).then((exists) => exists
        ? _getDownloadFileResponse(vault, mediaFilePath)
        : client.downloadMedia('/$mediaPath').then((apiFile) {
            final bytes = apiFile.bytes;
            final error = apiFile.error;
            if (bytes != null) {
              return vault
                  .put(mediaFilePath, Uint8List.fromList(bytes))
                  .then((f) => apiFile);
            }

            return Future.value(
                DownloadFileResponse(error: error?.copyWith(context: context)));
          }));
  }

  @protected

  /// Syncs a media file store on a [Vault]
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [syncType]: The sync type
  /// * [context]: The context
  /// * [mediaPath]: The media path
  /// * [mediaFilePath]: The media file path
  Future<DownloadSyncTask> syncMedia(Vault<Uint8List> vault, SyncType syncType,
      String context, String mediaPath, String mediaFilePath) {
    return metadataStore.findSyncById(syncType, mediaPath).then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: syncType,
                target: mediaPath,
                status: SyncStatus.pending,
                creationTime: DateTime.now());
        return metadataStore.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addMedia(vault, context, mediaPath, mediaFilePath)
                .then((DownloadFileResponse dfile) {
              final posSync = dfile.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: dfile.error?.message,
                      updateTime: DateTime.now());

              return metadataStore.saveSync(posSync).then((ssync2) {
                return Future.value(DownloadSyncTask(_getDownloadResponse(
                    context, mediaPath,
                    dfile: dfile, response: ssync2)));
              });
            });
          }

          return Future.value(DownloadSyncTask(
              _getDownloadResponse(context, mediaPath, response: ssync1)));
        });
      }
      return Future.value(DownloadSyncTask(
          _getDownloadResponse(context, mediaPath, response: fsync)));
    }).catchError((e) =>
        DownloadSyncTask(_getDownloadResponse(context, mediaPath, e: e)));
  }

  /// Deletes a media file from a [FileSystem]
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [syncType]: The [SyncType]
  /// * [context]: An optional context
  /// * [mediaPath]: The media path
  /// * [mediaFilePath]: The media file path
  @protected
  Future<DownloadSyncTask> deleteMedia(
      Vault<Uint8List> vault,
      SyncType syncType,
      String context,
      String mediaPath,
      String mediaFilePath) {
    return vault.containsKey(mediaFilePath).then((exists) => exists
        ? _getDownloadFileResponse(vault, mediaFilePath)
            .then((dfr) => vault.remove(mediaFilePath).then((_) {
                  return metadataStore.deleteSyncById(syncType, mediaPath).then(
                      (dsync) => DownloadSyncTask(_getDownloadResponse(
                          context, mediaPath,
                          response: dsync)));
                }))
            .catchError((e) => DownloadSyncTask(
                _getDownloadResponse(context, mediaFilePath, e: e)))
        : Future.value(DownloadSyncTask(DownloadFileResponse())));
  }
}
