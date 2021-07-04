import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findAllShaderIds();
  print('${result.total} shader id(s)');
  for (var element in result.ids ?? []) {
    stdout.write('$element ');
  }
}
