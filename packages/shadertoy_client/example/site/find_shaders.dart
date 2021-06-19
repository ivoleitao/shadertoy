import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findShaders(term: 'elevated');
  print('${sr.total} shader id(s)');
  sr.shaders
      ?.forEach((response) => stdout.write('${response.shader?.info.id} '));
}
