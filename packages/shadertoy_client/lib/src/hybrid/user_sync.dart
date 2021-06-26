import 'package:file/file.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:shadertoy/shadertoy_api.dart';

import 'hybrid_client.dart';
import 'shader_sync.dart';
import 'sync.dart';

class UserSyncTask extends SyncTask<FindUserResponse> {
  UserSyncTask(FindUserResponse response) : super.one(response);
}

class UserSyncResult extends SyncResult<UserSyncTask> {
  final List<UserSyncTask> current;

  Iterable<User> get _currentUsers =>
      current.map((task) => task.response.user).whereType<User>();

  Set<String> get currentUserIds =>
      _currentUsers.map((user) => user.id).toSet();

  Set<String> get currentUserPicturePaths => _currentUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  Iterable<User> get _addedUsers =>
      added.map((task) => task.response.user).whereType<User>();

  Set<String> get addedUserIds => _addedUsers.map((user) => user.id).toSet();

  Set<String> get addedUserPicturePaths => _addedUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  Iterable<User> get _removedUsers =>
      removed.map((task) => task.response.user).whereType<User>();

  Set<String> get removedUserIds =>
      _removedUsers.map((user) => user.id).toSet();

  Set<String> get removedUserPicturePaths => _removedUsers
      .map((user) => user.picture)
      .whereType<String>()
      .map((picture) => picturePath(picture))
      .toSet();

  UserSyncResult(
      {this.current = const [],
      List<UserSyncTask>? added,
      List<UserSyncTask>? removed})
      : super(added: added, removed: removed);
}

class UserSyncProcessor extends SyncProcessor {
  static final Glob _UserMediaFiles = Glob(
      '{${ShadertoyContext.UserMediaPath}/*/{*.jpg,*.png,*.jpeg,*.gif},${ShadertoyContext.ImgPath}/profile.jpg}');

  UserSyncProcessor(ShadertoyHybridClient client, ShadertoyStore store,
      {SyncTaskRunner? runner, int? concurrency, int? timeout})
      : super(client, store,
            processor: runner, concurrency: concurrency, timeout: timeout);

  FindUserResponse getUserError(dynamic e, String userId) {
    return FindUserResponse(
        error: ResponseError.unknown(
            message: e.toString(), context: CONTEXT_USER, target: userId));
  }

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

  Future<List<UserSyncTask>> _addUsers(Set<String> userIds) async {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _addUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Saving ${userIds.length} user(s): ');
  }

  Future<UserSyncTask> _deleteUser(String userId) {
    return store
        .findUserById(userId)
        .then((fur) =>
            store.deleteUserById(userId).then((value) => UserSyncTask(fur)))
        .catchError((e) => UserSyncTask(getUserError(e, userId)));
  }

  Future<List<UserSyncTask>> _deleteUsers(Set<String> userIds) async {
    final tasks = <Future<UserSyncTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    for (final userId in userIds) {
      tasks.add(taskPool.withResource(() => _deleteUser(userId)));
    }

    return runner.process<UserSyncTask>(tasks,
        message: 'Deleting ${userIds.length} user(s): ');
  }

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

  Future<List<DownloadTask>> _addUserPicture(
      FileSystem fs, Map<String, String> pathMap) async {
    final tasks = <Future<DownloadTask>>[];
    final taskPool = Pool(concurrency, timeout: Duration(seconds: timeout));

    pathMap.forEach((userPicturePath, userPictureFilePath) {
      tasks.add(taskPool.withResource(() => addMedia(
          fs, userPicturePath, userPictureFilePath,
          context: CONTEXT_USER)));
    });

    return runner.process<DownloadTask>(tasks,
        message: 'Saving ${pathMap.length} user picture(s)');
  }

  Future<List<DownloadTask>> _deleteUserPicture(
      FileSystem fs, Set<String> pathSet) async {
    final tasks = <Future<DownloadTask>>[];

    for (final userPictureFilePath in pathSet) {
      tasks.add(deleteMedia(fs, userPictureFilePath, context: CONTEXT_USER));
    }

    return runner.process<DownloadTask>(tasks,
        message: 'Deleting ${pathSet.length} user pictures: ');
  }

  Future<DownloadSyncResult> _syncUserPictures(
      FileSystem fs, UserSyncResult userSync) async {
    final fsDirectory = fs.currentDirectory;
    final localUserPictures = <String>{};

    await for (final path
        in listFiles(fsDirectory, _UserMediaFiles, recursive: true)) {
      localUserPictures.add(p.relative(path));
    }

    final currentUserPicturePaths = userSync.currentUserPicturePaths;
    final addUserPicturePaths = {
      for (var path in {
        ...userSync.addedUserPicturePaths,
        ...currentUserPicturePaths.difference(localUserPictures)
      })
        path: path
    };
    final removeUserPicturePaths = {
      ...userSync.removedUserPicturePaths,
      ...localUserPictures.difference(currentUserPicturePaths)
    };

    final added = await _addUserPicture(fs, addUserPicturePaths)
        .then((value) => value.where((task) => task.response.ok).toList());
    final removed = await _deleteUserPicture(fs, removeUserPicturePaths)
        .then((value) => value.where((task) => task.response.ok).toList());

    return DownloadSyncResult(added: added, removed: removed);
  }

  Future<UserSyncResult> syncUsers(ShaderSyncResult shaderSync,
      {FileSystem? fs}) async {
    final userSyncResult = await _syncUsers(shaderSync);
    if (fs != null) {
      await _syncUserPictures(fs, userSyncResult);
    }

    return userSyncResult;
  }
}
