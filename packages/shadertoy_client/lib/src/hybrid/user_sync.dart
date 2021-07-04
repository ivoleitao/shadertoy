import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';

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
  /// * [runner]: The [SyncTaskRunner] that will be used in this processor
  /// * [concurrency]: The number of concurrent tasks
  /// * [timeout]: The maximum timeout waiting for a task completion
  UserSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            runner: runner, concurrency: concurrency, timeout: timeout);

  /// Creates a [FindUserResponse] with a error
  ///
  /// * [e]: The error cause
  /// * [userId]: The user id
  FindUserResponse getUserError(dynamic e, String userId) {
    return FindUserResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: contextUser, target: userId));
  }

  /// Saves a user with id equal to [userId]
  ///
  /// * [userId]: The user id
  Future<UserSyncTask> _addUser(String userId) {
    return client
        .findUserById(userId)
        .then((apiUser) {
          final user = apiUser.user;
          if (user != null) {
            store.saveUser(user);
          }

          return apiUser;
        })
        .then((ur) => UserSyncTask(ur))
        .catchError((e) => UserSyncTask(getUserError(e, userId)));
  }

  /// Saves a list of users with [userIds]
  ///
  /// * [userIds]: The list user ids
  Future<List<UserSyncTask>> _addUsers(Set<String> userIds) async {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _addUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Saving ${userIds.length} user(s): ');
  }

  /// Deletes a user with id [userId]
  ///
  /// * [userId]: The user id
  Future<UserSyncTask> _deleteUser(String userId) {
    return store
        .findUserById(userId)
        .then((fur) =>
            store.deleteUserById(userId).then((value) => UserSyncTask(fur)))
        .catchError((e) => UserSyncTask(getUserError(e, userId)));
  }

  /// Deletes a list of users with [userIds]
  ///
  /// * [userIds]: The list user ids
  Future<List<UserSyncTask>> _deleteUsers(Set<String> userIds) async {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _deleteUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Deleting ${userIds.length} user(s): ');
  }

  /// Synchronizes a list of users from a previously synchronized list of shaders
  ///
  /// * [shaderSync]: The shader synchronization result
  Future<UserSyncResult> _syncUsers(ShaderSyncResult shaderSync) async {
    final localResponse = await store.findAllUsers();
    if (localResponse.ok) {
      final localUsers = localResponse.users ?? [];
      final localUserIds =
          localUsers.map((fur) => fur.user?.id).whereType<String>().toSet();
      final remoteUserIds = shaderSync.currentUserIds;
      final addUserIds = remoteUserIds.difference(localUserIds);
      final removeUserIds = localUserIds.difference(remoteUserIds);

      final local = localUsers.map((fur) => UserSyncTask(fur));
      final added = await _addUsers(addUserIds)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removed = await _deleteUsers(removeUserIds)
          .then((value) => value.where((task) => task.response.ok).toList());
      final removedUserIds = removed
          .map((UserSyncTask task) => task.response.user?.id)
          .whereType<String>();
      final currentUsers = [...local, ...added]..removeWhere((element) =>
          removedUserIds.contains(element.response.user?.id ?? ''));

      return UserSyncResult(
          current: currentUsers, added: added, removed: removed);
    } else {
      runner.log(
          'Error obtaining user ids from the local store: ${localResponse.error?.message}');
    }

    return UserSyncResult();
  }

  /// Stores a list of user pictures
  ///
  /// * [fs]: The [FileSystem]
  /// * [pathMap]: A map where the key is the remote path and the value the local path
  Future<List<DownloadSyncTask>> _addUserPicture(
      FileSystem fs, Map<String, String> pathMap) async {
    final tasks = <Future<DownloadSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((userPicturePath, userPictureFilePath) {
      tasks.add(taskPool.withResource(() => addMedia(
          fs, userPicturePath, userPictureFilePath,
          context: contextUser)));
    });

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Saving ${pathMap.length} user picture(s)');
  }

  /// Deletes a list of user pictures
  ///
  /// * [fs]: The [FileSystem]
  /// * [pathSet]: A set of user picture paths to delete
  Future<List<DownloadSyncTask>> _deleteUserPicture(
      FileSystem fs, Set<String> pathSet) async {
    final tasks = <Future<DownloadSyncTask>>[];

    for (final userPictureFilePath in pathSet) {
      tasks.add(deleteMedia(fs, userPictureFilePath, context: contextUser));
    }

    return runner.process<DownloadSyncTask>(tasks,
        message: 'Deleting ${pathSet.length} user pictures: ');
  }

  /// Synchronizes the pictures from a user
  ///
  /// * [fs]: The [FileSystem]
  /// * [dir]: The target directory on the [FileSystem]
  /// * [userSync]: The user synchronization result
  Future<DownloadSyncResult> _syncUserPictures(
      FileSystem fs, Directory dir, UserSyncResult userSync) async {
    final localUserPictures = <String>{};

    await for (final path in listFiles(dir, _userMediaFiles, recursive: true)) {
      localUserPictures.add(p.relative(path, from: dir.path));
    }

    userPictureLocalPath(path) => p.join(dir.path, path);

    final currentUserPicturePaths = userSync.currentUserPicturePaths;
    final addUserPicturePaths = {
      for (var path in {
        ...userSync.addedUserPicturePaths,
        ...currentUserPicturePaths.difference(localUserPictures)
      })
        path: userPictureLocalPath(path)
    };
    final removeUserPicturePaths = {
      ...userSync.removedUserPicturePaths,
      ...localUserPictures.difference(currentUserPicturePaths)
    }.map((path) => userPictureLocalPath(path)).toSet();

    final added = await _addUserPicture(fs, addUserPicturePaths)
        .then((value) => value.where((task) => task.response.ok).toList());
    final removed = await _deleteUserPicture(fs, removeUserPicturePaths)
        .then((value) => value.where((task) => task.response.ok).toList());

    return DownloadSyncResult(added: added, removed: removed);
  }

  /// Synchronizes the pictures from a user
  ///
  /// * [fs]: The [FileSystem]
  /// * [dir]: The target directory on the [FileSystem]
  /// * [userSync]: The user synchronization result
  Future<UserSyncResult> syncUsers(ShaderSyncResult shaderSync,
      {FileSystem? fs, Directory? dir}) async {
    final userSyncResult = await _syncUsers(shaderSync);
    if (fs != null) {
      await _syncUserPictures(fs, dir ?? fs.currentDirectory, userSyncResult);
    }

    return userSyncResult;
  }
}
