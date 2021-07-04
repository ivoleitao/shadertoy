import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  final result = await client.findShaderIdsByUserId('iq');
  print('${result.total} shader(s)');
  print('${result.ids}');
}
