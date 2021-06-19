import 'package:shadertoy/src/context.dart';
import 'package:test/test.dart';

void main() {
  var BaseUrl = 'https://www.shadertoy.com';
  var context1 = ShadertoyContext(BaseUrl);

  test('Test a context', () {
    expect(context1.baseUrl, BaseUrl);
    expect(context1.signInUrl, '$BaseUrl/${ShadertoyContext.SignInPath}');
    expect(context1.signOutUrl, '$BaseUrl/${ShadertoyContext.SignOutPath}');
    expect(context1.shaderBrowseUrl, '$BaseUrl/${ShadertoyContext.BrowsePath}');
    expect(context1.getShaderViewPath('MsGczV'),
        '${ShadertoyContext.ViewPath}/MsGczV');
    expect(context1.getShaderViewUrl('MsGczV'),
        '$BaseUrl/${ShadertoyContext.ViewPath}/MsGczV');
    expect(context1.getShaderEmbedPath('MsGczV'),
        '${ShadertoyContext.EmbedPath}/MsGczV');
    expect(
        context1.getShaderEmbedUrl('MsGczV',
            gui: true, t: 20, paused: true, muted: true),
        '$BaseUrl/${ShadertoyContext.EmbedPath}/MsGczV?gui=true&t=20&paused=true&muted=true');
    expect(context1.getShaderPicturePath('MsGczV'),
        '${ShadertoyContext.ShaderMediaPath}/MsGczV.jpg');
    expect(context1.getShaderPictureUrl('MsGczV'),
        '$BaseUrl/${ShadertoyContext.ShaderMediaPath}/MsGczV.jpg');
  });

  test('Convert a context to a JSON serializable map and back', () {
    var json = context1.toJson();
    var context2 = ShadertoyContext.fromJson(json);
    expect(context1, equals(context2));
  });
}
