import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findShadersByUserId('iq');
  print('${sr.total} shader id(s)');
  sr.shaders?.forEach((shader) => stdout.write('${shader.shader?.info.id} '));
}
