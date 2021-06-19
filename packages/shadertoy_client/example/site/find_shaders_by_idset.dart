import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final shaders = {'ldcyW4', '3tfGWl', 'lsKSRz', 'MtsXzl', 'MsBXWy'};

  final site = newShadertoySiteClient();
  final result = await site.findShadersByIdSet(shaders);
  print('${result.total} shader(s)');
}
