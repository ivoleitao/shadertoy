import 'dart:convert';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findPlaylistById('featured');
  print(result.playlist?.id);
  print(result.playlist?.userId);
  print(result.playlist?.name);
  print(result.playlist?.description);

  print(jsonEncode(result.playlist?.toJson()));
}
