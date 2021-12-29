import 'dart:collection';

import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';

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

  /// Sanitizes the picture path
  ///
  /// * [path]: The picture path
  String picturePath(String path) =>
      p.isAbsolute(path) ? path.substring(1) : path;

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
  final ShadertoyStore store;

  /// The [SyncTaskRunner] that will be used in this processor
  final SyncTaskRunner runner;

  /// The number of concurrent tasks
  final int concurrency;

  /// The maximum timeout waiting for a task completion
  final int timeout;

  /// The [SyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [store]: The [ShadertoyStore] instance
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  SyncProcessor(this.client, this.store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : runner = runner ?? const DefaultTaskRunner(),
        concurrency = concurrency ?? 10,
        timeout = timeout ?? 30;

  /// Lists the files on a directory according with a [Glob] expression
  ///
  /// * [dir]: The directory
  /// * [glob]: The glob class
  /// * [recusive]: If the file list should be recursive
  /// * [followLinks]: If the links should be followed
  @protected
  Stream<String> listFiles(Directory dir, Glob glob,
      {bool recursive = false, bool followLinks = false}) {
    return dir
        .list(recursive: recursive, followLinks: followLinks)
        .map((entity) => entity.path)
        .where((path) => glob.matches(path));
  }

  /// Reads the bytes of a [File] and creates a [DownloadFileResponse] from them
  ///
  /// * [file]: The file
  Future<DownloadFileResponse> _getDownloadFileResponse(File file) {
    return file
        .readAsBytes()
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
  /// * [fs]: The [FileSystem]
  /// * [context]: The context
  /// * [mediaPath]: The media path
  /// * [mediaFilePath]: The media file path
  Future<DownloadFileResponse> _addMedia(
      FileSystem fs, String context, String mediaPath, String mediaFilePath) {
    final mediaFile = fs.file(mediaFilePath);

    return mediaFile.exists().then((exists) => exists
        ? _getDownloadFileResponse(mediaFile)
        : client.downloadMedia('/' + mediaPath).then((apiFile) {
            final bytes = apiFile.bytes;
            final error = apiFile.error;
            if (bytes != null) {
              return mediaFile.parent.create(recursive: true).then((value) =>
                  mediaFile.writeAsBytes(bytes).then((f) => apiFile));
            }
            return Future.value(
                DownloadFileResponse(error: error?.copyWith(context: context)));
          }));
  }

  @protected
  Future<DownloadSyncTask> syncMedia(
      FileSystem fs, String context, String mediaPath, String mediaFilePath) {
    return store.findSyncById(SyncType.asset, mediaPath).then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: SyncType.asset,
                target: mediaPath,
                status: SyncStatus.pending,
                creationTime: DateTime.now());
        return store.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addMedia(fs, context, mediaPath, mediaFilePath)
                .then((DownloadFileResponse dfile) {
              final posSync = dfile.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: dfile.error?.message,
                      updateTime: DateTime.now());

              return store.saveSync(posSync).then((ssync2) {
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
  /// * [fs]: The [FileSystem]
  /// * [context]: An optional context
  /// * [mediaPath]: The media path
  /// * [mediaFilePath]: The media file path
  @protected
  Future<DownloadSyncTask> deleteMedia(
      FileSystem fs, String context, String mediaPath, String mediaFilePath) {
    final mediaFile = fs.file(mediaFilePath);

    return mediaFile.exists().then((exists) => exists
        ? _getDownloadFileResponse(mediaFile)
            .then((dfr) => mediaFile.delete().then((_) {
                  return store.deleteSyncById(SyncType.asset, mediaPath).then(
                      (dsync) => DownloadSyncTask(_getDownloadResponse(
                          context, mediaPath,
                          response: dsync)));
                }))
            .catchError((e) => DownloadSyncTask(
                _getDownloadResponse(context, mediaFilePath, e: e)))
        : Future.value(DownloadSyncTask(DownloadFileResponse())));
  }
}
