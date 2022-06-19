import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:universal_platform/universal_platform.dart';

bool _isWeb() => UniversalPlatform.isWeb;

File _fileFixture(String path) => File('test/fixtures/$path');

Future<Uint8List> binaryFileFixture(String path) =>
    _fileFixture(path).readAsBytes();

Future<Uint8List> binaryHttpFixture(String path) => Dio()
    .get<Uint8List>(Uri.base.resolve('../fixtures/$path').toString(),
        options: Options(responseType: ResponseType.bytes))
    .then((response) => response.data!);

Future<Uint8List> binaryFixture(String path) =>
    _isWeb() ? binaryHttpFixture(path) : binaryFileFixture(path);

Future<Uint8List> shaderIdBinaryFixture(String shaderId) =>
    binaryFixture('media/shaders/$shaderId.jpg');

Future<Uint8List> shaderBinaryFixture(Shader shader) =>
    binaryFixture('media/shaders/${shader.info.id}.jpg');

Future<String> textFileFixture(String path) =>
    _fileFixture(path).readAsString();

Future<String> textHttpFixture(String path) => Dio()
    .get<String>(Uri.base.resolve('../fixtures/$path').toString())
    .then((response) => response.data!);

Future<String> textFixture(String path) =>
    _isWeb() ? textHttpFixture(path) : textFileFixture(path);

Future<dynamic> jsonFixture(String path) =>
    textFixture(path).then((text) => json.decode(text));

Future<Shader> shaderFixture(String path) =>
    jsonFixture(path).then((json) => Shader.fromJson(json));

Future<List<Shader>> shadersFixture(List<String> paths) =>
    Future.wait(paths.map((p) => shaderFixture(p)));

Future<FindShaderResponse> findShaderResponseFixture(String path,
        {ResponseError? error}) =>
    shaderFixture(path)
        .then((shader) => FindShaderResponse(shader: shader, error: error));

Future<List<FindShaderResponse>> findShaderResponseFixtures(
        List<String> paths) =>
    Future.wait(paths.map((p) => findShaderResponseFixture(p)));

Future<FindShadersResponse> findShadersResponseFixture(List<String> paths,
        {ResponseError? error}) =>
    Future.wait(paths.map((p) => findShaderResponseFixture(p)))
        .then((shaders) => FindShadersResponse(shaders: shaders, error: error));

Future<String> shaderIdFixture(String path) =>
    shaderFixture(path).then((shader) => shader.info.id);

Future<FindShaderIdsResponse> findShaderIdsResponseFixture(List<String> paths,
        {int? count, ResponseError? error}) =>
    Future.wait(paths.map((p) => shaderIdFixture(p))).then(
        (ids) => FindShaderIdsResponse(count: count, ids: ids, error: error));

Future<FindShadersRequest> findShadersRequestFixture(List<String> paths) =>
    Future.wait(paths.map((p) => shaderIdFixture(p)))
        .then((ids) => FindShadersRequest(ids.toSet()));

Future<CommentsResponse> commentsResponseFixture(String path) =>
    jsonFixture(path).then((json) => CommentsResponse.from(json));

Future<DownloadFileResponse> downloadFileResponseFixture(String path,
        {ResponseError? error}) =>
    binaryFixture(path)
        .then((bytes) => DownloadFileResponse(bytes: bytes, error: error));
