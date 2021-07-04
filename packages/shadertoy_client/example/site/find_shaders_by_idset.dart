import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final shaders = {'ldcyW4', '3tfGWl', 'lsKSRz', 'MtsXzl', 'MsBXWy'};

  final client = newShadertoySiteClient();
  final result = await client.findShadersByIdSet(shaders);
  print('${result.total} shader(s)');
}
