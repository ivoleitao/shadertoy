import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findShaderIds();
  print('${sr.total} shader(s)');
}
