import 'package:dotenv/dotenv.dart' show load, env;
import 'package:enum_to_string/enum_to_string.dart';
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

  final client = newShadertoyWSClient(apiKey);
  final result = await client.findShaderById('WltXD8');
  print(result.shader?.info.id);
  print('\tName: ${result.shader?.info.name}');
  print('\tUserName: ${result.shader?.info.userId}');
  print('\tDate: ${result.shader?.info.date}');
  print('\tDescription: ${result.shader?.info.description}');
  print('\tViews: ${result.shader?.info.views}');
  print('\tLikes: ${result.shader?.info.likes}');
  print(
      '\tPublish Status: ${EnumToString.convertToString(result.shader?.info.privacy)}');
  print('\tTags: ${result.shader?.info.tags.join(',')}');
  print('\tFlags: ${result.shader?.info.flags}');
  print('\tLiked: ${result.shader?.info.hasLiked}');
  print('\tRender Passes: ${result.shader?.renderPasses.length}');
  for (var element in result.shader?.renderPasses ?? []) {
    print(
        '\t\t${element.name} has ${element.inputs.length} input(s) and ${element.outputs.length} output(s)');
  }
}
