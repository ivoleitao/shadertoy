import 'dart:convert';

import 'package:shadertoy/src/api.dart';
import 'package:shadertoy/src/model/comment.dart';
import 'package:shadertoy/src/model/info.dart';
import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/output.dart';
import 'package:shadertoy/src/model/playlist.dart';
import 'package:shadertoy/src/model/render_pass.dart';
import 'package:shadertoy/src/model/sampler.dart';
import 'package:shadertoy/src/model/shader.dart';
import 'package:shadertoy/src/model/user.dart';
import 'package:shadertoy/src/response.dart';
import 'package:test/test.dart';

void main() {
  final genericResponseError1 = ResponseError(
      code: ErrorCode.unknown,
      message: 'Unknown error',
      context: contextShader,
      target: 'wtd3zs');

  test('Convert a response error to a JSON serializable map and back', () {
    final json = genericResponseError1.toJson();
    final genericResponseError2 = ResponseError.fromJson(json);
    expect(genericResponseError1, equals(genericResponseError2));
  });

  test('Test a generic response error', () {
    expect(genericResponseError1.code, ErrorCode.unknown);
    expect(genericResponseError1.message, 'Unknown error');
    expect(genericResponseError1.context, contextShader);
    expect(genericResponseError1.target, 'wtd3zs');
  });

  test('Create a authentication response error', () {
    final responseError = ResponseError.authentication(
        message: 'Authentication error',
        context: contextUser,
        target: 'email@email.com');
    expect(responseError.code, ErrorCode.authentication);
    expect(responseError.message, 'Authentication error');
    expect(responseError.context, contextUser);
    expect(responseError.target, 'email@email.com');
  });

  test('Create a authorization response error', () {
    final responseError = ResponseError.authorization(
        message: 'Authorization error',
        context: contextUser,
        target: 'email@email.com');
    expect(responseError.code, ErrorCode.authorization);
    expect(responseError.message, 'Authorization error');
    expect(responseError.context, contextUser);
    expect(responseError.target, 'email@email.com');
  });

  test('Create a backend timeout response error', () {
    final responseError = ResponseError.backendTimeout(
        message: 'Backend timeout error',
        context: contextShader,
        target: 'wtd3zs');
    expect(responseError.code, ErrorCode.backendTimeout);
    expect(responseError.message, 'Backend timeout error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  test('Create a backend status response error', () {
    final responseError = ResponseError.backendStatus(
        message: 'Backend status error',
        context: contextShader,
        target: 'wtd3zs');
    expect(responseError.code, ErrorCode.backendStatus);
    expect(responseError.message, 'Backend status error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  test('Create a backend response response error', () {
    final responseError = ResponseError.backendResponse(
        message: 'Backend response error',
        context: contextShader,
        target: 'wtd3zs');
    expect(responseError.code, ErrorCode.backendResponse);
    expect(responseError.message, 'Backend response error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  test('Create a not found response error', () {
    final responseError = ResponseError.notFound(
        message: 'Not found error', context: contextShader, target: 'wtd3zs');
    expect(responseError.code, ErrorCode.notFound);
    expect(responseError.message, 'Not found error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  test('Create a aborted response error', () {
    final responseError = ResponseError.aborted(
        message: 'Aborted error', context: contextShader, target: 'wtd3zs');
    expect(responseError.code, ErrorCode.aborted);
    expect(responseError.message, 'Aborted error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  test('Create a unknown response error', () {
    final responseError = ResponseError.unknown(
        message: 'Unknown error', context: contextShader, target: 'wtd3zs');
    expect(responseError.code, ErrorCode.unknown);
    expect(responseError.message, 'Unknown error');
    expect(responseError.context, contextShader);
    expect(responseError.target, 'wtd3zs');
  });

  final loginResponse1 = LoginResponse(error: null);

  test('Test a login response', () {
    expect(loginResponse1.error, isNull);
  });

  test('Convert a login response to a JSON serializable map and back', () {
    final json = loginResponse1.toJson();
    final loginResponse2 = LoginResponse.fromJson(json);
    expect(loginResponse1, equals(loginResponse2));
  });

  final logoutResponse1 = LogoutResponse(error: null);

  test('Test a logout response', () {
    expect(logoutResponse1.error, isNull);
  });

  test('Convert a logout response to a JSON serializable map and back', () {
    final json = logoutResponse1.toJson();
    final logoutResponse2 = LogoutResponse.fromJson(json);
    expect(logoutResponse1, equals(logoutResponse2));
  });

  final memberSince = DateTime(2000, 1, 1, 0, 0, 0);
  final user = User(
      id: 'id1',
      picture: 'picture1',
      memberSince: memberSince,
      about: 'about1');
  final findUserResponse1 = FindUserResponse(user: user, error: null);

  test('Test a find user response', () {
    expect(findUserResponse1.user, user);
    expect(findUserResponse1.error, isNull);
  });

  test('Convert a find user response to a JSON serializable map and back', () {
    final json = findUserResponse1.toJson();
    final findUserResponse2 = FindUserResponse.fromJson(json);
    expect(findUserResponse1, equals(findUserResponse2));
  });

  final userIds = ['iq', 'shaderflix'];
  final findUserIdsResponse1 = FindUserIdsResponse(ids: userIds, error: null);

  test('Test a find user ids response', () {
    expect(findUserIdsResponse1.ids, userIds);
    expect(findUserIdsResponse1.error, isNull);
  });

  test('Convert a find user ids response to a JSON serializable map and back',
      () {
    final json = findUserIdsResponse1.toJson();
    final findUserIdsResponse2 = FindUserIdsResponse.fromJson(json);
    expect(findUserIdsResponse1, equals(findUserIdsResponse2));
  });

  final saveUserResponse1 = SaveUserResponse(error: null);

  test('Test save user response', () {
    expect(saveUserResponse1.error, isNull);
  });

  final saveUsersResponse1 = SaveUsersResponse(error: null);

  test('Test save users response', () {
    expect(saveUsersResponse1.error, isNull);
  });

  final deleteUserResponse1 = DeleteUserResponse(error: null);

  test('Test delete user response', () {
    expect(deleteUserResponse1.error, isNull);
  });

  final date = DateTime(2000, 1, 1, 0, 0, 0);
  final info = Info(
      id: 'id1',
      date: date,
      views: 1,
      name: 'name1',
      userId: 'userId1',
      description: 'description1',
      likes: 1,
      privacy: ShaderPrivacy.publicApi,
      flags: 1,
      tags: ['test1'],
      hasLiked: true);
  final sampler = Sampler(
      filter: FilterType.linear,
      wrap: WrapType.clamp,
      vflip: true,
      srgb: true,
      internal: 'internal1');
  final input = Input(
      id: 'id1',
      src: 'src1',
      type: InputType.buffer,
      channel: 1,
      sampler: sampler,
      published: 1);
  final output = Output(id: 'id1', channel: 1);
  final renderPass = RenderPass(
      name: 'name1',
      type: RenderPassType.buffer,
      description: 'description1',
      code: 'code1',
      inputs: [input],
      outputs: [output]);
  final shader = Shader(version: '1', info: info, renderPasses: [renderPass]);
  final findShaderResponse1 = FindShaderResponse(shader: shader, error: null);

  test('Test a find shader response', () {
    expect(findShaderResponse1.shader, shader);
    expect(findShaderResponse1.error, isNull);
  });

  test('Convert a find shader response to a JSON serializable map and back',
      () {
    final json = findShaderResponse1.toJson();
    final findShaderResponse2 = FindShaderResponse.fromJson(json);
    expect(findShaderResponse1, equals(findShaderResponse2));
  });

  final shaderIds = ['wtd3zs', 'XlcBRX'];
  final findShaderIdsResponse1 =
      FindShaderIdsResponse(ids: shaderIds, error: null);

  test('Test a find shader ids response', () {
    expect(findShaderIdsResponse1.ids, shaderIds);
    expect(findShaderIdsResponse1.error, isNull);
  });

  test('Convert a find shader ids response to a JSON serializable map and back',
      () {
    final json = findShaderIdsResponse1.toJson();
    final findShaderIdsResponse2 = FindShaderIdsResponse.fromJson(json);
    expect(findShaderIdsResponse1, equals(findShaderIdsResponse2));
  });

  final shaders = [findShaderResponse1];
  final findShadersResponse1 =
      FindShadersResponse(total: 1, shaders: shaders, error: null);

  test('Test find shaders response', () {
    expect(findShadersResponse1.total, 1);
    expect(findShadersResponse1.shaders, shaders);
    expect(findShadersResponse1.error, isNull);
  });

  test('Convert find shaders response to a JSON serializable map and back', () {
    final json = findShadersResponse1.toJson();
    final findShadersResponse2 = FindShadersResponse.fromJson(json);
    expect(findShadersResponse1, equals(findShadersResponse2));
  });

  final saveShaderResponse1 = SaveShaderResponse(error: null);

  test('Test save shader response', () {
    expect(saveShaderResponse1.error, isNull);
  });

  final saveShadersResponse1 = SaveShadersResponse(error: null);

  test('Test save shaders response', () {
    expect(saveShadersResponse1.error, isNull);
  });

  final deleteShaderResponse1 = DeleteShaderResponse(error: null);

  test('Test delete shader response', () {
    expect(deleteShaderResponse1.error, isNull);
  });

  final texts = ['comment1', 'comment2'];
  final dates = ['1548620329', '1551293191'];
  final userPictures = [
    '/img/profile.jpg',
    '/media/users/scratch13764/profile.png'
  ];
  final commentsResponse1 = CommentsResponse(
      texts: texts,
      dates: dates,
      userIds: userIds,
      userPictures: userPictures,
      error: null);

  test('Test a comments response', () {
    expect(commentsResponse1.texts, texts);
    expect(commentsResponse1.dates, dates);
    expect(commentsResponse1.userIds, userIds);
    expect(commentsResponse1.userPictures, userPictures);
    expect(commentsResponse1.error, isNull);
  });

  test('Convert a comments response to a JSON serializable map and back', () {
    final json = commentsResponse1.toJson();
    final commentsResponse2 = CommentsResponse.fromMap(json);
    expect(commentsResponse1, equals(commentsResponse2));
  });

  final now = DateTime.now();
  final comment1 = Comment(
      id: 'comentId1',
      shaderId: 'shaderId1',
      userId: 'userId1',
      picture: '/img/profile.jpg',
      date: now,
      text: 'text1');

  final findCommentResponse1 =
      FindCommentResponse(comment: comment1, error: null);

  test('Test find commment response', () {
    expect(findCommentResponse1.comment, comment1);
    expect(findCommentResponse1.error, isNull);
  });

  test('Convert a find comment response to a JSON serializable map and back',
      () {
    final json = findCommentResponse1.toJson();
    final findCommentResponse2 = FindCommentResponse.fromJson(json);
    expect(findCommentResponse1, equals(findCommentResponse2));
  });

  final commentIds = ['week', 'featured'];
  final findCommentIdsResponse1 =
      FindCommentIdsResponse(ids: commentIds, error: null);

  test('Test a find comment ids response', () {
    expect(findCommentIdsResponse1.ids, commentIds);
    expect(findCommentIdsResponse1.error, isNull);
  });

  test(
      'Convert a find comment ids response to a JSON serializable map and back',
      () {
    final json = findCommentIdsResponse1.toJson();
    final findCommentIdsResponse2 = FindCommentIdsResponse.fromJson(json);
    expect(findCommentIdsResponse1, equals(findCommentIdsResponse2));
  });

  final comment2 = Comment(
      id: 'commentId2',
      shaderId: 'shaderId2',
      userId: 'userId2',
      picture: '/img/profile.jpg',
      date: now,
      text: 'text2',
      hidden: true);
  final comments = [comment1, comment2];
  final findCommentsResponse1 =
      FindCommentsResponse(total: 2, comments: comments, error: null);

  test('Test a find comments response', () {
    expect(findCommentsResponse1.total, 2);
    expect(findCommentsResponse1.comments, comments);
    expect(findCommentsResponse1.error, isNull);
  });

  test('Convert a find comments response to a JSON serializable map and back',
      () {
    final json = findCommentsResponse1.toJson();
    final findCommentsResponse2 = FindCommentsResponse.fromJson(json);
    expect(findCommentsResponse1, equals(findCommentsResponse2));
  });

  final saveShaderCommentsResponse1 = SaveShaderCommentsResponse(error: null);

  test('Test save shader comments response', () {
    expect(saveShaderCommentsResponse1.error, isNull);
  });

  final deleteCommentResponse1 = DeleteCommentResponse(error: null);

  test('Test delete comment response', () {
    expect(deleteCommentResponse1.error, isNull);
  });

  final playlist1 = Playlist(
      id: 'week',
      userId: 'shadertoy',
      name: 'Shaders of the Week',
      description: 'Playlist with every single shader of the week ever.');
  final findPlaylistResponse1 =
      FindPlaylistResponse(playlist: playlist1, error: null);

  test('Test a find playlist response', () {
    expect(findPlaylistResponse1.playlist, playlist1);
    expect(findPlaylistResponse1.error, isNull);
  });

  test('Convert a find playlist response to a JSON serializable map and back',
      () {
    final json = findPlaylistResponse1.toJson();
    final findPlaylistResponse2 = FindPlaylistResponse.fromJson(json);
    expect(findPlaylistResponse1, equals(findPlaylistResponse2));
  });

  final playlistIds = ['week', 'featured'];
  final findPlaylistIdsResponse1 =
      FindPlaylistIdsResponse(ids: playlistIds, error: null);

  test('Test a find playlist ids response', () {
    expect(findPlaylistIdsResponse1.ids, playlistIds);
    expect(findPlaylistIdsResponse1.error, isNull);
  });

  test(
      'Convert a find playlist ids response to a JSON serializable map and back',
      () {
    final json = findPlaylistIdsResponse1.toJson();
    final findPlaylistIdsResponse2 = FindPlaylistIdsResponse.fromJson(json);
    expect(findPlaylistIdsResponse1, equals(findPlaylistIdsResponse2));
  });

  final playlist2 = Playlist(
      id: 'featured',
      userId: 'shadertoy',
      name: 'Featured Shaders',
      description: 'Playlist with every single featured shader ever.');
  final findPlaylistResponse2 =
      FindPlaylistResponse(playlist: playlist2, error: null);
  final findPlaylistsResponse1 = FindPlaylistsResponse(
      playlists: [findPlaylistResponse1, findPlaylistResponse2], error: null);

  test('Test a find playlists response', () {
    expect(findPlaylistsResponse1.playlists,
        [findPlaylistResponse1, findPlaylistResponse2]);
    expect(findPlaylistsResponse1.error, isNull);
  });

  test('Convert a find playlists response to a JSON serializable map and back',
      () {
    final json = findPlaylistsResponse1.toJson();
    final findPlaylistsResponse2 = FindPlaylistsResponse.fromJson(json);
    expect(findPlaylistsResponse1, equals(findPlaylistsResponse2));
  });

  final savePlaylistResponse1 = SavePlaylistResponse(error: null);

  test('Test save playlist response', () {
    expect(savePlaylistResponse1.error, isNull);
  });

  final savePlaylistShadersResponse1 = SavePlaylistShadersResponse(error: null);

  test('Test save playlist shaders response', () {
    expect(savePlaylistShadersResponse1.error, isNull);
  });

  final deletePlaylistResponse1 = DeletePlaylistResponse(error: null);

  test('Test delete playlist response', () {
    expect(deletePlaylistResponse1.error, isNull);
  });

  final bytes = utf8.encode('bytes');
  final donwloadFileResponse1 = DownloadFileResponse(bytes: bytes, error: null);

  test('Test download file response', () {
    expect(donwloadFileResponse1.bytes, bytes);
    expect(donwloadFileResponse1.error, isNull);
  });
}
