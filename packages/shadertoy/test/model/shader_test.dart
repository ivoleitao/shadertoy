import 'package:shadertoy/src/model/info.dart';
import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/output.dart';
import 'package:shadertoy/src/model/render_pass.dart';
import 'package:shadertoy/src/model/sampler.dart';
import 'package:shadertoy/src/model/shader.dart';
import 'package:test/test.dart';

void main() {
  var date = DateTime(2000, 1, 1, 0, 0, 0);
  var info = Info(
      id: 'id1',
      date: date,
      views: 1,
      name: 'name1',
      userId: 'userId1',
      description: 'description1',
      likes: 1,
      privacy: ShaderPrivacy.publicApi,
      flags: 1,
      tags: ['test1'],
      hasLiked: true);
  var sampler = Sampler(
      filter: FilterType.linear,
      wrap: WrapType.clamp,
      vflip: true,
      srgb: true,
      internal: 'internal1');
  var input = Input(
      id: 'id1',
      src: 'src1',
      type: InputType.buffer,
      channel: 1,
      sampler: sampler,
      published: 1);
  var output = Output(id: 'id1', channel: 1);
  var renderPass = RenderPass(
      name: 'name1',
      type: RenderPassType.buffer,
      description: 'description1',
      code: 'code1',
      inputs: [input],
      outputs: [output]);
  var shader1 = Shader(version: '1', info: info, renderPasses: [renderPass]);

  test('Test a shader', () {
    expect(shader1.version, '1');
    expect(shader1.info, info);
    expect(shader1.renderPasses, [renderPass]);
  });

  test('Convert a shader to a JSON serializable map and back', () {
    var json = shader1.toJson();
    var shader2 = Shader.fromJson(json);
    expect(shader1, equals(shader2));
  });
}
