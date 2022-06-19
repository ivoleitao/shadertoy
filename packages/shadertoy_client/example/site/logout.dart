import 'package:dotenv/dotenv.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  // Load the .env file
  final env = DotEnv()..load();

  // Fetch the user from the .env file
  final user = env['USER'];

  // if no user is found abort
  if (user == null) {
    print('Invalid user');
    return;
  }

  // Fetch the password from the .env file
  final password = env['PASSWORD'];

  // if no password is found abort
  if (password == null) {
    print('Invalid password');
    return;
  }

  final site = newShadertoySiteClient(user: user, password: password);

  var loggedIn = await site.loggedIn;
  print('Logged In: $loggedIn');
  var sr = await site.findShaderById('3lsSzf');
  print(sr.shader?.info.id);
  print('\tName: ${sr.shader?.info.name}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');

  await site.login();
  loggedIn = await site.loggedIn;

  print('Logged In: $loggedIn');
  sr = await site.findShaderById('3lsSzf');
  print(sr.shader?.info.id);
  print('\tName: ${sr.shader?.info.name}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');

  await site.logout();

  loggedIn = await site.loggedIn;
  print('Logged In: $loggedIn');
  sr = await site.findShaderById('3lsSzf');
  print(sr.shader?.info.id);
  print('\tName: ${sr.shader?.info.name}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');
}
