import 'package:dotenv/dotenv.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  // Load the .env file
  final env = DotEnv()..load();

  // Fetch the API key from the .env file
  final apiKey = env['API_KEY'];

  // if no api key is found abort
  if (apiKey == null) {
    print('Invalid API key');
    return;
  }

  final client = newShadertoyWSClient(apiKey);
  final result = await client.findAllShaderIds();
  print('${result.total} shader(s)');
}
