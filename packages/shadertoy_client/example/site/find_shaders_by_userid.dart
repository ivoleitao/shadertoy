import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findShadersByUserId('iq');
  print('${result.total} shader id(s)');
  result.shaders
      ?.forEach((shader) => stdout.write('${shader.shader?.info.id} '));
}
