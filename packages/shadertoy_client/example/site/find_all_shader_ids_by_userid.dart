import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findAllShaderIdsByUserId('iq');
  print('${sr.total} shader(s)');
  print('${sr.ids}');
}
