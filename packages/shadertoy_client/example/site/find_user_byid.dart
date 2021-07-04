import 'dart:convert';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findUserById('shaderflix');
  print('Name: ${result.user?.id}');
  print('Picture: ${result.user?.picture}');
  print('Joined: ${result.user?.memberSince}');
  print('Following: ${result.user?.following}');
  print('Followers: ${result.user?.followers}');
  print('About:');
  print('${result.user?.about}');

  print(jsonEncode(result.user?.toJson()));
}
