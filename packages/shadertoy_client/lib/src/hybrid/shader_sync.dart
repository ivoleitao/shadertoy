import 'dart:typed_data';

import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy/shadertoy_util.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:stash/stash_api.dart' show Vault, VaultStore, VaultExtension;

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

  /// Obtains a list of shaders and optionally applies a filter
  ///
  /// [tasks]: The list of tasks to consider
  /// [test]: A filter to apply to the list of shaders
  Iterable<Shader> _shaders(List<ShaderSyncTask> tasks,
      {bool Function(Shader)? test}) {
    final shaders =
        tasks.map((task) => task.response.shader).whereType<Shader>();
    if (test != null) {
      return shaders.where(test);
    }
    return shaders;
  }

  /// The current shader ids
  Set<String> get currentShaderIds =>
      _shaders(current).map((shader) => shader.info.id).toSet();

  /// The filtered list of current shader ids
  ///
  /// * [test]: The filter
  Set<String> currentShaderIdsWhere({bool Function(Shader)? test}) =>
      _shaders(current, test: test).map((shader) => shader.info.id).toSet();

  /// The current user ids
  Set<String> get currentUserIds =>
      _shaders(current).map((shader) => shader.info.userId).toSet();

  /// Extracts the list of input source paths from a list of [ShaderSyncTask]s
  ///
  /// * [tasks]: A list of tasks
  Set<String> _shaderInputSourcePaths(List<ShaderSyncTask> tasks) {
    final paths = <String>{};
    for (final task in tasks) {
      final shader = task.response.shader;
      if (shader != null) {
        paths.addAll(shader.inputSourcePaths());
      }
    }

    return paths;
  }

  /// The current shader input source paths
  Set<String> get currentShaderInputSourcePaths =>
      _shaderInputSourcePaths(current);

  /// The added shader id's
  Set<String> get addedShaderIds =>
      _shaders(added).map((shader) => shader.info.id).toSet();

  /// The filtered list of added shader ids
  ///
  /// * [test]: The filter
  Set<String> addedShaderIdsWhere({bool Function(Shader)? test}) =>
      _shaders(added, test: test).map((shader) => shader.info.id).toSet();

  /// The added shader input source paths
  Set<String> get addedShaderInputSourcePaths => _shaderInputSourcePaths(added);

  /// The removed shader ids
  Set<String> get removedShaderIds =>
      _shaders(removed).map((shader) => shader.info.id).toSet();

  /// The filtered list of removed shader ids
  ///
  /// * [test]: The filter
  Set<String> removedShaderIdsWhere({bool Function(Shader)? test}) =>
      _shaders(removed, test: test).map((shader) => shader.info.id).toSet();

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
class CommentTaskResult extends SyncResult<CommentsSyncTask> {
  /// The [CommentTaskResult] constructor
  ///
  /// * [added]: The list of added [CommentSyncTasks]s
  /// * [removed]: The list of removed [CommentSyncTask]s
  CommentTaskResult(
      {List<CommentsSyncTask>? added, List<CommentsSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// The processor of shader synchronization tasks
///
class ShaderSyncProcessor extends SyncProcessor {
  /// The name of the shader media vault
  static const shaderMediaVaultName = 'shaderMedia';

  /// A [Glob] defining the location of the local shader media files
  static final Glob _shaderMediaFiles =
      Glob('${ShadertoyContext.shaderMediaPath}/*.jpg');

  /// A [Glob] defining the location of the local shader input source files
  static final Glob _shaderInputSourceFiles = Glob(
      '{presets/*.jpg,media/{previz,a}/{*.png,*.jpg,*.mp3,*.bin,*.webm,*.ogv}}');

  /// The [ShaderSyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [metadataStore]: A [ShadertoyStore] implementation to store the metadata
  /// * [assetStore]: A [VaultStore] implementation to store shader and user assets
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  ShaderSyncProcessor(ShadertoyHybridClient client,
      ShadertoyStore metadataStore, VaultStore assetStore,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, metadataStore, assetStore,
            runner: runner, concurrency: concurrency, timeout: timeout);

  /// Creates a [FindShaderResponse] with a error
  ///
  /// * [shaderId]: The shader id
  /// * [fshader]: The shader response
  /// * [response]: The response
  /// * [e]: The error cause
  FindShaderResponse _getShaderResponse(String shaderId,
      {FindShaderResponse? fshader, APIResponse? response, dynamic e}) {
    if (fshader != null && response != null && response.ok) {
      return fshader;
    }

    return FindShaderResponse(
        error: response?.error ??
            ResponseError.unknown(
                message: e.toString(),
                context: contextShader,
                target: shaderId));
  }

  /// Saves a shader with id equal to [shaderId]
  ///
  /// * [shaderId]: The shader id
  Future<FindShaderResponse> _addShader(String shaderId) {
    return client.findShaderById(shaderId).then((fshader) {
      final shader = fshader.shader;
      if (shader != null) {
        return metadataStore.saveShader(shader).then((sshader) =>
            _getShaderResponse(shaderId, fshader: fshader, response: sshader));
      }

      return Future.value(_getShaderResponse(shaderId, response: fshader));
    });
  }

  /// Syncs a shader with id equal to [shaderId]
  ///
  /// * [shaderId]: The shader id
  Future<ShaderSyncTask> _syncShader(String shaderId) {
    return metadataStore.findSyncById(SyncType.shader, shaderId).then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: SyncType.shader,
                target: shaderId,
                status: SyncStatus.pending,
                creationTime: DateTime.now());

        return metadataStore.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addShader(shaderId).then((FindShaderResponse fshader) {
              final posSync = fshader.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: fshader.error?.message,
                      updateTime: DateTime.now());

              return metadataStore.saveSync(posSync).then((ssync2) {
                return Future.value(ShaderSyncTask(_getShaderResponse(shaderId,
                    fshader: fshader, response: ssync2)));
              });
            });
          }

          return Future.value(
              ShaderSyncTask(_getShaderResponse(shaderId, response: ssync1)));
        });
      }

      return Future.value(
          ShaderSyncTask(_getShaderResponse(shaderId, response: fsync)));
    }).catchError((e) => ShaderSyncTask(_getShaderResponse(shaderId, e: e)));
  }

  /// Saves a list of shaders with [shaderIds]
  ///
  /// * [shaderIds]: The list shader ids
  Future<List<ShaderSyncTask>> _addShaders(Set<String> shaderIds) {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _syncShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Saving ${shaderIds.length} shader(s)');
  }

  /// Deletes a shader with id [shaderId]
  ///
  /// * [shaderId]: The shader id
  Future<ShaderSyncTask> _deleteShader(String shaderId) {
    return metadataStore
        .findShaderById(shaderId)
        .then((fsr) => metadataStore
            .deleteShaderById(shaderId)
            .then((value) => ShaderSyncTask(fsr)))
        .catchError((e) => ShaderSyncTask(_getShaderResponse(shaderId, e: e)));
  }

  /// Deletes a list of shaders with [shaderIds]
  ///
  /// * [shaderIds]: The list shader ids
  Future<List<ShaderSyncTask>> _deleteShaders(Set<String> shaderIds) {
    final tasks = <Future<ShaderSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderIds) {
      tasks.add(taskPool.withResource(() => _deleteShader(shaderId)));
    }

    return runner.process<ShaderSyncTask>(tasks,
        message: 'Deleting ${shaderIds.length} shader(s)');
  }

  /// Synchronizes shaders
  ///
  /// * [mode]: The sync mode
  Future<ShaderSyncResult> _syncShaders(HybridSyncMode mode) async {
    final storeSyncsResponse = await metadataStore.findSyncs(
        type: SyncType.shader, status: {SyncStatus.pending, SyncStatus.error});
    final storeShadersResponse = await metadataStore.findAllShaders();

    if (storeSyncsResponse.ok && storeShadersResponse.ok) {
      final storeSyncs = storeSyncsResponse.syncs ?? [];
      final storeShaderIdsError =
          storeSyncs.map((fsr) => fsr.sync?.target).whereType<String>();
      final storeShaders = storeShadersResponse.shaders ?? [];
      final storeInfos =
          storeShaders.map((fsr) => fsr.shader?.info).whereType<Info>();
      final storeShaderIdsOk = storeInfos.map((info) => info.id).toSet();

      final clientResponse =
          storeShaderIdsOk.isEmpty || mode == HybridSyncMode.full
              ? await client.findAllShaderIds()
              : await client.findNewShaderIds(storeShaderIdsOk);

      if (clientResponse.ok) {
        final clientShaderIds = (clientResponse.ids ?? []).toSet();

        final addShaderIds = {
          ...clientShaderIds.difference(storeShaderIdsOk),
          ...storeShaderIdsError
        };
        final added = await _addShaders(addShaderIds)
            .then((value) => value.where((task) => task.response.ok).toList());

        var removed = <ShaderSyncTask>[];
        var removedShaderIds = Iterable.empty();
        if (mode == HybridSyncMode.full) {
          final removeShaderIds = storeShaderIdsOk.difference(clientShaderIds);
          removed = await _deleteShaders(removeShaderIds).then(
              (value) => value.where((task) => task.response.ok).toList());
          removedShaderIds = removed
              .map((ShaderSyncTask task) => task.response.shader?.info.id)
              .whereType<String>();
        }

        final stored = storeShaders.map((fsr) => ShaderSyncTask(fsr));
        final currentShaders = [...stored, ...added]..removeWhere((element) =>
            removedShaderIds.contains(element.response.shader?.info.id ?? ''));

        return ShaderSyncResult(
            current: currentShaders, added: added, removed: removed);
      } else {
        runner.log(
            'Error obtaining shader ids from the server: ${clientResponse.error?.message}');
      }
    } else {
      if (!storeSyncsResponse.ok) {
        runner.log(
            'Error obtaining syncs from the local store: ${storeSyncsResponse.error?.message}');
      } else {
        runner.log(
            'Error obtaining shader ids from the local store: ${storeShadersResponse.error?.message}');
      }
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
      tasks.add(taskPool.withResource(() => client
          .findCommentsByShaderId(shaderId)
          .then((cr) => CommentsSyncTask(cr))));
    }

    return await runner
        .process<CommentsSyncTask>(tasks,
            message: 'Downloading comments of ${shaderIds.length} shader(s)')
        .then((commentTasks) => [
              for (var commentTask in commentTasks)
                if (commentTask.response.ok)
                  for (var comment in commentTask.response.comments ?? [])
                    CommentSyncTask(FindCommentResponse(comment: comment))
            ]);
  }

  /// Creates a [FindCommentsResponse] with a error
  ///
  /// * [comments]: The comments
  /// * [fcomment]: The comment response
  /// * [response]: The response
  /// * [e]: The error cause
  FindCommentsResponse _getCommentsResponse(
      String shaderId, List<Comment> comments,
      {FindCommentsResponse? fcomments, APIResponse? response, dynamic e}) {
    if (response != null && response.ok) {
      return fcomments ?? FindCommentsResponse(comments: comments);
    }

    return FindCommentsResponse(
        error: response?.error ??
            ResponseError.unknown(
                message: e.toString(),
                context: contextComment,
                target: shaderId));
  }

  /// Saves a list of comments
  ///
  /// * [shaderId]: The shader id
  /// * [comments]: The comments to save
  Future<FindCommentsResponse> _addComments(
      String shaderId, List<Comment> comments) {
    return metadataStore.saveShaderComments(shaderId, comments).then(
        (scomment) =>
            _getCommentsResponse(shaderId, comments, response: scomment));
  }

  /// Deletes a list of [shaderId] comments
  ///
  /// * [shaderId]: The shader id
  /// * [comments]: The comments to save
  Future<CommentsSyncTask> _deleteComments(
      String shaderId, List<Comment> comments) {
    return metadataStore.deleteShaderComments(shaderId).then(
        (DeleteShaderCommentsResponse dComments) => CommentsSyncTask(
            _getCommentsResponse(shaderId, comments, response: dComments)));
  }

  /// Syncs shader comments
  ///
  /// * [shaderId]: The shaderId
  /// * [comments]: The comment
  Future<CommentsSyncTask> _syncComments(
      String shaderId, List<Comment> comments) {
    return metadataStore
        .findSyncById(SyncType.shaderComments, shaderId)
        .then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: SyncType.shaderComments,
                target: shaderId,
                status: SyncStatus.pending,
                creationTime: DateTime.now());

        return metadataStore.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addComments(shaderId, comments)
                .then((FindCommentsResponse fcomments) {
              final posSync = fcomments.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: fcomments.error?.message,
                      updateTime: DateTime.now());

              return metadataStore.saveSync(posSync).then((ssync2) {
                return Future.value(CommentsSyncTask(_getCommentsResponse(
                    shaderId, comments,
                    fcomments: fcomments, response: ssync2)));
              });
            });
          }

          return Future.value(CommentsSyncTask(
              _getCommentsResponse(shaderId, comments, response: ssync1)));
        });
      }

      return Future.value(CommentsSyncTask(
          _getCommentsResponse(shaderId, comments, response: fsync)));
    }).catchError((e) =>
            CommentsSyncTask(_getCommentsResponse(shaderId, comments, e: e)));
  }

  /// Saves a map of shader comments
  ///
  /// * [shaderComments]: A map of shader comments
  Future<List<CommentsSyncTask>> _addShaderComments(
      Map<String, List<Comment>> shaderCommentsMap) {
    final tasks = <Future<CommentsSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderCommentsMap.keys) {
      final shaderComments = shaderCommentsMap[shaderId] ?? [];
      tasks.add(
          taskPool.withResource(() => _syncComments(shaderId, shaderComments)));
    }

    return runner.process<CommentsSyncTask>(tasks,
        message: 'Saving comments of ${tasks.length} shaders');
  }

  /// Deletes a map of shader comments
  ///
  /// * [shaderComments]: A map of shader comments
  Future<List<CommentsSyncTask>> _deleteShaderComments(
      Map<String, List<Comment>> shaderCommentsMap) {
    final tasks = <Future<CommentsSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final shaderId in shaderCommentsMap.keys) {
      final shaderComments = shaderCommentsMap[shaderId] ?? [];
      tasks.add(taskPool
          .withResource(() => _deleteComments(shaderId, shaderComments)));
    }

    return runner.process<CommentsSyncTask>(tasks,
        message: 'Deleting comments of ${tasks.length} shaders');
  }

  /// Synchronizes a list of comments from a previously synchronized list of shaders
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [mode]: The synchronization mode
  Future<CommentTaskResult> _syncShaderComments(
      ShaderSyncResult shaderSync, HybridSyncMode mode) async {
    final storeResponse = await metadataStore.findAllComments();
    if (storeResponse.ok) {
      final storeComments = storeResponse.comments ?? [];
      final storeCommentMap = {
        for (var comment in storeComments) comment.id: comment
      };
      final storeCommentIds = storeCommentMap.keys.toSet();

      final commentMap = <String, Comment>{};
      final shaderCommentMap = <String, List<Comment>>{};
      for (var commentTask in await _clientComments(mode == HybridSyncMode.full
          ? shaderSync.currentShaderIds
          : shaderSync.addedShaderIds)) {
        final shaderId = commentTask.response.comment?.shaderId;
        final commentId = commentTask.response.comment?.id;
        final comment = commentTask.response.comment;
        if (shaderId != null && commentId != null && comment != null) {
          commentMap[commentId] = comment;
          final shaderComments = (shaderCommentMap[shaderId] ??= <Comment>[]);
          shaderComments.add(comment);
        }
      }
      final clientCommentIds = {...commentMap.keys};

      final addCommentIds = clientCommentIds.difference(storeCommentIds);
      final addComments = [
        for (var entry in commentMap.entries)
          if (addCommentIds.contains(entry.key)) entry.value
      ];
      final addShaderComments = <String, List<Comment>>{};
      for (var comment in addComments) {
        final shaderId = comment.shaderId;
        final comments = addShaderComments[shaderId];
        if (comments == null) {
          addShaderComments[shaderId] = <Comment>[comment];
        } else {
          comments.add(comment);
        }
      }
      final added = await _addShaderComments(addShaderComments)
          .then((value) => value.where((task) => task.response.ok).toList());

      var removed = <CommentsSyncTask>[];
      if (mode == HybridSyncMode.full) {
        final removeCommentIds = storeCommentIds.difference(clientCommentIds);
        final removeComments = [
          for (var entry in storeCommentMap.entries)
            if (removeCommentIds.contains(entry.key)) entry.value
        ];
        final removeShaderComments = <String, List<Comment>>{};
        for (var comment in removeComments) {
          final shaderId = comment.shaderId;
          final comments = removeShaderComments[shaderId];
          if (comments == null) {
            removeShaderComments[shaderId] = <Comment>[comment];
          } else {
            comments.add(comment);
          }
        }

        removed = await _deleteShaderComments(removeShaderComments)
            .then((value) => value.where((task) => task.response.ok).toList());
      }

      return CommentTaskResult(added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining comment ids from the local store: ${storeResponse.error?.message}');
    }

    return CommentTaskResult();
  }

  /// Stores a list of shader pictures
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _addShaderPictures(
      Vault<Uint8List> vault, Map<String, String> pathMap) {
    final tasks = <Future<DownloadSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((shaderPicturePath, shaderPictureFilePath) {
      tasks.add(taskPool.withResource(() => syncMedia(
          vault,
          SyncType.shaderAsset,
          contextShader,
          shaderPicturePath,
          shaderPictureFilePath)));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Saving ${pathMap.length} shader picture(s)');
  }

  /// Deletes a list of shader pictures
  ///
  /// * [vault]: The binary [Vault] where the files are stored
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _deleteShaderPictures(
      Vault<Uint8List> vault, Map<String, String> pathMap) {
    final tasks = <Future<DownloadSyncTask>>[];

    pathMap.forEach((shaderPicturePath, shaderPictureFilePath) {
      tasks.add(deleteMedia(vault, SyncType.shaderAsset, contextShader,
          shaderPicturePath, shaderPictureFilePath));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Deleting ${pathMap.length} shader picture(s)');
  }

  /// Synchronizes the pictures from a shader
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [mode]: The synchronization mode
  Future<DownloadSyncResult> _syncShaderPictures(
      ShaderSyncResult shaderSync, HybridSyncMode mode) async {
    final storeSyncsResponse = await metadataStore.findSyncs(
        type: SyncType.shaderAsset,
        status: {SyncStatus.pending, SyncStatus.error});

    if (storeSyncsResponse.ok) {
      final storeSyncs = storeSyncsResponse.syncs ?? [];
      final storeShaderPicturesError =
          storeSyncs.map((fsr) => fsr.sync?.target).whereType<String>();
      final storeShaderIds = <String>{};
      final shaderMediaPath = ShadertoyContext.shaderMediaPath;
      final shaderMediaVault =
          await assetStore.vault<Uint8List>(name: shaderMediaVaultName);
      for (final path in await listPaths(shaderMediaVault, _shaderMediaFiles)) {
        storeShaderIds
            .add(fileNameToShaderId(p.basenameWithoutExtension(path)));
      }

      final storeShaderInputSources = <String>{};
      for (final path
          in await listPaths(shaderMediaVault, _shaderInputSourceFiles)) {
        storeShaderInputSources.add(path);
      }

      shaderPictureRemotePath(shaderId) =>
          ShadertoyContext.shaderPicturePath(shaderId);
      shaderPictureLocalPath(shaderId) =>
          p.join(shaderMediaPath, '${shaderIdToFileName(shaderId)}.jpg');

      hasPicture(Shader shader) {
        for (RenderPass rp in shader.renderPasses) {
          for (Input i in rp.inputs) {
            if (i.type == InputType.webcam) {
              return false;
            }
          }
        }
        return true;
      }

      final currentShaderIds =
          shaderSync.currentShaderIdsWhere(test: hasPicture);
      final currentShaderInputSources =
          shaderSync.currentShaderInputSourcePaths;

      final addedShaderIds = shaderSync.addedShaderIdsWhere(test: hasPicture);
      final removedShaderIds =
          shaderSync.removedShaderIdsWhere(test: hasPicture);
      final addShaderPaths = {
        for (var shaderId in {
          ...addedShaderIds,
          ...currentShaderIds.difference(storeShaderIds)
        })
          shaderPictureRemotePath(shaderId): shaderPictureLocalPath(shaderId)
      };
      for (var path in {
        ...shaderSync.addedShaderInputSourcePaths,
        ...currentShaderInputSources.difference(storeShaderInputSources),
        ...storeShaderPicturesError
      }) {
        addShaderPaths.putIfAbsent(path, () => path);
      }

      final removeShaderPaths = {
        for (var shaderId in {
          ...removedShaderIds,
          ...storeShaderIds.difference(currentShaderIds)
        })
          shaderPictureRemotePath(shaderId): shaderPictureLocalPath(shaderId)
      };
      for (var path in {
        ...shaderSync.removedShaderInputSourcePaths,
        ...storeShaderInputSources.difference(currentShaderInputSources)
      }) {
        removeShaderPaths.putIfAbsent(path, () => path);
      }

      final added = await _addShaderPictures(shaderMediaVault, addShaderPaths)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deleteShaderPictures(
              shaderMediaVault, removeShaderPaths)
          .then((value) => value.where((task) => task.response.ok).toList());

      return DownloadSyncResult(added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining syncs from the local store: ${storeSyncsResponse.error?.message}');
    }

    return DownloadSyncResult();
  }

  /// Synchronizes the pictures from a shader
  ///
  /// * [mode]: The synchronization mode
  Future<ShaderSyncResult> syncShaders(HybridSyncMode mode) async {
    final shaderSyncResult = await _syncShaders(mode);
    await _syncShaderComments(shaderSyncResult, mode);
    await _syncShaderPictures(shaderSyncResult, mode);

    return shaderSyncResult;
  }
}
