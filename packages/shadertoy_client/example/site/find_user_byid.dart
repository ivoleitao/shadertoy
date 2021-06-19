import 'dart:convert';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final response = await site.findUserById('shaderflix');
  print('Name: ${response.user?.id}');
  print('Picture: ${response.user?.picture}');
  print('Joined: ${response.user?.memberSince}');
  print('Following: ${response.user?.following}');
  print('Followers: ${response.user?.followers}');
  print('About:');
  print('${response.user?.about}');

  print(jsonEncode(response.user?.toJson()));
}
