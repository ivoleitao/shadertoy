import 'package:shadertoy/src/context.dart';
import 'package:test/test.dart';

void main() {
  var baseUrl = 'https://www.shadertoy.com';
  var context1 = ShadertoyContext(baseUrl);

  test('Test a context', () {
    expect(context1.baseUrl, baseUrl);
    expect(context1.signInUrl, '$baseUrl/${ShadertoyContext.signInPath}');
    expect(context1.signOutUrl, '$baseUrl/${ShadertoyContext.signOutPath}');
    expect(context1.shaderBrowseUrl, '$baseUrl/${ShadertoyContext.browsePath}');
    expect(context1.getShaderViewPath('MsGczV'),
        '${ShadertoyContext.viewPath}/MsGczV');
    expect(context1.getShaderViewUrl('MsGczV'),
        '$baseUrl/${ShadertoyContext.viewPath}/MsGczV');
    expect(context1.getShaderEmbedPath('MsGczV'),
        '${ShadertoyContext.embedPath}/MsGczV');
    expect(
        context1.getShaderEmbedUrl('MsGczV',
            gui: true, t: 20, paused: true, muted: true),
        '$baseUrl/${ShadertoyContext.embedPath}/MsGczV?gui=true&t=20&paused=true&muted=true');
    expect(context1.getShaderPicturePath('MsGczV'),
        '${ShadertoyContext.shaderMediaPath}/MsGczV.jpg');
    expect(context1.getShaderPictureUrl('MsGczV'),
        '$baseUrl/${ShadertoyContext.shaderMediaPath}/MsGczV.jpg');
  });

  test('Convert a context to a JSON serializable map and back', () {
    var json = context1.toJson();
    var context2 = ShadertoyContext.fromJson(json);
    expect(context1, equals(context2));
  });
}
