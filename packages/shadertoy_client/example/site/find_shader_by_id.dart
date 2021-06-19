import 'package:enum_to_string/enum_to_string.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final site = newShadertoySiteClient();

  final sr = await site.findShaderById('Mt3XW8');
  print('${sr.shader?.info.id}');
  print('\tName: ${sr.shader?.info.name}');
  print('\tUserName: ${sr.shader?.info.userId}');
  print('\tDate: ${sr.shader?.info.date}');
  print('\tDescription: ${sr.shader?.info.description}');
  print('\tViews: ${sr.shader?.info.views}');
  print('\tLikes: ${sr.shader?.info.likes}');
  print('\tPrivacy: ${EnumToString.convertToString(sr.shader?.info.privacy)}');
  print('\tTags: ${sr.shader?.info.tags.join(',')}');
  print('\tFlags: ${sr.shader?.info.flags}');
  print('\tLiked: ${sr.shader?.info.hasLiked}');
  print('\tRender Passes: ${sr.shader?.renderPasses.length}');
  sr.shader?.renderPasses.forEach((element) => print(
      '\t\t${element.name} has ${element.inputs.length} input(s) and ${element.outputs.length} output(s)'));
}
