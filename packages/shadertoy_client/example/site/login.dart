import 'package:shadertoy_client/shadertoy_client.dart';

import '../env.dart';

void main(List<String> arguments) async {
  // If the user is not specified in the arguments, try the environment one
  var user = arguments.isEmpty ? Env.user : arguments[0];

  // if no user is found abort
  if (user.isEmpty) {
    print('Invalid user');
    return;
  }

  // If the password is not specified in the arguments, try the environment one
  var password = arguments.isEmpty ? Env.password : arguments[0];

  // if no password is found abort
  if (password.isEmpty) {
    print('Invalid password');
    return;
  }

  final site = newShadertoySiteClient(user: user, password: password);
  var loggedIn = await site.loggedIn;

  print('Logged In: $loggedIn');
  var sr = await site.findShaderById('3lsSzf');
  print('${sr.shader?.info.id}');
  print('\tName: ${sr.shader?.info.name}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');

  await site.login();

  loggedIn = await site.loggedIn;

  print('Logged In: $loggedIn');
  sr = await site.findShaderById('3lsSzf');
  print('${sr.shader?.info.id}');
  print('\tName: ${sr.shader?.info.name}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');
}
