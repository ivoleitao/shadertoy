import 'dart:convert';

import 'package:resource_portable/resource.dart' show Resource;
import 'package:shadertoy/shadertoy_api.dart';

Resource _resourceFixture(String path) {
  final baseUri = Uri.base;

  return Resource(baseUri.isScheme('file')
      ? baseUri.resolve('test/fixtures/$path')
      : baseUri.resolve('fixtures/$path'));
}

Future<String> _textFixture(String path) =>
    _resourceFixture(path).readAsString(encoding: utf8);

Future<Map<String, dynamic>> jsonFixture(String path) =>
    _textFixture(path).then((text) => json.decode(text));

Future<List> jsonListFixture(String path) =>
    _textFixture(path).then((text) => json.decode(text));

Future<User> userFixture(String path) =>
    jsonFixture(path).then((json) => User.fromJson(json));

Future<String> userIdFixture(String path) =>
    userFixture(path).then((user) => user.id);

Future<List<User>> usersFixture(List<String> paths) =>
    Future.wait(paths.map((p) => userFixture(p)));

Future<FindUserResponse> findUserResponseFixture(String path,
        {ResponseError? error}) =>
    userFixture(path)
        .then((user) => FindUserResponse(user: user, error: error));

Future<FindUserIdsResponse> findUserIdsResponseFixture(List<String> paths,
        {int? count, ResponseError? error}) =>
    Future.wait(paths.map((p) => userIdFixture(p))).then(
        (ids) => FindUserIdsResponse(count: count, ids: ids, error: error));

Future<FindUsersResponse> findUsersResponseFixture(List<String> paths,
        {ResponseError? error}) =>
    Future.wait(paths.map((p) => findUserResponseFixture(p)))
        .then((users) => FindUsersResponse(users: users, error: error));

Future<Shader> shaderFixture(String path) =>
    jsonFixture(path).then((json) => Shader.fromJson(json));

Future<List<Shader>> shadersFixture(List<String> paths) =>
    Future.wait(paths.map((p) => shaderFixture(p)));

Future<FindShaderResponse> findShaderResponseFixture(String path,
        {ResponseError? error}) =>
    shaderFixture(path)
        .then((shader) => FindShaderResponse(shader: shader, error: error));

Future<String> shaderIdFixture(String path) =>
    shaderFixture(path).then((shader) => shader.info.id);

Future<FindShaderIdsResponse> findShaderIdsResponseFixture(List<String> paths,
        {int? count, ResponseError? error}) =>
    Future.wait(paths.map((p) => shaderIdFixture(p))).then(
        (ids) => FindShaderIdsResponse(count: count, ids: ids, error: error));

Future<FindShadersRequest> findShadersRequestFixture(List<String> paths) =>
    Future.wait(paths.map((p) => shaderIdFixture(p)))
        .then((ids) => FindShadersRequest(ids.toSet()));

Future<FindShadersResponse> findShadersResponseFixture(List<String> paths,
        {ResponseError? error}) =>
    Future.wait(paths.map((p) => findShaderResponseFixture(p)))
        .then((shaders) => FindShadersResponse(shaders: shaders, error: error));

Future<List<Comment>> commentsFixture(String path) => jsonListFixture(path)
    .then((list) => list.map((comment) => Comment.fromJson(comment)).toList());

Future<List<String>> commentIdsFixture(String path) => commentsFixture(path)
    .then((comments) => comments.map((comment) => comment.id).toList());

Future<FindCommentIdsResponse> findCommentIdsResponseFixture(String path,
        {int? count, ResponseError? error}) =>
    commentIdsFixture(path)
        .then((ids) => FindCommentIdsResponse(ids: ids, error: error));

Future<CommentsResponse> commentsResponseFixture(String path) =>
    jsonFixture(path).then((json) => CommentsResponse.fromMap(json));

Future<FindCommentsResponse> findCommentsResponseFixture(String path,
        {ResponseError? error}) =>
    commentsFixture(path).then(
        (comments) => FindCommentsResponse(comments: comments, error: error));

Future<Playlist> playlistFixture(String path) =>
    jsonFixture(path).then((json) => Playlist.fromJson(json));

Future<String> playlistIdFixture(String path) =>
    playlistFixture(path).then((playlist) => playlist.id);

Future<FindPlaylistResponse> findPlaylistResponseFixture(String path,
        {ResponseError? error}) =>
    playlistFixture(path).then(
        (playlist) => FindPlaylistResponse(playlist: playlist, error: error));

Future<FindPlaylistIdsResponse> findPlaylistIdsResponseFixture(
        List<String> paths,
        {int? count,
        ResponseError? error}) =>
    Future.wait(paths.map((p) => playlistIdFixture(p))).then(
        (ids) => FindPlaylistIdsResponse(count: count, ids: ids, error: error));

Future<FindPlaylistsResponse> findPlaylistsResponseFixture(List<String> paths,
        {ResponseError? error}) =>
    Future.wait(paths.map((p) => findPlaylistResponseFixture(p))).then(
        (playlists) =>
            FindPlaylistsResponse(playlists: playlists, error: error));
