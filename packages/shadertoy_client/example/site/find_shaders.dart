import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findShaders(term: 'elevated');
  print('${result.total} shader id(s)');
  result.shaders
      ?.forEach((response) => stdout.write('${response.shader?.info.id} '));
}
