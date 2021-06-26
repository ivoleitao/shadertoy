import 'dart:collection';

import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';

import 'hybrid_client.dart';

class DefaultTaskRunner implements SyncTaskRunner {
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

abstract class SyncTask<T extends APIResponse> with IterableMixin<APIResponse> {
  final List<T> responses;

  T get response => responses.first;

  SyncTask._(List<T> responses) : responses = responses;

  SyncTask.one(T response) : this._([response]);

  SyncTask.all({List<T>? responses}) : responses = responses ?? [];

  @override
  Iterator<APIResponse> get iterator => responses.iterator;
}

class DownloadTask extends SyncTask<DownloadFileResponse> {
  DownloadTask(DownloadFileResponse response) : super.one(response);
}

class SyncResult<T extends SyncTask> {
  final List<T> added;
  final List<T> removed;

  String picturePath(String path) =>
      p.isAbsolute(path) ? path.substring(1) : path;

  SyncResult({List<T>? added, List<T>? removed})
      : added = added ?? const [],
        removed = removed ?? const [];
}

class DownloadSyncResult extends SyncResult<DownloadTask> {
  DownloadSyncResult({List<DownloadTask>? added, List<DownloadTask>? removed})
      : super(added: added, removed: removed);
}

abstract class SyncProcessor {
  final ShadertoyHybridClient client;
  final ShadertoyStore store;
  final SyncTaskRunner runner;
  final int concurrency;
  final int timeout;

  SyncProcessor(this.client, this.store,
      {SyncTaskRunner? processor, int? concurrency, int? timeout})
      : runner = processor ?? const DefaultTaskRunner(),
        concurrency = concurrency ?? 10,
        timeout = timeout ?? 30;

  @protected
  Stream<String> listFiles(Directory dir, Glob glob,
      {bool recursive = false, bool followLinks = false}) {
    return dir
        .list(recursive: recursive, followLinks: followLinks)
        .map((entity) => entity.path)
        .where((path) => glob.matches(path));
  }

  Future<DownloadFileResponse> _getDownloadFileResponse(File file) {
    return file
        .readAsBytes()
        .then((bytes) => DownloadFileResponse(bytes: bytes));
  }

  @protected
  DownloadFileResponse getMediaError(dynamic e, String mediaPath,
      {String? context}) {
    return DownloadFileResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: context, target: mediaPath));
  }

  @protected
  Future<DownloadTask> addMedia(
      FileSystem fs, String mediaPath, String mediaFilePath,
      {String? context}) {
    final mediaFile = fs.file(mediaFilePath);

    return mediaFile
        .exists()
        .then((exists) => exists
            ? _getDownloadFileResponse(mediaFile)
            : client.downloadMedia('/' + mediaPath).then((apiFile) {
                final bytes = apiFile.bytes;
                final error = apiFile.error;
                if (bytes != null) {
                  return mediaFile.parent.create(recursive: true).then(
                      (value) =>
                          mediaFile.writeAsBytes(bytes).then((f) => apiFile));
                }
                return Future.value(DownloadFileResponse(
                    error: error?.copyWith(context: context)));
              }))
        .then((df) => DownloadTask(df))
        .catchError(
            (e) => DownloadTask(getMediaError(e, mediaPath, context: context)));
  }

  @protected
  Future<DownloadTask> deleteMedia(FileSystem fs, String mediaFilePath,
      {String? context}) {
    final mediaFile = fs.file(mediaFilePath);

    return mediaFile.exists().then((exists) => exists
        ? _getDownloadFileResponse(mediaFile)
            .then(
                (dfr) => mediaFile.delete().then((value) => DownloadTask(dfr)))
            .catchError((e) =>
                DownloadTask(getMediaError(e, mediaFilePath, context: context)))
        : Future.value(DownloadTask(DownloadFileResponse())));
  }
}
