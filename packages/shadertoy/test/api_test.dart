import 'package:shadertoy/src/api.dart';
import 'package:shadertoy/src/model/response/find_shader.dart';
import 'package:shadertoy/src/model/response/find_shader_ids.dart';
import 'package:shadertoy/src/model/response/find_shaders.dart';
import 'package:test/test.dart';

class ShadertoyTestClient extends ShadertoyBaseClient {
  ShadertoyTestClient(String baseUrl) : super(baseUrl);

  @override
  Future<FindShaderIdsResponse> findAllShaderIds() {
    throw UnimplementedError();
  }

  @override
  Future<FindShaderResponse> findShaderById(String shaderId) {
    throw UnimplementedError();
  }

  @override
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    throw UnimplementedError();
  }

  @override
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    throw UnimplementedError();
  }

  @override
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds) {
    throw UnimplementedError();
  }
}

void main() {
  final baseUrl = 'https://www.test.com';
  final client = ShadertoyTestClient(baseUrl);

  test('Test a client', () {
    expect(client.context, isNotNull);
    expect(client.context.baseUrl, baseUrl);
  });
}
