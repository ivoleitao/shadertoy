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

  final client = newShadertoyHybridClient(apiKey: apiKey);

  final result = await client.findShaderById('3lsSzf');
  print(result.shader?.info.id);
  print('\tName: ${result.shader?.info.name}');
}
