import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/backend/unsupported.dart'
    if (dart.library.js) 'package:shadertoy_sqlite/src/sqlite/backend/web.dart'
    if (dart.library.ffi) 'package:shadertoy_sqlite/src/sqlite/backend/native.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';

class ShadertoySqliteStore extends ShadertoyBaseStore {
  /// The [DriftStore]
  final DriftStore store;

  /// The [ShadertoySqliteOptions]
  final ShadertoySqliteOptions options;

  /// Creates a [ShadertoySqliteStore]
  ///
  /// * [store]: A pre-initialized [DriftStore] store
  /// * [options]: The [ShadertoySqliteOptions] used to configure this store
  ShadertoySqliteStore(this.store, this.options);

  @override
  Future<FindUserResponse> findUserById(String userId) {
    return catchSqlError<FindUserResponse>(
        store.userDao.findById(userId).then((value) => value != null
            ? FindUserResponse(user: value)
            : FindUserResponse(
                error: ResponseError.notFound(
                    message: 'User $userId not found',
                    context: contextUser,
                    target: userId))),
        (sqle) => FindUserResponse(
            error: toResponseError(sqle, context: contextUser, target: userId)),
        options);
  }

  @override
  Future<FindUserIdsResponse> findAllUserIds() {
    return catchSqlError<FindUserIdsResponse>(
        store.userDao
            .findAllIds()
            .then((value) => FindUserIdsResponse(ids: value)),
        (sqle) => FindUserIdsResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindUsersResponse> findAllUsers() {
    return catchSqlError<FindUsersResponse>(
        store.userDao.findAll().then((results) => FindUsersResponse(
            users:
                results.map((user) => FindUserResponse(user: user)).toList())),
        (sqle) => FindUsersResponse(
            error: toResponseError(sqle, context: contextUser)),
        options);
  }

  @override
  Future<SaveUserResponse> saveUser(User user) {
    return catchSqlError<SaveUserResponse>(
        store.userDao.save(user).then((response) => SaveUserResponse()),
        (sqle) => SaveUserResponse(
            error:
                toResponseError(sqle, context: contextUser, target: user.id)),
        options);
  }

  @override
  Future<SaveUsersResponse> saveUsers(List<User> users) {
    return catchSqlError<SaveUsersResponse>(
        store.userDao.saveAll(users).then((reponse) => SaveUsersResponse()),
        (sqle) => SaveUsersResponse(
            error: toResponseError(sqle, context: contextUser)),
        options);
  }

  @override
  Future<DeleteUserResponse> deleteUserById(String userId) {
    return catchSqlError<DeleteUserResponse>(
        store.userDao
            .deleteById(userId)
            .then((reponse) => DeleteUserResponse()),
        (sqle) => DeleteUserResponse(
            error: toResponseError(sqle, context: contextUser, target: userId)),
        options);
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    return catchSqlError<FindShaderResponse>(
        store.shaderDao.findById(shaderId).then((value) => value != null
            ? FindShaderResponse(shader: value)
            : FindShaderResponse(
                error: ResponseError.notFound(
                    message: 'Shader $shaderId not found',
                    context: contextShader,
                    target: shaderId))),
        (sqle) => FindShaderResponse(
            error: toResponseError(sqle,
                context: contextShader, target: shaderId)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findAllIds()
            .then((value) => FindShaderIdsResponse(ids: value)),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(
                term: term,
                filters: filters,
                sort: sort ?? Sort.hot,
                from: from,
                num: num ?? ShadertoySqliteOptions.defaultShaderCount)
            .then((results) => FindShaderIdsResponse(ids: results)),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    return catchSqlError<FindShadersResponse>(
        Future.wait(shaderIds.map((id) => findShaderById(id).then(
                (FindShaderResponse sr) =>
                    FindShaderResponse(shader: sr.shader))))
            .then((shaders) => FindShadersResponse(shaders: shaders)),
        (sqle) => FindShadersResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchSqlError<FindShadersResponse>(
        store.shaderDao
            .find(
                term: term,
                filters: filters,
                sort: sort ?? Sort.hot,
                from: from,
                num: num ?? ShadertoySqliteOptions.defaultShaderCount)
            .then((results) => FindShadersResponse(
                shaders: results
                    .map((shader) => FindShaderResponse(shader: shader))
                    .toList())),
        (sqle) => FindShadersResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindShadersResponse> findAllShaders() {
    return catchSqlError<FindShadersResponse>(
        store.shaderDao.findAll().then((results) => FindShadersResponse(
            shaders: results
                .map((shader) => FindShaderResponse(shader: shader))
                .toList())),
        (sqle) => FindShadersResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<SaveShaderResponse> saveShader(Shader shader) {
    return catchSqlError<SaveShaderResponse>(
        store.shaderDao.save(shader).then((reponse) => SaveShaderResponse()),
        (sqle) => SaveShaderResponse(
            error: toResponseError(sqle,
                context: contextShader, target: shader.info.id)),
        options);
  }

  @override
  Future<SaveShadersResponse> saveShaders(List<Shader> shaders) {
    return catchSqlError<SaveShadersResponse>(
        store.shaderDao
            .saveAll(shaders)
            .then((reponse) => SaveShadersResponse()),
        (sqle) => SaveShadersResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<DeleteShaderResponse> deleteShaderById(String shaderId) {
    return catchSqlError<DeleteShaderResponse>(
        store.shaderDao
            .deleteById(shaderId,
                foreignKeysEnabled: options.foreignKeysEnabled)
            .then((reponse) => DeleteShaderResponse()),
        (sqle) => DeleteShaderResponse(
            error: toResponseError(sqle,
                context: contextShader, target: shaderId)),
        options);
  }

  @override
  Future<FindCommentResponse> findCommentById(String commentId) {
    return catchSqlError<FindCommentResponse>(
        store.commentDao.findById(commentId).then((value) => value != null
            ? FindCommentResponse(comment: value)
            : FindCommentResponse(
                error: ResponseError.notFound(
                    message: 'Comment $commentId not found',
                    context: contextComment,
                    target: commentId))),
        (sqle) => FindCommentResponse(
            error: toResponseError(sqle,
                context: contextComment, target: commentId)),
        options);
  }

  @override
  Future<FindCommentIdsResponse> findAllCommentIds() {
    return catchSqlError<FindCommentIdsResponse>(
        store.commentDao
            .findAllIds()
            .then((value) => FindCommentIdsResponse(ids: value)),
        (sqle) => FindCommentIdsResponse(
            error: toResponseError(sqle, context: contextComment)),
        options);
  }

  @override
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId) {
    return catchSqlError<FindCommentsResponse>(
        store.commentDao.findByShaderId(shaderId).then((results) =>
            FindCommentsResponse(
                comments: results.map((r) => r.copyWith()).toList())),
        (sqle) => FindCommentsResponse(
            error: toResponseError(sqle,
                context: contextComment, target: shaderId)),
        options);
  }

  @override
  Future<FindCommentsResponse> findAllComments() {
    return catchSqlError<FindCommentsResponse>(
        store.commentDao
            .findAll()
            .then((value) => FindCommentsResponse(comments: value)),
        (sqle) => FindCommentsResponse(
            error: toResponseError(sqle, context: contextComment)),
        options);
  }

  @override
  Future<SaveShaderCommentResponse> saveShaderComment(Comment comment) {
    return catchSqlError<SaveShaderCommentResponse>(
        store.commentDao
            .save(comment)
            .then((reponse) => SaveShaderCommentResponse()),
        (sqle) => SaveShaderCommentResponse(
            error: toResponseError(sqle, context: contextComment)),
        options);
  }

  @override
  Future<SaveShaderCommentsResponse> saveShaderComments(
      String shaderId, List<Comment> comments) {
    return catchSqlError<SaveShaderCommentsResponse>(
        store.commentDao
            .saveAll(comments)
            .then((reponse) => SaveShaderCommentsResponse()),
        (sqle) => SaveShaderCommentsResponse(
            error: toResponseError(sqle,
                context: contextComment, target: shaderId)),
        options);
  }

  @override
  Future<DeleteShaderCommentsResponse> deleteShaderComments(String shaderId) {
    return catchSqlError<DeleteShaderCommentsResponse>(
        store.commentDao
            .deleteByShaderId(shaderId)
            .then((reponse) => DeleteShaderCommentsResponse()),
        (sqle) => DeleteShaderCommentsResponse(
            error: toResponseError(sqle,
                context: contextComment, target: shaderId)),
        options);
  }

  @override
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchSqlError<FindShadersResponse>(
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
            error: toResponseError(sqle, context: contextUser, target: userId)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num}) {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(
                userId: userId,
                filters: filters,
                sort: sort ?? Sort.popular,
                from: from,
                num: num = options.userShaderCount)
            .then((results) => FindShaderIdsResponse(ids: results.toList())),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle, context: contextUser, target: userId)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId) {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIds(userId: userId)
            .then((results) => FindShaderIdsResponse(ids: results.toList())),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle, context: contextUser, target: userId)),
        options);
  }

  @override
  Future<FindPlaylistResponse> findPlaylistById(String playlistId) {
    return catchSqlError<FindPlaylistResponse>(
        store.playlistDao.findById(playlistId).then((playlist) =>
            playlist != null
                ? FindPlaylistResponse(playlist: playlist)
                : FindPlaylistResponse(
                    error: ResponseError.notFound(
                        message: 'Playlist $playlistId not found',
                        context: contextPlaylist,
                        target: playlistId))),
        (sqle) => FindPlaylistResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<FindPlaylistIdsResponse> findAllPlaylistIds() {
    return catchSqlError<FindPlaylistIdsResponse>(
        store.playlistDao
            .findAllIds()
            .then((value) => FindPlaylistIdsResponse(ids: value)),
        (sqle) => FindPlaylistIdsResponse(
            error: toResponseError(sqle, context: contextPlaylist)),
        options);
  }

  @override
  Future<FindPlaylistsResponse> findAllPlaylists() {
    return catchSqlError<FindPlaylistsResponse>(
        store.playlistDao.findAll().then((results) => FindPlaylistsResponse(
            playlists: results
                .map((playlist) => FindPlaylistResponse(playlist: playlist))
                .toList())),
        (sqle) => FindPlaylistsResponse(
            error: toResponseError(sqle, context: contextPlaylist)),
        options);
  }

  @override
  Future<FindShadersResponse> findShadersByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return catchSqlError<FindShadersResponse>(
        store.shaderDao
            .findByPlaylist(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((results) => FindShadersResponse(
                shaders: results
                    .map((r) => FindShaderResponse(shader: r))
                    .toList())),
        (sqle) => FindShadersResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findShaderIdsByPlaylistId(String playlistId,
      {int? from, int? num}) {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIdsByPlaylist(playlistId,
                from: from, num: num ?? options.playlistShaderCount)
            .then((shaderIds) => FindShaderIdsResponse(ids: shaderIds)),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<FindShaderIdsResponse> findAllShaderIdsByPlaylistId(
      String playlistId) {
    return catchSqlError<FindShaderIdsResponse>(
        store.shaderDao
            .findIdsByPlaylist(playlistId)
            .then((shaderIds) => FindShaderIdsResponse(ids: shaderIds)),
        (sqle) => FindShaderIdsResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<SavePlaylistResponse> savePlaylist(Playlist playlist,
      {List<String>? shaderIds}) {
    return catchSqlError<SavePlaylistResponse>(
        store.playlistDao
            .save(playlist, shaderIds: shaderIds)
            .then((reponse) => SavePlaylistResponse()),
        (sqle) => SavePlaylistResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlist.id)),
        options);
  }

  @override
  Future<SavePlaylistShadersResponse> savePlaylistShaders(
      String playlistId, List<String> shaderIds) {
    return catchSqlError<SavePlaylistShadersResponse>(
        store.playlistDao
            .savePlaylistShaders(playlistId, shaderIds)
            .then((reponse) => SavePlaylistShadersResponse()),
        (sqle) => SavePlaylistShadersResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<DeletePlaylistResponse> deletePlaylistById(String playlistId) {
    return catchSqlError<DeletePlaylistResponse>(
        store.playlistDao
            .deleteById(playlistId,
                foreignKeysEnabled: options.foreignKeysEnabled)
            .then((reponse) => DeletePlaylistResponse()),
        (sqle) => DeletePlaylistResponse(
            error: toResponseError(sqle,
                context: contextPlaylist, target: playlistId)),
        options);
  }

  @override
  Future<FindSyncResponse> findSyncById(SyncType type, String target) {
    return catchSqlError<FindSyncResponse>(
        store.syncDao.findById(type, target).then((value) => value != null
            ? FindSyncResponse(sync: value)
            : FindSyncResponse(
                error: ResponseError.notFound(
                    message: 'Sync $target not found',
                    context: contextSync,
                    target: target))),
        (sqle) => FindSyncResponse(
            error:
                toResponseError(sqle, context: contextShader, target: target)),
        options);
  }

  @override
  Future<FindSyncsResponse> findAllSyncs() {
    return catchSqlError<FindSyncsResponse>(
        store.syncDao.findAll().then((results) => FindSyncsResponse(
            syncs:
                results.map((sync) => FindSyncResponse(sync: sync)).toList())),
        (sqle) => FindSyncsResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<FindSyncsResponse> findSyncs(
      {SyncType? type,
      String? target,
      Set<SyncStatus>? status,
      DateTime? createdBefore,
      DateTime? updatedBefore}) {
    return catchSqlError<FindSyncsResponse>(
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
            error: toResponseError(sqle, context: contextSync)),
        options);
  }

  @override
  Future<SaveSyncResponse> saveSync(Sync sync) {
    return catchSqlError<SaveSyncResponse>(
        store.syncDao.save(sync).then((reponse) => SaveSyncResponse()),
        (sqle) => SaveSyncResponse(
            error: toResponseError(sqle,
                context: contextSync, target: sync.target)),
        options);
  }

  @override
  Future<SaveSyncsResponse> saveSyncs(List<Sync> syncs) {
    return catchSqlError<SaveSyncsResponse>(
        store.syncDao.saveAll(syncs).then((reponse) => SaveSyncsResponse()),
        (sqle) => SaveSyncsResponse(
            error: toResponseError(sqle, context: contextShader)),
        options);
  }

  @override
  Future<DeleteSyncResponse> deleteSyncById(SyncType type, target) {
    return catchSqlError<DeleteSyncResponse>(
        store.syncDao
            .deleteById(type, target)
            .then((reponse) => DeleteSyncResponse()),
        (sqle) => DeleteSyncResponse(
            error:
                toResponseError(sqle, context: contextShader, target: target)),
        options);
  }
}
