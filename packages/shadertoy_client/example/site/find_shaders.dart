import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findShaders(term: 'elevated');
  print('${result.total} shader id(s)');
  for (var response in result.shaders ?? <FindShaderResponse>[]) {
    print(response.shader?.info.id);
  }
}
