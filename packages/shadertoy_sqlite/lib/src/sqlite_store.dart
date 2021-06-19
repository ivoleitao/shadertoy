import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';

class ShadertoyMoorStore extends ShadertoyBaseStore {
  // ignore: unused_field
  static final int _SQLITE_ABORT = 4;
  // ignore: unused_field
  static final int _SQLITE_AUTH = 23;
  // ignore: unused_field
  static final int _SQLITE_BUSY = 5;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN = 14;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT = 19;
  // ignore: unused_field
  static final int _SQLITE_CORRUPT = 11;
  // ignore: unused_field
  static final int _SQLITE_DONE = 101;
  // ignore: unused_field
  static final int _SQLITE_EMPTY = 16;
  // ignore: unused_field
  static final int _SQLITE_ERROR = 1;
  // ignore: unused_field
  static final int _SQLITE_FORMAT = 24;
  // ignore: unused_field
  static final int _SQLITE_FULL = 13;
  // ignore: unused_field
  static final int _SQLITE_INTERNAL = 2;
  // ignore: unused_field
  static final int _SQLITE_INTERRUPT = 9;
  // ignore: unused_field
  static final int _SQLITE_IOERR = 10;
  // ignore: unused_field
  static final int _SQLITE_LOCKED = 6;
  // ignore: unused_field
  static final int _SQLITE_MISMATCH = 20;
  // ignore: unused_field
  static final int _SQLITE_MISUSE = 21;
  // ignore: unused_field
  static final int _SQLITE_NOLFS = 22;
  // ignore: unused_field
  static final int _SQLITE_NOMEM = 7;
  // ignore: unused_field
  static final int _SQLITE_NOTADB = 26;
  // ignore: unused_field
  static final int _SQLITE_NOTFOUND = 12;
  // ignore: unused_field
  static final int _SQLITE_NOTICE = 27;
  // ignore: unused_field
  static final int _SQLITE_OK = 0;
  // ignore: unused_field
  static final int _SQLITE_PERM = 3;
  // ignore: unused_field
  static final int _SQLITE_PROTOCOL = 15;
  // ignore: unused_field
  static final int _SQLITE_RANGE = 25;
  // ignore: unused_field
  static final int _SQLITE_READONLY = 8;
  // ignore: unused_field
  static final int _SQLITE_ROW = 100;
  // ignore: unused_field
  static final int _SQLITE_SCHEMA = 17;
  // ignore: unused_field
  static final int _SQLITE_TOOBIG = 18;
  // ignore: unused_field
  static final int _SQLITE_WARNING = 28;
  // ignore: unused_field
  static final int _SQLITE_ABORT_ROLLBACK = 516;
  // ignore: unused_field
  static final int _SQLITE_BUSY_RECOVERY = 261;
  // ignore: unused_field
  static final int _SQLITE_BUSY_SNAPSHOT = 517;
  // ignore: unused_field
  static final int _SQLITE_BUSY_TIMEOUT = 773;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_CONVPATH = 1038;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_DIRTYWAL = 1294;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_FULLPATH = 782;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_ISDIR = 526;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_NOTEMPDIR = 270;
  // ignore: unused_field
  static final int _SQLITE_CANTOPEN_SYMLINK = 1550;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_CHECK = 275;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_COMMITHOOK = 531;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_FOREIGNKEY = 787;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_FUNCTION = 1043;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_NOTNULL = 1299;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_PINNED = 2835;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_PRIMARYKEY = 1555;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_ROWID = 2579;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_TRIGGER = 1811;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_UNIQUE = 2067;
  // ignore: unused_field
  static final int _SQLITE_CONSTRAINT_VTAB = 2323;
  // ignore: unused_field
  static final int _SQLITE_CORRUPT_INDEX = 779;
  // ignore: unused_field
  static final int _SQLITE_CORRUPT_SEQUENCE = 523;
  // ignore: unused_field
  static final int _SQLITE_CORRUPT_VTAB = 267;
  // ignore: unused_field
  static final int _SQLITE_ERROR_MISSING_COLLSEQ = 257;
  // ignore: unused_field
  static final int _SQLITE_ERROR_RETRY = 513;
  // ignore: unused_field
  static final int _SQLITE_ERROR_SNAPSHOT = 769;
  // ignore: unused_field
  static final int _SQLITE_IOERR_ACCESS = 3338;
  // ignore: unused_field
  static final int _SQLITE_IOERR_AUTH = 7178;
  // ignore: unused_field
  static final int _SQLITE_IOERR_BEGIN_ATOMIC = 7434;
  // ignore: unused_field
  static final int _SQLITE_IOERR_BLOCKED = 2826;
  // ignore: unused_field
  static final int _SQLITE_IOERR_CHECKRESERVEDLOCK = 3594;
  // ignore: unused_field
  static final int _SQLITE_IOERR_CLOSE = 4106;
  // ignore: unused_field
  static final int _SQLITE_IOERR_COMMIT_ATOMIC = 7690;
  // ignore: unused_field
  static final int _SQLITE_IOERR_CONVPATH = 6666;
  // ignore: unused_field
  static final int _SQLITE_IOERR_DATA = 8202;
  // ignore: unused_field
  static final int _SQLITE_IOERR_DELETE = 2570;
  // ignore: unused_field
  static final int _SQLITE_IOERR_DELETE_NOENT = 5898;
  // ignore: unused_field
  static final int _SQLITE_IOERR_DIR_CLOSE = 4362;
  // ignore: unused_field
  static final int _SQLITE_IOERR_DIR_FSYNC = 1290;
  // ignore: unused_field
  static final int _SQLITE_IOERR_FSTAT = 1802;
  // ignore: unused_field
  static final int _SQLITE_IOERR_FSYNC = 1034;
  // ignore: unused_field
  static final int _SQLITE_IOERR_GETTEMPPATH = 6410;
  // ignore: unused_field
  static final int _SQLITE_IOERR_LOCK = 3850;
  // ignore: unused_field
  static final int _SQLITE_IOERR_MMAP = 6154;
  // ignore: unused_field
  static final int _SQLITE_IOERR_NOMEM = 308;
  // ignore: unused_field
  static final int _SQLITE_IOERR_RDLOCK = 231;
  // ignore: unused_field
  static final int _SQLITE_IOERR_READ = 266;
  // ignore: unused_field
  static final int _SQLITE_IOERR_ROLLBACK_ATOMIC = 7946;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SEEK = 5642;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SHMLOCK = 5130;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SHMMAP = 5386;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SHMOPEN = 4618;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SHMSIZE = 4874;
  // ignore: unused_field
  static final int _SQLITE_IOERR_SHORT_READ = 522;
  // ignore: unused_field
  static final int _SQLITE_IOERR_TRUNCATE = 1546;
  // ignore: unused_field
  static final int _SQLITE_IOERR_UNLOCK = 2058;
  // ignore: unused_field
  static final int _SQLITE_IOERR_VNODE = 6922;
  // ignore: unused_field
  static final int _SQLITE_IOERR_WRITE = 778;
  // ignore: unused_field
  static final int _SQLITE_LOCKED_SHAREDCACHE = 262;

  /// The [MoorStore]
  final MoorStore store;

  /// The [ShadertoyMoorOptions]
  final ShadertoyMoorOptions options;

  /// Creates a [ShadertoyMoorStore]
  ///
  /// * [store]: A pre-initialized [MoorStore] store
  /// * [options]: The [ShadertoyMoorOptions] used to configure this store
  ShadertoyMoorStore(this.store, this.options);

  /// Converts a [SqliteException] to a [ResponseError]
  ///
  /// * [sqle]: The [SqliteException]
  /// * [context]: The optional context of the error
  /// * [target]: The optional target of the error
  ///
  /// Used to create a consistent response when there is a internal error
  ResponseError _toResponseError(SqliteException sqle,
      {String? context, String? target}) {
    if (sqle.resultCode == _SQLITE_AUTH) {
      return ResponseError.authorization(
          message: sqle.message, context: context, target: target);
    } else if (sqle.extendedResultCode == _SQLITE_BUSY_TIMEOUT) {
      return ResponseError.backendTimeout(
          message: sqle.message, context: context, target: target);
    } else if (sqle.resultCode == _SQLITE_ABORT ||
        sqle.extendedResultCode == _SQLITE_ABORT_ROLLBACK) {
      return ResponseError.aborted(
          message: sqle.message, context: context, target: target);
    } else if (sqle.extendedResultCode == _SQLITE_CONSTRAINT_PRIMARYKEY ||
        sqle.extendedResultCode == _SQLITE_CONSTRAINT_UNIQUE ||
        sqle.extendedResultCode == _SQLITE_CONSTRAINT_ROWID) {
      return ResponseError.conflict(
          message: sqle.message, context: context, target: target);
    } else if (sqle.resultCode == _SQLITE_CONSTRAINT ||
        sqle.extendedResultCode == _SQLITE_CONSTRAINT_CHECK ||
        sqle.extendedResultCode == _SQLITE_CONSTRAINT_NOTNULL ||
        sqle.extendedResultCode == _SQLITE_CONSTRAINT_FOREIGNKEY) {
      return ResponseError.unprocessableEntity(
          message: sqle.message, context: context, target: target);
    }

    return ResponseError.unknown(
        message: sqle.message, context: context, target: target);
  }

  /// Catches and handles a [SqliteException] error in a future
  ///
  /// * [future]: The future
  /// * [handle]: The error handling function
  Future<R> _catchSqlError<R extends APIResponse>(
      Future<R> future, R Function(SqliteException) handle) {
    return catchError<R, SqliteException>(
        future, handle, options.errorHandling);
  }

  @override
  Future<FindUserResponse> findUserById(String userId) {
    return _catchSqlError<FindUserResponse>(
        store.userDao.findById(userId).then((value) => value != null
            ? FindUserResponse(user: value)
            : FindUserResponse(
                error: ResponseError.notFound(
                    message: 'User $userId not found',
                    context: CONTEXT_USER,
                    target: userId))),
        (sqle) => FindUserResponse(
            error:
                _toResponseError(sqle, context: CONTEXT_USER, target: userId)));
  }

  @override
  Future<FindUserIdsResponse> findAllUserIds() {
    return _catchSqlError<FindUserIdsResponse>(
        store.userDao
            .findAllIds()
            .then((value) => FindUserIdsResponse(ids: value)),
        (sqle) => FindUserIdsResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<FindUsersResponse> findAllUsers() {
    return _catchSqlError<FindUsersResponse>(
        store.userDao.findAll().then((results) => FindUsersResponse(
            users:
                results.map((user) => FindUserResponse(user: user)).toList())),
        (sqle) => FindUsersResponse(
            error: _toResponseError(sqle, context: CONTEXT_USER)));
  }

  @override
  Future<SaveUserResponse> saveUser(User user) {
    return _catchSqlError<SaveUserResponse>(
        store.userDao.save(user).then((response) => SaveUserResponse()),
        (sqle) => SaveUserResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_USER, target: user.id)));
  }

  @override
  Future<SaveUsersResponse> saveUsers(List<User> users) {
    return _catchSqlError<SaveUsersResponse>(
        store.userDao.saveAll(users).then((reponse) => SaveUsersResponse()),
        (sqle) => SaveUsersResponse(
            error: _toResponseError(sqle, context: CONTEXT_USER)));
  }

  @override
  Future<DeleteUserResponse> deleteUserById(String userId) {
    return _catchSqlError<DeleteUserResponse>(
        store.userDao
            .deleteById(userId)
            .then((reponse) => DeleteUserResponse()),
        (sqle) => DeleteUserResponse(
            error:
                _toResponseError(sqle, context: CONTEXT_USER, target: userId)));
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return _catchSqlError<FindShaderResponse>(
        store.shaderDao.findById(shaderId).then((value) => value != null
            ? FindShaderResponse(shader: value)
            : FindShaderResponse(
                error: ResponseError.notFound(
                    message: 'Shader $shaderId not found',
                    context: CONTEXT_SHADER,
                    target: shaderId))),
        (sqle) => FindShaderResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_SHADER, target: shaderId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findAllIds()
            .then((value) => FindShaderIdsResponse(ids: value)),
        (sqle) => FindShaderIdsResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(
                term: term,
                filters: filters,
                sort: sort ?? Sort.hot,
                from: from,
                num: num ?? options.shaderCount)
            .then((results) => FindShaderIdsResponse(ids: results)),
        (sqle) => FindShaderIdsResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    return _catchSqlError<FindShadersResponse>(
        Future.wait(shaderIds.map((id) => findShaderById(id).then(
                (FindShaderResponse sr) =>
                    FindShaderResponse(shader: sr.shader))))
            .then((shaders) => FindShadersResponse(shaders: shaders)),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _catchSqlError<FindShadersResponse>(
        store.shaderDao
            .find(
                term: term,
                filters: filters,
                sort: sort ?? Sort.hot,
                from: from,
                num: num ?? options.shaderCount)
            .then((results) => FindShadersResponse(
                shaders: results
                    .map((shader) => FindShaderResponse(shader: shader))
                    .toList())),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<FindShadersResponse> findAllShaders() {
    return _catchSqlError<FindShadersResponse>(
        store.shaderDao.findAll().then((results) => FindShadersResponse(
            shaders: results
                .map((shader) => FindShaderResponse(shader: shader))
                .toList())),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<SaveShaderResponse> saveShader(Shader shader) {
    return _catchSqlError<SaveShaderResponse>(
        store.shaderDao.save(shader).then((reponse) => SaveShaderResponse()),
        (sqle) => SaveShaderResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_SHADER, target: shader.info.id)));
  }

  @override
  Future<SaveShadersResponse> saveShaders(List<Shader> shaders) {
    return _catchSqlError<SaveShadersResponse>(
        store.shaderDao
            .saveAll(shaders)
            .then((reponse) => SaveShadersResponse()),
        (sqle) => SaveShadersResponse(
            error: _toResponseError(sqle, context: CONTEXT_SHADER)));
  }

  @override
  Future<DeleteShaderResponse> deleteShaderById(String shaderId) {
    return _catchSqlError<DeleteShaderResponse>(
        store.shaderDao
            .deleteById(shaderId)
            .then((reponse) => DeleteShaderResponse()),
        (sqle) => DeleteShaderResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_SHADER, target: shaderId)));
  }

  @override
  Future<FindCommentResponse> findCommentById(String commentId) {
    return _catchSqlError<FindCommentResponse>(
        store.commentDao.findById(commentId).then((value) => value != null
            ? FindCommentResponse(comment: value)
            : FindCommentResponse(
                error: ResponseError.notFound(
                    message: 'Comment $commentId not found',
                    context: CONTEXT_COMMENT,
                    target: commentId))),
        (sqle) => FindCommentResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_COMMENT, target: commentId)));
  }

  @override
  Future<FindCommentIdsResponse> findAllCommentIds() {
    return _catchSqlError<FindCommentIdsResponse>(
        store.commentDao
            .findAllIds()
            .then((value) => FindCommentIdsResponse(ids: value)),
        (sqle) => FindCommentIdsResponse(
            error: _toResponseError(sqle, context: CONTEXT_COMMENT)));
  }

  @override
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId) {
    return _catchSqlError<FindCommentsResponse>(
        store.commentDao.findByShaderId(shaderId).then((results) =>
            FindCommentsResponse(
                comments: results.map((r) => r.copyWith()).toList())),
        (sqle) => FindCommentsResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_COMMENT, target: shaderId)));
  }

  @override
  Future<FindCommentsResponse> findAllComments() {
    return _catchSqlError<FindCommentsResponse>(
        store.commentDao
            .findAll()
            .then((value) => FindCommentsResponse(comments: value)),
        (sqle) => FindCommentsResponse(
            error: _toResponseError(sqle, context: CONTEXT_COMMENT)));
  }

  @override
  Future<SaveShaderCommentsResponse> saveShaderComments(
      List<Comment> comments) {
    return _catchSqlError<SaveShaderCommentsResponse>(
        store.commentDao
            .save(comments)
            .then((reponse) => SaveShaderCommentsResponse()),
        (sqle) => SaveShaderCommentsResponse(
            error: _toResponseError(sqle, context: CONTEXT_COMMENT)));
  }

  @override
  Future<DeleteCommentResponse> deleteCommentById(String commentId) {
    return _catchSqlError<DeleteCommentResponse>(
        store.commentDao
            .deleteById(commentId)
            .then((reponse) => DeleteCommentResponse()),
        (sqle) => DeleteCommentResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_COMMENT, target: commentId)));
  }

  @override
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _catchSqlError<FindShadersResponse>(
        store.shaderDao
            .find(
                userId: userId,
                filters: filters,
                sort: sort ?? Sort.popular,
                from: from,
                num: num = options.userShaderCount)
            .then((results) => FindShadersResponse(
                shaders: results
                    .map((r) => FindShaderResponse(shader: r))
                    .toList())),
        (sqle) => FindShadersResponse(
            error:
                _toResponseError(sqle, context: CONTEXT_USER, target: userId)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(
                userId: userId,
                filters: filters,
                sort: sort ?? Sort.popular,
                from: from,
                num: num = options.userShaderCount)
            .then((results) => FindShaderIdsResponse(ids: results.toList())),
        (sqle) => FindShaderIdsResponse(
            error:
                _toResponseError(sqle, context: CONTEXT_USER, target: userId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(userId: userId)
            .then((results) => FindShaderIdsResponse(ids: results.toList())),
        (sqle) => FindShaderIdsResponse(
            error:
                _toResponseError(sqle, context: CONTEXT_USER, target: userId)));
  }

  @override
  Future<FindPlaylistResponse> findPlaylistById(String playlistId) {
    return _catchSqlError<FindPlaylistResponse>(
        store.playlistDao.findById(playlistId).then((playlist) =>
            playlist != null
                ? FindPlaylistResponse(playlist: playlist)
                : FindPlaylistResponse(
                    error: ResponseError.notFound(
                        message: 'Playlist $playlistId not found',
                        context: CONTEXT_PLAYLIST,
                        target: playlistId))),
        (sqle) => FindPlaylistResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }

  @override
  Future<FindPlaylistIdsResponse> findAllPlaylistIds() {
    return _catchSqlError<FindPlaylistIdsResponse>(
        store.playlistDao
            .findAllIds()
            .then((value) => FindPlaylistIdsResponse(ids: value)),
        (sqle) => FindPlaylistIdsResponse(
            error: _toResponseError(sqle, context: CONTEXT_PLAYLIST)));
  }

  @override
  Future<FindPlaylistsResponse> findAllPlaylists() {
    return _catchSqlError<FindPlaylistsResponse>(
        store.playlistDao.findAll().then((results) => FindPlaylistsResponse(
            playlists: results
                .map((playlist) => FindPlaylistResponse(playlist: playlist))
                .toList())),
        (sqle) => FindPlaylistsResponse(
            error: _toResponseError(sqle, context: CONTEXT_PLAYLIST)));
  }

  @override
  Future<FindShadersResponse> findShadersByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return _catchSqlError<FindShadersResponse>(
        store.shaderDao
            .findByPlaylist(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((results) => FindShadersResponse(
                shaders: results
                    .map((r) => FindShaderResponse(shader: r))
                    .toList())),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIdsByPlaylist(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((shaderIds) => FindShaderIdsResponse(ids: shaderIds)),
        (sqle) => FindShaderIdsResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByPlaylistId(
      String playlistId) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIdsByPlaylist(playlistId)
            .then((shaderIds) => FindShaderIdsResponse(ids: shaderIds)),
        (sqle) => FindShaderIdsResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }

  @override
  Future<SavePlaylistResponse> savePlaylist(Playlist playlist,
      {List<String>? shaderIds}) {
    return _catchSqlError<SavePlaylistResponse>(
        store.playlistDao
            .save(playlist, shaderIds: shaderIds)
            .then((reponse) => SavePlaylistResponse()),
        (sqle) => SavePlaylistResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlist.id)));
  }

  @override
  Future<SavePlaylistShadersResponse> savePlaylistShaders(
      String playlistId, List<String> shaderIds) {
    return _catchSqlError<SavePlaylistShadersResponse>(
        store.playlistDao
            .savePlaylistShaders(playlistId, shaderIds)
            .then((reponse) => SavePlaylistShadersResponse()),
        (sqle) => SavePlaylistShadersResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }

  @override
  Future<DeletePlaylistResponse> deletePlaylistById(String playlistId) {
    return _catchSqlError<DeletePlaylistResponse>(
        store.playlistDao
            .deleteById(playlistId)
            .then((reponse) => DeletePlaylistResponse()),
        (sqle) => DeletePlaylistResponse(
            error: _toResponseError(sqle,
                context: CONTEXT_PLAYLIST, target: playlistId)));
  }
}

/// Creates a [ShadertoyStore] backed by a [ShadertoyMoorStore]
///
/// * [executor]: The [QueryExecutor] for this store
/// * [shaderCount]: The number of shaders requested for a paged call
/// * [userShaderCount]: The number of shaders requested for a user paged call
/// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
/// * [errorHandling]: The error handling mode
ShadertoyStore newShadertoyMoorStore(QueryExecutor executor,
    {int? shaderCount,
    int? userShaderCount,
    int? playlistShaderCount,
    ErrorMode? errorHandling}) {
  return ShadertoyMoorStore(
      MoorStore(executor),
      ShadertoyMoorOptions(
          shaderCount: shaderCount,
          userShaderCount: userShaderCount,
          playlistShaderCount: playlistShaderCount,
          errorHandling: errorHandling));
}
