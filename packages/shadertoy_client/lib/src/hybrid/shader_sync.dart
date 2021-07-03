import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy/shadertoy_util.dart';

import 'hybrid_client.dart';
import 'sync.dart';

class ShaderSyncTask extends SyncTask<FindShaderResponse> {
  ShaderSyncTask(FindShaderResponse response) : super.one(response);
}

class ShaderSyncResult extends SyncResult<ShaderSyncTask> {
  final List<ShaderSyncTask> current;

  Iterable<Info> get _currentShaderInfo =>
      current.map((task) => task.response.shader?.info).whereType<Info>();

  Set<String> get currentShaderIds =>
      _currentShaderInfo.map((info) => info.id).toSet();

  Set<String> get currentUserIds =>
      _currentShaderInfo.map((info) => info.userId).toSet();

  Set<String> _shaderInputSourcePaths(List<ShaderSyncTask> tasks) {
    final paths = <String>{};
    for (final task in tasks) {
      for (var rp in task.response.shader?.renderPasses ?? []) {
        final inputs = rp.inputs;

        if (inputs != null) {
          for (var i in inputs) {
            if (i.type == InputType.buffer || i.type == InputType.texture) {
              final src = i.src ?? i.filePath;
              if (src != null && src.isNotEmpty) {
                paths.add(picturePath(src));
              }
            }
          }
        }
      }
    }

    return paths;
  }

  Set<String> get currentShaderInputSourcePaths =>
      _shaderInputSourcePaths(current);

  Iterable<Info> get _addedShaderInfo =>
      added.map((task) => task.response.shader?.info).whereType<Info>();

  Set<String> get addedShaderIds =>
      _addedShaderInfo.map((info) => info.id).toSet();

  Set<String> get addedShaderInputSourcePaths => _shaderInputSourcePaths(added);

  Iterable<Info> get _removedShaderInfo =>
      removed.map((task) => task.response.shader?.info).whereType<Info>();

  Set<String> get removedShaderIds =>
      _removedShaderInfo.map((info) => info.id).toSet();

  Set<String> get removedShaderInputSourcePaths =>
      _shaderInputSourcePaths(removed);

  ShaderSyncResult(
      {this.current = const [],
      List<ShaderSyncTask>? added,
      List<ShaderSyncTask>? removed})
      : super(added: added, removed: removed);
}

class CommentTask extends SyncTask<FindCommentResponse> {
  CommentTask(FindCommentResponse response) : super.one(response);
}

class CommentsTask extends SyncTask<FindCommentsResponse> {
  CommentsTask(FindCommentsResponse response) : super.one(response);
}

class CommentTaskResult extends SyncResult<CommentTask> {
  CommentTaskResult({List<CommentTask>? added, List<CommentTask>? removed})
      : super(added: added, removed: removed);
}

class ShaderSyncProcessor extends SyncProcessor {
  static final Glob _ShaderMediaFiles =
      Glob('**/${ShadertoyContext.ShaderMediaPath}/*.jpg');
  static final Glob _ShaderInputSourceFiles = Glob(
      '**/{presets/*.jpg,media/{previz,a}/{*.png,*.jpg,*.mp3,*.bin,*.webm,*.ogv}}');

  ShaderSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            runner: runner, concurrency: concurrency, timeout: timeout);

  FindShaderResponse _getShaderError(dynamic e, String shaderId) {
    return FindShaderResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: CONTEXT_SHADER, target: shaderId));
  }

  Future<ShaderSyncTask> _addShader(String shaderId) {
    return client
        .findShaderById(shaderId)
        .then((apiShader) {
          final shader = apiShader.shader;
          if (shader != null) {
            store.saveShader(shader);
          }

          return apiShader;
        })
        .then((sr) => ShaderSyncTask(sr))
        .catchError((e) => ShaderSyncTask(_getShaderError(e, shaderId)));
  }

  Future<List<ShaderSyncTask>> _addShaders(Set<String> shaderIds) async {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _addShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Saving ${shaderIds.length} shader(s): ');
  }

  Future<ShaderSyncTask> _deleteShader(String shaderId) {
    return store
        .findShaderById(shaderId)
        .then((fsr) => store
            .deleteShaderById(shaderId)
            .then((value) => ShaderSyncTask(fsr)))
        .catchError((e) => ShaderSyncTask(_getShaderError(e, shaderId)));
  }

  Future<List<ShaderSyncTask>> _deleteShaders(Set<String> shaderIds) async {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _deleteShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Deleting ${shaderIds.length} shader(s): ');
  }

  Future<ShaderSyncResult> _syncShaders(List<String>? shaderIds) async {
    final storeResponse = await store.findAllShaders();

    if (storeResponse.ok) {
      final storeShaders = storeResponse.shaders ?? [];
      final storeInfos =
          storeShaders.map((fsr) => fsr.shader?.info).whereType<Info>();
      final storeShaderIds = storeInfos.map((info) => info.id).toSet();

      final clientResponse = shaderIds == null || shaderIds.isEmpty
          ? await client.findAllShaderIds()
          : FindShaderIdsResponse(ids: shaderIds);
      if (clientResponse.ok) {
        final clientShaderIds = (clientResponse.ids ?? []).toSet();
        final addShaderIds = clientShaderIds.difference(storeShaderIds);
        final removeShaderIds = storeShaderIds.difference(clientShaderIds);
        final local = storeShaders.map((fsr) => ShaderSyncTask(fsr));
        final added = await _addShaders(addShaderIds)
            .then((value) => value.where((task) => task.response.ok).toList());
        final removed = await _deleteShaders(removeShaderIds)
            .then((value) => value.where((task) => task.response.ok).toList());
        final removedShaderIds = removed
            .map((ShaderSyncTask task) => task.response.shader?.info.id)
            .whereType<String>();
        final currentShaders = [...local, ...added]..removeWhere((element) =>
            removedShaderIds.contains(element.response.shader?.info.id ?? ''));

        return ShaderSyncResult(
            current: currentShaders, added: added, removed: removed);
      } else {
        runner.log(
            'Error obtaining shader ids from the server: ${clientResponse.error?.message}');
      }
    } else {
      runner.log(
          'Error obtaining shader ids from the local store: ${storeResponse.error?.message}');
    }

    return ShaderSyncResult();
  }

  Future<List<CommentTask>> _clientComments(Set<String> shaderIds) async {
    final tasks = <Future<CommentsTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => store
          .findCommentsByShaderId(shaderId)
          .then((cr) => CommentsTask(cr))));
    }

    return runner
        .process<CommentsTask>(tasks,
            message:
                'Downloading comments from ${shaderIds.length} shader(s): ')
        .then((commentTasks) => [
              for (var commentTask in commentTasks)
                if (commentTask.response.ok)
                  for (var comment in commentTask.response.comments ?? [])
                    CommentTask(FindCommentResponse(comment: comment))
            ]);
  }

  FindCommentResponse getCommentError(dynamic e, String commentId) {
    return FindCommentResponse(
        error: ResponseError.unknown(
            message: e.toString(),
            context: CONTEXT_COMMENT,
            target: commentId));
  }

  Future<CommentTask> _addComment(Comment comment) {
    return store
        .saveShaderComments([comment])
        .then((_) => CommentTask(FindCommentResponse(comment: comment)))
        .catchError((e) => CommentTask(getCommentError(e, comment.id)));
  }

  Future<List<CommentTask>> _addComments(List<Comment> comments) async {
    final tasks = <Future<CommentTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final comment in comments) {
      tasks.add(taskPool.withResource(() => _addComment(comment)));
    }

    return runner.process<CommentTask>(tasks,
        message: 'Saving ${comments.length} comment(s): ');
  }

  Future<CommentTask> _deleteComment(Comment comment) {
    return store
        .deleteCommentById(comment.id)
        .then((value) => CommentTask(FindCommentResponse(comment: comment)))
        .catchError((e) => CommentTask(getCommentError(e, comment.id)));
  }

  Future<List<CommentTask>> _deleteComments(List<Comment> comments) async {
    final tasks = <Future<CommentTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final comment in comments) {
      tasks.add(taskPool.withResource(() => _deleteComment(comment)));
    }

    return runner.process<CommentTask>(tasks,
        message: 'Deleting ${comments.length} comment(s): ');
  }

  Future<CommentTaskResult> _syncShaderComments(
      ShaderSyncResult shaderSync) async {
    final storeResponse = await store.findAllComments();
    if (storeResponse.ok) {
      final storeComments = storeResponse.comments ?? [];
      final storeCommentMap = {
        for (var comment in storeComments) comment.id: comment
      };
      final storeCommentIds = storeCommentMap.keys.toSet();

      final clientCommentMap = <String, Comment>{};
      for (var commentTask
          in await _clientComments(shaderSync.currentShaderIds)) {
        final id = commentTask.response.comment?.id;
        final value = commentTask.response.comment;
        if (id != null && value != null) {
          clientCommentMap[id] = value;
        }
      }
      final clientCommentIds = {...clientCommentMap.keys};

      final addCommentIds = clientCommentIds.difference(storeCommentIds);
      final addComments = [
        for (var entry in clientCommentMap.entries)
          if (addCommentIds.contains(entry.key)) entry.value
      ];
      final removeCommentIds = storeCommentIds.difference(clientCommentIds);
      final removeComments = [
        for (var entry in storeCommentMap.entries)
          if (removeCommentIds.contains(entry.key)) entry.value
      ];

      final added = await _addComments(addComments)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deleteComments(removeComments)
          .then((value) => value.where((task) => task.response.ok).toList());

      return CommentTaskResult(added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining comment ids from the local store: ${storeResponse.error?.message}');
    }

    return CommentTaskResult();
  }

  Future<List<DownloadTask>> _addShaderPictures(
      FileSystem fs, Map<String, String> pathMap) async {
    final tasks = <Future<DownloadTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((shaderPicturePath, shaderPictureFilePath) {
      tasks.add(taskPool.withResource(() => addMedia(
          fs, shaderPicturePath, shaderPictureFilePath,
          context: CONTEXT_SHADER)));
    });

    return runner.process<DownloadTask>(tasks,
        message: 'Saving ${pathMap.length} shader picture(s): ');
  }

  Future<List<DownloadTask>> _deleteShaderPictures(
      FileSystem fs, Set<String> pathSet) async {
    final tasks = <Future<DownloadTask>>[];

    for (final shaderPictureFilePath in pathSet) {
      tasks
          .add(deleteMedia(fs, shaderPictureFilePath, context: CONTEXT_SHADER));
    }

    return runner.process<DownloadTask>(tasks,
        message: 'Deleting ${pathSet.length} shader picture(s): ');
  }

  Future<DownloadSyncResult> _syncShaderPictures(
      FileSystem fs, Directory dir, ShaderSyncResult shaderSync) async {
    final localShaderIds = <String>{};
    final shaderMediaPath = ShadertoyContext.ShaderMediaPath;
    await for (final path
        in listFiles(dir, _ShaderMediaFiles, recursive: true)) {
      localShaderIds.add(fileNameToShaderId(p.basenameWithoutExtension(path)));
    }

    final localShaderInputSources = <String>{};
    await for (final path
        in listFiles(dir, _ShaderInputSourceFiles, recursive: true)) {
      localShaderInputSources.add(p.relative(path, from: dir.path));
    }

    final shaderPictureRemotePath =
        (shaderId) => ShadertoyContext.shaderPicturePath(shaderId);
    final shaderPictureLocalPath = (shaderId) => p.join(
        dir.path, shaderMediaPath, '${shaderIdToFileName(shaderId)}.jpg');
    final shaderInputSourceLocalPath =
        (inputSource) => p.join(dir.path, inputSource);

    final currentShaderIds = shaderSync.currentShaderIds;
    final currentShaderInputSources = shaderSync.currentShaderInputSourcePaths;
    final addShaderPaths = {
      for (var shaderId in {
        ...shaderSync.addedShaderIds,
        ...currentShaderIds.difference(localShaderIds)
      })
        shaderPictureRemotePath(shaderId): shaderPictureLocalPath(shaderId)
    };
    for (var path in {
      ...shaderSync.addedShaderInputSourcePaths,
      ...currentShaderInputSources.difference(localShaderInputSources)
    }) {
      addShaderPaths.putIfAbsent(path, () => shaderInputSourceLocalPath(path));
    }

    final removeShaderPaths = {
      ...shaderSync.removedShaderIds,
      ...localShaderIds.difference(currentShaderIds)
    }.map((shaderId) => shaderPictureLocalPath(shaderId)).toSet();
    for (var path in {
      ...shaderSync.removedShaderInputSourcePaths,
      ...localShaderInputSources.difference(currentShaderInputSources)
    }) {
      removeShaderPaths.add(shaderInputSourceLocalPath(path));
    }

    final added = await _addShaderPictures(fs, addShaderPaths)
        .then((value) => value.where((task) => task.response.ok).toList());
    final removed = await _deleteShaderPictures(fs, removeShaderPaths)
        .then((value) => value.where((task) => task.response.ok).toList());

    return DownloadSyncResult(added: added, removed: removed);
  }

  Future<ShaderSyncResult> syncShaders(
      {FileSystem? fs, Directory? dir, List<String>? shaderIds}) async {
    final shaderSyncResult = await _syncShaders(shaderIds);
    await _syncShaderComments(shaderSyncResult);
    if (fs != null) {
      await _syncShaderPictures(
          fs, dir ?? fs.currentDirectory, shaderSyncResult);
    }

    return shaderSyncResult;
  }
}
