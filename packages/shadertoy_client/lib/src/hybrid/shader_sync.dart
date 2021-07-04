import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy/shadertoy_util.dart';

import 'hybrid_client.dart';
import 'sync.dart';

/// A shader synchronization task
class ShaderSyncTask extends SyncTask<FindShaderResponse> {
  /// The [ShaderSyncTask] constructor
  ///
  /// * [response]: The [FindShaderResponse] associated with this task
  ShaderSyncTask(FindShaderResponse response) : super.one(response);
}

/// The result of a shader synchronization task
class ShaderSyncResult extends SyncResult<ShaderSyncTask> {
  /// The current task
  final List<ShaderSyncTask> current;

  /// The current shader info
  Iterable<Info> get _currentShaderInfo =>
      current.map((task) => task.response.shader?.info).whereType<Info>();

  /// The current shader ids
  Set<String> get currentShaderIds =>
      _currentShaderInfo.map((info) => info.id).toSet();

  /// The current user ids
  Set<String> get currentUserIds =>
      _currentShaderInfo.map((info) => info.userId).toSet();

  /// Extracts the list of input source paths from a list of [ShaderSyncTask]s
  ///
  /// * [tasks]: A list of tasks
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

  /// The current shader input source paths
  Set<String> get currentShaderInputSourcePaths =>
      _shaderInputSourcePaths(current);

  /// The added shader infos
  Iterable<Info> get _addedShaderInfo =>
      added.map((task) => task.response.shader?.info).whereType<Info>();

  /// The added shader id's
  Set<String> get addedShaderIds =>
      _addedShaderInfo.map((info) => info.id).toSet();

  /// The added shader input source paths
  Set<String> get addedShaderInputSourcePaths => _shaderInputSourcePaths(added);

  /// The removed shader infos
  Iterable<Info> get _removedShaderInfo =>
      removed.map((task) => task.response.shader?.info).whereType<Info>();

  /// The removed shader ids
  Set<String> get removedShaderIds =>
      _removedShaderInfo.map((info) => info.id).toSet();

  /// The removed shader input source paths
  Set<String> get removedShaderInputSourcePaths =>
      _shaderInputSourcePaths(removed);

  /// The [ShaderSyncResult] constructor
  ///
  /// * [current]: The current [ShaderSyncTask]
  /// * [added]: The list of added [ShaderSyncTask]s
  /// * [removed]: The list of removed [ShaderSyncTask]s
  ShaderSyncResult(
      {this.current = const [],
      List<ShaderSyncTask>? added,
      List<ShaderSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// A comment synchronization task
class CommentSyncTask extends SyncTask<FindCommentResponse> {
  /// The [CommentSyncTask] constructor
  ///
  /// * [response]: The [FindCommentResponse] associated with this task
  CommentSyncTask(FindCommentResponse response) : super.one(response);
}

/// A comments synchronization task
class CommentsSyncTask extends SyncTask<FindCommentsResponse> {
  /// The [CommentsSyncTask] constructor
  ///
  /// * [response]: The [FindCommentsResponse] associated with this task
  CommentsSyncTask(FindCommentsResponse response) : super.one(response);
}

/// The result of a comment synchronization task
class CommentTaskResult extends SyncResult<CommentSyncTask> {
  /// The [CommentTaskResult] constructor
  ///
  /// * [added]: The list of added [CommentSyncTask]s
  /// * [removed]: The list of removed [CommentSyncTask]s
  CommentTaskResult(
      {List<CommentSyncTask>? added, List<CommentSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// The processor of shader synchronization tasks
class ShaderSyncProcessor extends SyncProcessor {
  /// A [Glob] defining the location of the local shader media files
  static final Glob _shaderMediaFiles =
      Glob('**/${ShadertoyContext.shaderMediaPath}/*.jpg');

  /// A [Glob] defining the location of the local shader input source files
  static final Glob _shaderInputSourceFiles = Glob(
      '**/{presets/*.jpg,media/{previz,a}/{*.png,*.jpg,*.mp3,*.bin,*.webm,*.ogv}}');

  /// The [ShaderSyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [store]: The [ShadertoyStore] instance
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  ShaderSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            runner: runner, concurrency: concurrency, timeout: timeout);

  /// Creates a [FindShaderResponse] with a error
  ///
  /// * [e]: The error cause
  /// * [shaderId]: The shader id
  FindShaderResponse _getShaderError(dynamic e, String shaderId) {
    return FindShaderResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: contextShader, target: shaderId));
  }

  /// Saves a shader with id equal to [shaderId]
  ///
  /// * [shaderId]: The shader id
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

  /// Saves a list of shaders with [shaderIds]
  ///
  /// * [shaderIds]: The list shader ids
  Future<List<ShaderSyncTask>> _addShaders(Set<String> shaderIds) async {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _addShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Saving ${shaderIds.length} shader(s): ');
  }

  /// Deletes a shader with id [shaderId]
  ///
  /// * [shaderId]: The shader id
  Future<ShaderSyncTask> _deleteShader(String shaderId) {
    return store
        .findShaderById(shaderId)
        .then((fsr) => store
            .deleteShaderById(shaderId)
            .then((value) => ShaderSyncTask(fsr)))
        .catchError((e) => ShaderSyncTask(_getShaderError(e, shaderId)));
  }

  /// Deletes a list of shaders with [shaderIds]
  ///
  /// * [shaderIds]: The list shader ids
  Future<List<ShaderSyncTask>> _deleteShaders(Set<String> shaderIds) async {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _deleteShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Deleting ${shaderIds.length} shader(s): ');
  }

  /// Synchronizes shaders
  ///
  /// * [shaderIds]: An optional list of shader ids
  Future<ShaderSyncResult> _syncShaders({List<String>? shaderIds}) async {
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

  /// Obtains the list of comments for each shader id provided in [shaderIds]
  ///
  /// * [shaderIds]: The list of shader ids
  Future<List<CommentSyncTask>> _clientComments(Set<String> shaderIds) async {
    final tasks = <Future<CommentsSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => store
          .findCommentsByShaderId(shaderId)
          .then((cr) => CommentsSyncTask(cr))));
    }

    return runner
        .process<CommentsSyncTask>(tasks,
            message:
                'Downloading comments from ${shaderIds.length} shader(s): ')
        .then((commentTasks) => [
              for (var commentTask in commentTasks)
                if (commentTask.response.ok)
                  for (var comment in commentTask.response.comments ?? [])
                    CommentSyncTask(FindCommentResponse(comment: comment))
            ]);
  }

  /// Creates a [FindCommentResponse] with a error
  ///
  /// * [e]: The error cause
  /// * [commentId]: The comment id
  FindCommentResponse getCommentError(dynamic e, String commentId) {
    return FindCommentResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: contextComment, target: commentId));
  }

  /// Saves a comment
  ///
  /// * [comment]: The comment to save
  Future<CommentSyncTask> _addComment(Comment comment) {
    return store
        .saveShaderComments([comment])
        .then((_) => CommentSyncTask(FindCommentResponse(comment: comment)))
        .catchError((e) => CommentSyncTask(getCommentError(e, comment.id)));
  }

  /// Saves a list of comments
  ///
  /// * [comments]: The list comments
  Future<List<CommentSyncTask>> _addComments(List<Comment> comments) async {
    final tasks = <Future<CommentSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final comment in comments) {
      tasks.add(taskPool.withResource(() => _addComment(comment)));
    }

    return runner.process<CommentSyncTask>(tasks,
        message: 'Saving ${comments.length} comment(s): ');
  }

  /// Deletes a comment
  ///
  /// * [comment]: The comment
  Future<CommentSyncTask> _deleteComment(Comment comment) {
    return store
        .deleteCommentById(comment.id)
        .then((value) => CommentSyncTask(FindCommentResponse(comment: comment)))
        .catchError((e) => CommentSyncTask(getCommentError(e, comment.id)));
  }

  /// Deletes a list of comments
  ///
  /// * [comments]: The list comments
  Future<List<CommentSyncTask>> _deleteComments(List<Comment> comments) async {
    final tasks = <Future<CommentSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final comment in comments) {
      tasks.add(taskPool.withResource(() => _deleteComment(comment)));
    }

    return runner.process<CommentSyncTask>(tasks,
        message: 'Deleting ${comments.length} comment(s): ');
  }

  /// Synchronizes a list of comments from a previously synchronized list of shaders
  ///
  /// * [shaderSync]: The shader synchronization result
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

  /// Stores a list of shader pictures
  ///
  /// * [fs]: The [FileSystem]
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _addShaderPictures(
      FileSystem fs, Map<String, String> pathMap) async {
    final tasks = <Future<DownloadSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((shaderPicturePath, shaderPictureFilePath) {
      tasks.add(taskPool.withResource(() => addMedia(
          fs, shaderPicturePath, shaderPictureFilePath,
          context: contextShader)));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Saving ${pathMap.length} shader picture(s): ');
  }

  /// Deletes a list of shader pictures
  ///
  /// * [fs]: The [FileSystem]
  /// * [pathSet]: A set of shader picture paths to delete
  Future<List<DownloadSyncTask>> _deleteShaderPictures(
      FileSystem fs, Set<String> pathSet) async {
    final tasks = <Future<DownloadSyncTask>>[];

    for (final shaderPictureFilePath in pathSet) {
      tasks.add(deleteMedia(fs, shaderPictureFilePath, context: contextShader));
    }

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Deleting ${pathSet.length} shader picture(s): ');
  }

  /// Synchronizes the pictures from a shader
  ///
  /// * [fs]: The [FileSystem]
  /// * [dir]: The target directory on the [FileSystem]
  /// * [shaderSync]: The shader synchronization result
  Future<DownloadSyncResult> _syncShaderPictures(
      FileSystem fs, Directory dir, ShaderSyncResult shaderSync) async {
    final localShaderIds = <String>{};
    final shaderMediaPath = ShadertoyContext.shaderMediaPath;
    await for (final path
        in listFiles(dir, _shaderMediaFiles, recursive: true)) {
      localShaderIds.add(fileNameToShaderId(p.basenameWithoutExtension(path)));
    }

    final localShaderInputSources = <String>{};
    await for (final path
        in listFiles(dir, _shaderInputSourceFiles, recursive: true)) {
      localShaderInputSources.add(p.relative(path, from: dir.path));
    }

    shaderPictureRemotePath(shaderId) =>
        ShadertoyContext.shaderPicturePath(shaderId);
    shaderPictureLocalPath(shaderId) => p.join(
        dir.path, shaderMediaPath, '${shaderIdToFileName(shaderId)}.jpg');
    shaderInputSourceLocalPath(inputSource) => p.join(dir.path, inputSource);

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

  /// Synchronizes the pictures from a shader
  ///
  /// * [fs]: The [FileSystem]
  /// * [dir]: The target directory on the [FileSystem]
  /// * [shaderSync]: The shader synchronization result
  Future<ShaderSyncResult> syncShaders(
      {FileSystem? fs, Directory? dir, List<String>? shaderIds}) async {
    final shaderSyncResult = await _syncShaders(shaderIds: shaderIds);
    await _syncShaderComments(shaderSyncResult);
    if (fs != null) {
      await _syncShaderPictures(
          fs, dir ?? fs.currentDirectory, shaderSyncResult);
    }

    return shaderSyncResult;
  }
}
