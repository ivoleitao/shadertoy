import 'dart:io';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final response = await client.downloadMedia('/media/users/TDM/profile.jpeg');
  final bytes = response.bytes;
  if (bytes != null) {
    File('.dart_tool/TDM.jpg').writeAsBytesSync(bytes);
  }
}
