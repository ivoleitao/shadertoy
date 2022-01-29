import 'package:drift/native.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';

class ShadertoySqliteStore extends ShadertoyBaseStore {
  // ignore: unused_field
  static final int _sqliteAbort = 4;
  // ignore: unused_field
  static final int _sqliteAuth = 23;
  // ignore: unused_field
  static final int _sqliteBusy = 5;
  // ignore: unused_field
  static final int _sqliteCantopen = 14;
  // ignore: unused_field
  static final int _sqliteConstraint = 19;
  // ignore: unused_field
  static final int _sqliteCorrupt = 11;
  // ignore: unused_field
  static final int _sqliteDone = 101;
  // ignore: unused_field
  static final int _sqliteEmpty = 16;
  // ignore: unused_field
  static final int _sqliteError = 1;
  // ignore: unused_field
  static final int _sqliteFormat = 24;
  // ignore: unused_field
  static final int _sqliteFull = 13;
  // ignore: unused_field
  static final int _sqliteInternal = 2;
  // ignore: unused_field
  static final int _sqliteInterrupt = 9;
  // ignore: unused_field
  static final int _sqliteIoerr = 10;
  // ignore: unused_field
  static final int _sqliteLocked = 6;
  // ignore: unused_field
  static final int _sqliteMismatch = 20;
  // ignore: unused_field
  static final int _sqliteMisuse = 21;
  // ignore: unused_field
  static final int _sqliteNolfs = 22;
  // ignore: unused_field
  static final int _sqliteNomem = 7;
  // ignore: unused_field
  static final int _sqliteNotadb = 26;
  // ignore: unused_field
  static final int _sqliteNotfound = 12;
  // ignore: unused_field
  static final int _sqliteNotice = 27;
  // ignore: unused_field
  static final int _sqliteOk = 0;
  // ignore: unused_field
  static final int _sqlitePerm = 3;
  // ignore: unused_field
  static final int _sqliteProtocol = 15;
  // ignore: unused_field
  static final int _sqliteRange = 25;
  // ignore: unused_field
  static final int _sqliteReadonly = 8;
  // ignore: unused_field
  static final int _sqliteRow = 100;
  // ignore: unused_field
  static final int _sqliteSchema = 17;
  // ignore: unused_field
  static final int _sqliteToobig = 18;
  // ignore: unused_field
  static final int _sqliteWarning = 28;
  // ignore: unused_field
  static final int _sqliteAbortRollback = 516;
  // ignore: unused_field
  static final int _sqliteBusyRecovery = 261;
  // ignore: unused_field
  static final int _sqliteBusySnapshot = 517;
  // ignore: unused_field
  static final int _sqliteBusyTimeout = 773;
  // ignore: unused_field
  static final int _sqliteCantopenConvpath = 1038;
  // ignore: unused_field
  static final int _sqliteCantopenDirtywal = 1294;
  // ignore: unused_field
  static final int _sqliteCantopenFullpath = 782;
  // ignore: unused_field
  static final int _sqliteCantopenIsdir = 526;
  // ignore: unused_field
  static final int _sqliteCantopenNotempdir = 270;
  // ignore: unused_field
  static final int _sqliteCantopenSymlink = 1550;
  // ignore: unused_field
  static final int _sqliteConstraintCheck = 275;
  // ignore: unused_field
  static final int _sqliteConstraintCommithook = 531;
  // ignore: unused_field
  static final int _sqliteConstraintForeignkey = 787;
  // ignore: unused_field
  static final int _sqliteConstraintFunction = 1043;
  // ignore: unused_field
  static final int _sqliteConstraintNotnull = 1299;
  // ignore: unused_field
  static final int _sqliteConstraintPinned = 2835;
  // ignore: unused_field
  static final int _sqliteConstraintPrimarykey = 1555;
  // ignore: unused_field
  static final int _sqliteConstraintRowid = 2579;
  // ignore: unused_field
  static final int _sqliteConstraintTrigger = 1811;
  // ignore: unused_field
  static final int _sqliteConstraintUnique = 2067;
  // ignore: unused_field
  static final int _sqliteConstraintVtab = 2323;
  // ignore: unused_field
  static final int _sqliteCorruptIndex = 779;
  // ignore: unused_field
  static final int _sqliteCorruptSequence = 523;
  // ignore: unused_field
  static final int _sqliteCorruptVtab = 267;
  // ignore: unused_field
  static final int _sqliteErrorMissingCollseq = 257;
  // ignore: unused_field
  static final int _sqliteErrorRetry = 513;
  // ignore: unused_field
  static final int _sqliteErrorSnapshot = 769;
  // ignore: unused_field
  static final int _sqliteIoerrAccess = 3338;
  // ignore: unused_field
  static final int _sqliteIoerrAuth = 7178;
  // ignore: unused_field
  static final int _sqliteIoerrBeginAtomic = 7434;
  // ignore: unused_field
  static final int _sqliteIoerrBlocked = 2826;
  // ignore: unused_field
  static final int _sqliteIoerrCheckreservedlock = 3594;
  // ignore: unused_field
  static final int _sqliteIoerrClose = 4106;
  // ignore: unused_field
  static final int _sqliteIoerrCommitAtomic = 7690;
  // ignore: unused_field
  static final int _sqliteIoerrConvpath = 6666;
  // ignore: unused_field
  static final int _sqliteIoerrData = 8202;
  // ignore: unused_field
  static final int _sqliteIoerrDelete = 2570;
  // ignore: unused_field
  static final int _sqliteIoerrDeleteNoent = 5898;
  // ignore: unused_field
  static final int _sqliteIoerrDirClose = 4362;
  // ignore: unused_field
  static final int _sqliteIoerrDirFsync = 1290;
  // ignore: unused_field
  static final int _sqliteIoerrFstat = 1802;
  // ignore: unused_field
  static final int _sqliteIoerrFsync = 1034;
  // ignore: unused_field
  static final int _sqliteIoerrFettemppath = 6410;
  // ignore: unused_field
  static final int _sqliteIoerrLock = 3850;
  // ignore: unused_field
  static final int _sqliteIoerrMmap = 6154;
  // ignore: unused_field
  static final int _sqliteIoerrNomem = 308;
  // ignore: unused_field
  static final int _sqliteIoerrRdlock = 231;
  // ignore: unused_field
  static final int _sqliteIoerrRead = 266;
  // ignore: unused_field
  static final int _sqliteIoerrRollbackAtomic = 7946;
  // ignore: unused_field
  static final int _sqliteIoerrSeek = 5642;
  // ignore: unused_field
  static final int _sqliteIoerrShmlock = 5130;
  // ignore: unused_field
  static final int _sqliteIoerrShmmap = 5386;
  // ignore: unused_field
  static final int _sqliteIoerrShmopen = 4618;
  // ignore: unused_field
  static final int _sqliteIoerrShmsize = 4874;
  // ignore: unused_field
  static final int _sqliteIoerrShortRead = 522;
  // ignore: unused_field
  static final int _sqliteIoerrTruncate = 1546;
  // ignore: unused_field
  static final int _sqliteIoerrUnlock = 2058;
  // ignore: unused_field
  static final int _sqliteIoerrVnode = 6922;
  // ignore: unused_field
  static final int _sqliteIoerrWrite = 778;
  // ignore: unused_field
  static final int _sqliteLockedSharedcache = 262;

  /// The [DriftStore]
  final DriftStore store;

  /// The [ShadertoySqliteOptions]
  final ShadertoySqliteOptions options;

  /// Creates a [ShadertoySqliteStore]
  ///
  /// * [store]: A pre-initialized [DriftStore] store
  /// * [options]: The [ShadertoySqliteOptions] used to configure this store
  ShadertoySqliteStore(this.store, this.options);

  /// Converts a [SqliteException] to a [ResponseError]
  ///
  /// * [sqle]: The [SqliteException]
  /// * [context]: The optional context of the error
  /// * [target]: The optional target of the error
  ///
  /// Used to create a consistent response when there is a internal error
  ResponseError _toResponseError(SqliteException sqle,
      {String? context, String? target}) {
    if (sqle.resultCode == _sqliteAuth) {
      return ResponseError.authorization(
          message: sqle.message, context: context, target: target);
    } else if (sqle.extendedResultCode == _sqliteBusyTimeout) {
      return ResponseError.backendTimeout(
          message: sqle.message, context: context, target: target);
    } else if (sqle.resultCode == _sqliteAbort ||
        sqle.extendedResultCode == _sqliteAbortRollback) {
      return ResponseError.aborted(
          message: sqle.message, context: context, target: target);
    } else if (sqle.extendedResultCode == _sqliteConstraintPrimarykey ||
        sqle.extendedResultCode == _sqliteConstraintUnique ||
        sqle.extendedResultCode == _sqliteConstraintRowid) {
      return ResponseError.conflict(
          message: sqle.message, context: context, target: target);
    } else if (sqle.resultCode == _sqliteConstraint ||
        sqle.extendedResultCode == _sqliteConstraintCheck ||
        sqle.extendedResultCode == _sqliteConstraintNotnull ||
        sqle.extendedResultCode == _sqliteConstraintForeignkey) {
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
                    context: contextUser,
                    target: userId))),
        (sqle) => FindUserResponse(
            error:
                _toResponseError(sqle, context: contextUser, target: userId)));
  }

  @override
  Future<FindUserIdsResponse> findAllUserIds() {
    return _catchSqlError<FindUserIdsResponse>(
        store.userDao
            .findAllIds()
            .then((value) => FindUserIdsResponse(ids: value)),
        (sqle) => FindUserIdsResponse(
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<FindUsersResponse> findAllUsers() {
    return _catchSqlError<FindUsersResponse>(
        store.userDao.findAll().then((results) => FindUsersResponse(
            users:
                results.map((user) => FindUserResponse(user: user)).toList())),
        (sqle) => FindUsersResponse(
            error: _toResponseError(sqle, context: contextUser)));
  }

  @override
  Future<SaveUserResponse> saveUser(User user) {
    return _catchSqlError<SaveUserResponse>(
        store.userDao.save(user).then((response) => SaveUserResponse()),
        (sqle) => SaveUserResponse(
            error:
                _toResponseError(sqle, context: contextUser, target: user.id)));
  }

  @override
  Future<SaveUsersResponse> saveUsers(List<User> users) {
    return _catchSqlError<SaveUsersResponse>(
        store.userDao.saveAll(users).then((reponse) => SaveUsersResponse()),
        (sqle) => SaveUsersResponse(
            error: _toResponseError(sqle, context: contextUser)));
  }

  @override
  Future<DeleteUserResponse> deleteUserById(String userId) {
    return _catchSqlError<DeleteUserResponse>(
        store.userDao
            .deleteById(userId)
            .then((reponse) => DeleteUserResponse()),
        (sqle) => DeleteUserResponse(
            error:
                _toResponseError(sqle, context: contextUser, target: userId)));
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return _catchSqlError<FindShaderResponse>(
        store.shaderDao.findById(shaderId).then((value) => value != null
            ? FindShaderResponse(shader: value)
            : FindShaderResponse(
                error: ResponseError.notFound(
                    message: 'Shader $shaderId not found',
                    context: contextShader,
                    target: shaderId))),
        (sqle) => FindShaderResponse(
            error: _toResponseError(sqle,
                context: contextShader, target: shaderId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findAllIds()
            .then((value) => FindShaderIdsResponse(ids: value)),
        (sqle) => FindShaderIdsResponse(
            error: _toResponseError(sqle, context: contextShader)));
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
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    return _catchSqlError<FindShadersResponse>(
        Future.wait(shaderIds.map((id) => findShaderById(id).then(
                (FindShaderResponse sr) =>
                    FindShaderResponse(shader: sr.shader))))
            .then((shaders) => FindShadersResponse(shaders: shaders)),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle, context: contextShader)));
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
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<FindShadersResponse> findAllShaders() {
    return _catchSqlError<FindShadersResponse>(
        store.shaderDao.findAll().then((results) => FindShadersResponse(
            shaders: results
                .map((shader) => FindShaderResponse(shader: shader))
                .toList())),
        (sqle) => FindShadersResponse(
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<SaveShaderResponse> saveShader(Shader shader) {
    return _catchSqlError<SaveShaderResponse>(
        store.shaderDao.save(shader).then((reponse) => SaveShaderResponse()),
        (sqle) => SaveShaderResponse(
            error: _toResponseError(sqle,
                context: contextShader, target: shader.info.id)));
  }

  @override
  Future<SaveShadersResponse> saveShaders(List<Shader> shaders) {
    return _catchSqlError<SaveShadersResponse>(
        store.shaderDao
            .saveAll(shaders)
            .then((reponse) => SaveShadersResponse()),
        (sqle) => SaveShadersResponse(
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<DeleteShaderResponse> deleteShaderById(String shaderId) {
    return _catchSqlError<DeleteShaderResponse>(
        store.shaderDao
            .deleteById(shaderId)
            .then((reponse) => DeleteShaderResponse()),
        (sqle) => DeleteShaderResponse(
            error: _toResponseError(sqle,
                context: contextShader, target: shaderId)));
  }

  @override
  Future<FindCommentResponse> findCommentById(String commentId) {
    return _catchSqlError<FindCommentResponse>(
        store.commentDao.findById(commentId).then((value) => value != null
            ? FindCommentResponse(comment: value)
            : FindCommentResponse(
                error: ResponseError.notFound(
                    message: 'Comment $commentId not found',
                    context: contextComment,
                    target: commentId))),
        (sqle) => FindCommentResponse(
            error: _toResponseError(sqle,
                context: contextComment, target: commentId)));
  }

  @override
  Future<FindCommentIdsResponse> findAllCommentIds() {
    return _catchSqlError<FindCommentIdsResponse>(
        store.commentDao
            .findAllIds()
            .then((value) => FindCommentIdsResponse(ids: value)),
        (sqle) => FindCommentIdsResponse(
            error: _toResponseError(sqle, context: contextComment)));
  }

  @override
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId) {
    return _catchSqlError<FindCommentsResponse>(
        store.commentDao.findByShaderId(shaderId).then((results) =>
            FindCommentsResponse(
                comments: results.map((r) => r.copyWith()).toList())),
        (sqle) => FindCommentsResponse(
            error: _toResponseError(sqle,
                context: contextComment, target: shaderId)));
  }

  @override
  Future<FindCommentsResponse> findAllComments() {
    return _catchSqlError<FindCommentsResponse>(
        store.commentDao
            .findAll()
            .then((value) => FindCommentsResponse(comments: value)),
        (sqle) => FindCommentsResponse(
            error: _toResponseError(sqle, context: contextComment)));
  }

  @override
  Future<SaveShaderCommentResponse> saveShaderComment(Comment comment) {
    return _catchSqlError<SaveShaderCommentResponse>(
        store.commentDao
            .save(comment)
            .then((reponse) => SaveShaderCommentResponse()),
        (sqle) => SaveShaderCommentResponse(
            error: _toResponseError(sqle, context: contextComment)));
  }

  @override
  Future<SaveShaderCommentsResponse> saveShaderComments(
      List<Comment> comments) {
    return _catchSqlError<SaveShaderCommentsResponse>(
        store.commentDao
            .saveAll(comments)
            .then((reponse) => SaveShaderCommentsResponse()),
        (sqle) => SaveShaderCommentsResponse(
            error: _toResponseError(sqle, context: contextComment)));
  }

  @override
  Future<DeleteCommentResponse> deleteCommentById(String commentId) {
    return _catchSqlError<DeleteCommentResponse>(
        store.commentDao
            .deleteById(commentId)
            .then((reponse) => DeleteCommentResponse()),
        (sqle) => DeleteCommentResponse(
            error: _toResponseError(sqle,
                context: contextComment, target: commentId)));
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
                _toResponseError(sqle, context: contextUser, target: userId)));
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
                _toResponseError(sqle, context: contextUser, target: userId)));
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId) {
    return _catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(userId: userId)
            .then((results) => FindShaderIdsResponse(ids: results.toList())),
        (sqle) => FindShaderIdsResponse(
            error:
                _toResponseError(sqle, context: contextUser, target: userId)));
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
                        context: contextPlaylist,
                        target: playlistId))),
        (sqle) => FindPlaylistResponse(
            error: _toResponseError(sqle,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<FindPlaylistIdsResponse> findAllPlaylistIds() {
    return _catchSqlError<FindPlaylistIdsResponse>(
        store.playlistDao
            .findAllIds()
            .then((value) => FindPlaylistIdsResponse(ids: value)),
        (sqle) => FindPlaylistIdsResponse(
            error: _toResponseError(sqle, context: contextPlaylist)));
  }

  @override
  Future<FindPlaylistsResponse> findAllPlaylists() {
    return _catchSqlError<FindPlaylistsResponse>(
        store.playlistDao.findAll().then((results) => FindPlaylistsResponse(
            playlists: results
                .map((playlist) => FindPlaylistResponse(playlist: playlist))
                .toList())),
        (sqle) => FindPlaylistsResponse(
            error: _toResponseError(sqle, context: contextPlaylist)));
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
                context: contextPlaylist, target: playlistId)));
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
                context: contextPlaylist, target: playlistId)));
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
                context: contextPlaylist, target: playlistId)));
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
                context: contextPlaylist, target: playlist.id)));
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
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<DeletePlaylistResponse> deletePlaylistById(String playlistId) {
    return _catchSqlError<DeletePlaylistResponse>(
        store.playlistDao
            .deleteById(playlistId)
            .then((reponse) => DeletePlaylistResponse()),
        (sqle) => DeletePlaylistResponse(
            error: _toResponseError(sqle,
                context: contextPlaylist, target: playlistId)));
  }

  @override
  Future<FindSyncResponse> findSyncById(SyncType type, String target) {
    return _catchSqlError<FindSyncResponse>(
        store.syncDao.findById(type, target).then((value) => value != null
            ? FindSyncResponse(sync: value)
            : FindSyncResponse(
                error: ResponseError.notFound(
                    message: 'Sync $target not found',
                    context: contextSync,
                    target: target))),
        (sqle) => FindSyncResponse(
            error: _toResponseError(sqle,
                context: contextShader, target: target)));
  }

  @override
  Future<FindSyncsResponse> findAllSyncs() {
    return _catchSqlError<FindSyncsResponse>(
        store.syncDao.findAll().then((results) => FindSyncsResponse(
            syncs:
                results.map((sync) => FindSyncResponse(sync: sync)).toList())),
        (sqle) => FindSyncsResponse(
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<FindSyncsResponse> findSyncs(
      {SyncType? type,
      String? target,
      Set<SyncStatus>? status,
      DateTime? createdBefore,
      DateTime? updatedBefore}) {
    return _catchSqlError<FindSyncsResponse>(
        store.syncDao
            .find(
                type: type,
                target: target,
                status: status,
                createdBefore: createdBefore,
                updatedBefore: updatedBefore)
            .then((results) => FindSyncsResponse(
                syncs: results
                    .map((sync) => FindSyncResponse(sync: sync))
                    .toList())),
        (sqle) => FindSyncsResponse(
            error: _toResponseError(sqle, context: contextSync)));
  }

  @override
  Future<SaveSyncResponse> saveSync(Sync sync) {
    return _catchSqlError<SaveSyncResponse>(
        store.syncDao.save(sync).then((reponse) => SaveSyncResponse()),
        (sqle) => SaveSyncResponse(
            error: _toResponseError(sqle,
                context: contextSync, target: sync.target)));
  }

  @override
  Future<SaveSyncsResponse> saveSyncs(List<Sync> syncs) {
    return _catchSqlError<SaveSyncsResponse>(
        store.syncDao.saveAll(syncs).then((reponse) => SaveSyncsResponse()),
        (sqle) => SaveSyncsResponse(
            error: _toResponseError(sqle, context: contextShader)));
  }

  @override
  Future<DeleteSyncResponse> deleteSyncById(SyncType type, target) {
    return _catchSqlError<DeleteSyncResponse>(
        store.syncDao
            .deleteById(type, target)
            .then((reponse) => DeleteSyncResponse()),
        (sqle) => DeleteSyncResponse(
            error: _toResponseError(sqle,
                context: contextShader, target: target)));
  }
}
