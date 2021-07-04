import 'package:enum_to_string/enum_to_string.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

void main(List<String> arguments) async {
  final client = newShadertoySiteClient();

  // Gets the shader by id
  final shaderId = '3lsSzf';
  final sr = await client.findShaderById(shaderId);
  if (sr.ok) {
    // If there is no error print the shader contents
    print(sr.shader?.info.id);
    print('\tName: ${sr.shader?.info.name}');
    print('\tUserName: ${sr.shader?.info.userId}');
    print('\tDate: ${sr.shader?.info.date}');
    print('\tDescription: ${sr.shader?.info.description}');
    print('\tViews: ${sr.shader?.info.views}');
    print('\tLikes: ${sr.shader?.info.likes}');
    print(
        '\tPrivacy: ${EnumToString.convertToString(sr.shader?.info.privacy)}');
    print('\tTags: ${sr.shader?.info.tags.join(',')}');
    print('\tFlags: ${sr.shader?.info.flags}');
    print('\tLiked: ${sr.shader?.info.hasLiked}');
    print('\tRender Passes: ${sr.shader?.renderPasses.length}');
    for (var element in sr.shader?.renderPasses ?? []) {
      print(
          '\t\t${element.name} has ${element.inputs.length} input(s) and ${element.outputs.length} output(s)');
    }
  } else {
    // In case of error print the error message
    print('Error retrieving the shader: ${sr.error?.message}');
  }

  // Gets the first 5 comments for this shader
  final sc = await client.findCommentsByShaderId(shaderId);
  if (sc.ok) {
    // If there is no error print the shader comments
    sc.comments?.take(5).forEach((c) => print('${c.userId}: ${c.text}'));
  } else {
    // In case of error print the error message
    print('Error retrieving shader $shaderId comments: ${sr.error?.message}');
  }
}
