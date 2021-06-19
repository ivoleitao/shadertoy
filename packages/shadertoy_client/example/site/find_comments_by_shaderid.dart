import 'dart:convert';

import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final r1 = await site.findCommentsByShaderId('MdX3Rr');
  print('1-${r1.total} comment(s)');
  print(jsonEncode(r1.comments));
  final r2 = await site.findCommentsByShaderId('XdyyDd');
  print('2-${r2.total} comment(s)');
  final r3 = await site.findCommentsByShaderId('4scBRs');
  print('3-${r3.total} comment(s)');
}
