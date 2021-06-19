import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findAllShaderIds();
  print('${sr.total} shader id(s)');
  sr.ids?.forEach((element) => stdout.write('$element '));
}
