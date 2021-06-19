import 'package:shadertoy_client/shadertoy_client.dart';

import '../env.dart';

void main(List<String> arguments) async {
  // If the api key is not specified in the arguments, try the environment one
  var apiKey = arguments.isEmpty ? Env.apiKey : arguments[0];

  // if no api key is found abort
  if (apiKey.isEmpty) {
    print('Invalid API key');
    return;
  }

  var hybrid = newShadertoyHybridClient(apiKey: apiKey);

  final sr = await hybrid.findShaderById('3lsSzf');
  print('${sr.shader?.info.id}');
  print('\tName: ${sr.shader?.info.name}');
}
