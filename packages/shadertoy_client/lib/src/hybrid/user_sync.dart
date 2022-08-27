import 'dart:typed_data';

import 'package:glob/glob.dart';
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy/shadertoy_util.dart';
import 'package:stash/stash_api.dart' show Vault;

import 'hybrid_client.dart';
import 'shader_sync.dart';
import 'sync.dart';

/// A user synchronization task
class UserSyncTask extends SyncTask<FindUserResponse> {
  /// The [UserSyncTask] constructor
  ///
  /// * [response]: The [FindUserResponse] associated with this task
  UserSyncTask(FindUserResponse response) : super.one(response);
}

/// The result of a user synchronization task
class UserSyncResult extends SyncResult<UserSyncTask> {
  /// The current task
  final List<UserSyncTask> current;

  /// The current users
  Iterable<User> get _currentUsers =>
      current.map((task) => task.response.user).whereType<User>();

  /// The current user ids
  Set<String> get currentUserIds =>
      _currentUsers.map((user) => user.id).toSet();

  /// The current user picture paths
  Set<String> get currentUserPicturePaths => _currentUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  /// The added users
  Iterable<User> get _addedUsers =>
      added.map((task) => task.response.user).whereType<User>();

  /// The added user ids
  Set<String> get addedUserIds => _addedUsers.map((user) => user.id).toSet();

  /// The added user picture paths
  Set<String> get addedUserPicturePaths => _addedUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  /// The removed users
  Iterable<User> get _removedUsers =>
      removed.map((task) => task.response.user).whereType<User>();

  /// The removed user ids
  Set<String> get removedUserIds =>
      _removedUsers.map((user) => user.id).toSet();

  /// The removed user picture paths
  Set<String> get removedUserPicturePaths => _removedUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  /// The [UserSyncResult] constructor
  ///
  /// * [current]: The current [UserSyncTask]
  /// * [added]: The list of added [UserSyncTask]s
  /// * [removed]: The list of removed [UserSyncTask]s
  UserSyncResult(
      {this.current = const [],
      List<UserSyncTask>? added,
      List<UserSyncTask>? removed})
      : super(added: added, removed: removed);
}

/// The processor of user synchronization tasks
class UserSyncProcessor extends SyncProcessor {
  /// A [Glob] defining the location of the local user media files
  static final Glob _userMediaFiles = Glob(
      '**/{${ShadertoyContext.userMediaPath}/*/{*.jpg,*.png,*.jpeg,*.gif},${ShadertoyContext.imgPath}/profile.jpg}');

  /// The [UserSyncProcessor] constructur
  ///
  /// * [client]: The [ShadertoyHybridClient] instance
  /// * [store]: The [ShadertoyStore] instance
  /// * [vault]: The [Vault] instance
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  UserSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      Vault<Uint8List> vault,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store, vault,
            runner: runner, concurrency: concurrency, timeout: timeout);

  /// Creates a [FindUserResponse] with a error
  ///
  /// * [userId]: The shader id
  /// * [fuser]: The user response
  /// * [response]: The response
  /// * [e]: The error cause
  FindUserResponse _getUserResponse(String userId,
      {FindUserResponse? fuser, APIResponse? response, dynamic e}) {
    if (fuser != null && response != null && response.ok) {
      return fuser;
    }
    return FindUserResponse(
        error: response?.error ??
            ResponseError.unknown(
                message: e.toString(), context: contextUser, target: userId));
  }

  /// Saves a user with id equal to [userId]
  ///
  /// * [userId]: The user id
  Future<FindUserResponse> _addUser(String userId) {
    return client.findUserById(userId).then((fuser) {
      final user = fuser.user;
      if (user != null) {
        return store.saveUser(user).then(
            (suser) => _getUserResponse(userId, fuser: fuser, response: suser));
      }

      return Future.value(_getUserResponse(userId, response: fuser));
    });
  }

  /// Syncs a user with id equal to [userId]
  ///
  /// * [userId]: The user id
  Future<UserSyncTask> _syncUser(String userId) {
    return store.findSyncById(SyncType.user, userId).then((fsync) {
      final sync = fsync.sync;
      if (fsync.ok || fsync.error?.code == ErrorCode.notFound) {
        final preSync = sync != null
            ? sync.copyWith(
                status: SyncStatus.pending, updateTime: DateTime.now())
            : Sync(
                type: SyncType.user,
                target: userId,
                status: SyncStatus.pending,
                creationTime: DateTime.now());

        return store.saveSync(preSync).then((ssync1) {
          if (ssync1.ok) {
            return _addUser(userId).then((FindUserResponse fuser) {
              final posSync = fuser.ok
                  ? preSync.copyWith(
                      status: SyncStatus.ok, updateTime: DateTime.now())
                  : preSync.copyWith(
                      status: SyncStatus.error,
                      message: fuser.error?.message,
                      updateTime: DateTime.now());

              return store.saveSync(posSync).then((ssync2) {
                return Future.value(UserSyncTask(
                    _getUserResponse(userId, fuser: fuser, response: ssync2)));
              });
            });
          }

          return Future.value(
              UserSyncTask(_getUserResponse(userId, response: ssync1)));
        });
      }

      return Future.value(
          UserSyncTask(_getUserResponse(userId, response: fsync)));
    }).catchError((e) => UserSyncTask(_getUserResponse(userId, e: e)));
  }

  /// Saves a list of users with [userIds]
  ///
  /// * [userIds]: The list user ids
  Future<List<UserSyncTask>> _addUsers(Set<String> userIds) {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _syncUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Saving ${userIds.length} user(s)');
  }

  /// Deletes a user with id [userId]
  ///
  /// * [userId]: The user id
  Future<UserSyncTask> _deleteUser(String userId) {
    return store
        .findUserById(userId)
        .then((fur) =>
            store.deleteUserById(userId).then((value) => UserSyncTask(fur)))
        .catchError((e) => UserSyncTask(_getUserResponse(userId, e: e)));
  }

  /// Deletes a list of users with [userIds]
  ///
  /// * [userIds]: The list user ids
  Future<List<UserSyncTask>> _deleteUsers(Set<String> userIds) {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _deleteUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Deleting ${userIds.length} user(s)');
  }

  /// Synchronizes a list of users from a previously synchronized list of shaders
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [mode]: The synchronization mode
  Future<UserSyncResult> _syncUsers(
      ShaderSyncResult shaderSync, HybridSyncMode mode) async {
    final storeSyncsResponse = await store.findSyncs(
        type: SyncType.user, status: {SyncStatus.pending, SyncStatus.error});
    final storeUserResponse = await store.findAllUsers();

    if (storeSyncsResponse.ok && storeUserResponse.ok) {
      final storeSyncs = storeSyncsResponse.syncs ?? [];
      final storeUserIdsError =
          storeSyncs.map((fsr) => fsr.sync?.target).whereType<String>();
      final storeUsers = storeUserResponse.users ?? [];
      final storeUserIdsOk =
          storeUsers.map((fur) => fur.user?.id).whereType<String>().toSet();
      final clientUserIds = shaderSync.currentUserIds;
      final addUserIds = {
        ...clientUserIds.difference(storeUserIdsOk),
        ...storeUserIdsError
      };

      final local = storeUsers.map((fur) => UserSyncTask(fur));
      final added = await _addUsers(addUserIds)
          .then((value) => value.where((task) => task.response.ok).toList());

      var removed = <UserSyncTask>[];
      var removedUserIds = Iterable.empty();
      if (mode == HybridSyncMode.full) {
        final removeUserIds = storeUserIdsOk.difference(clientUserIds);
        removed = await _deleteUsers(removeUserIds)
            .then((value) => value.where((task) => task.response.ok).toList());
        removedUserIds = removed
            .map((UserSyncTask task) => task.response.user?.id)
            .whereType<String>();
      }
      final currentUsers = [...local, ...added]..removeWhere((element) =>
          removedUserIds.contains(element.response.user?.id ?? ''));

      return UserSyncResult(
          current: currentUsers, added: added, removed: removed);
    } else {
      if (!storeSyncsResponse.ok) {
        runner.log(
            'Error obtaining syncs from the local store: ${storeSyncsResponse.error?.message}');
      } else {
        runner.log(
            'Error obtaining user ids from the local store: ${storeUserResponse.error?.message}');
      }
    }

    return UserSyncResult();
  }

  /// Stores a list of user pictures
  ///
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _addUserPicture(Map<String, String> pathMap) {
    final tasks = <Future<DownloadSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((userPicturePath, userPictureFilePath) {
      tasks.add(taskPool.withResource(() => syncMedia(SyncType.userAsset,
          contextUser, userPicturePath, userPictureFilePath)));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Saving ${pathMap.length} user picture(s)');
  }

  /// Deletes a list of user pictures
  ///
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _deleteUserPicture(
      Map<String, String> pathMap) {
    final tasks = <Future<DownloadSyncTask>>[];

    pathMap.forEach((userPicturePath, userPictureFilePath) {
      tasks.add(deleteMedia(SyncType.userAsset, contextUser, userPicturePath,
          userPictureFilePath));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Deleting ${pathMap.length} user pictures');
  }

  /// Synchronizes the pictures from a user
  ///
  /// * [userSync]: The user synchronization result
  /// * [mode]: The synchronization mode
  Future<DownloadSyncResult> _syncUserPictures(
      UserSyncResult userSync, HybridSyncMode mode) async {
    final storeSyncsResponse = await store.findSyncs(
        type: SyncType.userAsset,
        status: {SyncStatus.pending, SyncStatus.error});

    if (storeSyncsResponse.ok) {
      final storeSyncs = storeSyncsResponse.syncs ?? [];
      final storeUserPicturesError =
          storeSyncs.map((fsr) => fsr.sync?.target).whereType<String>();
      final storeUserPictures = Set<String>.from(storeUserPicturesError);

      for (final path in await listPaths(_userMediaFiles)) {
        storeUserPictures.add(path);
      }

      final currentUserPicturePaths = userSync.currentUserPicturePaths;
      final addUserPicturePaths = {
        for (var path in {
          ...userSync.addedUserPicturePaths,
          ...currentUserPicturePaths.difference(storeUserPictures)
        })
          path: path
      };

      final removeUserPicturePaths = {
        for (var path in {
          ...userSync.removedUserPicturePaths,
          ...storeUserPictures.difference(currentUserPicturePaths)
        })
          path: path
      };
      final added = await _addUserPicture(addUserPicturePaths)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deleteUserPicture(removeUserPicturePaths)
          .then((value) => value.where((task) => task.response.ok).toList());

      return DownloadSyncResult(added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining syncs from the local store: ${storeSyncsResponse.error?.message}');
    }

    return DownloadSyncResult();
  }

  /// Synchronizes the pictures from a user
  ///
  /// * [shaderSync]: The shader synchronization result
  /// * [mode]: The synchronization mode
  Future<UserSyncResult> syncUsers(
      ShaderSyncResult shaderSync, HybridSyncMode mode) async {
    final userSyncResult = await _syncUsers(shaderSync, mode);
    await _syncUserPictures(userSyncResult, mode);

    return userSyncResult;
  }
}
