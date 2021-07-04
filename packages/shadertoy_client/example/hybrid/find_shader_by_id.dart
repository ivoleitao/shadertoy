import 'package:dotenv/dotenv.dart' show load, env;
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  // Load the .env file
  load();

  // Fetch the API key from the .env file
  final apiKey = env['API_KEY'];

  // if no api key is found abort
  if (apiKey == null) {
    print('Invalid API key');
    return;
  }

  var hybrid = newShadertoyHybridClient(apiKey: apiKey);

  final sr = await hybrid.findShaderById('3lsSzf');
  print(sr.shader?.info.id);
  print('\tName: ${sr.shader?.info.name}');
}
