import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final response = await client.downloadShaderPicture('3lsSzf');
  final bytes = response.bytes;
  if (bytes != null) {
    File('.dart_tool/3lsSzf.jpg').writeAsBytesSync(bytes);
  }
}
