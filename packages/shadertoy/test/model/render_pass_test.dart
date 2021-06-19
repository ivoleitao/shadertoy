import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/output.dart';
import 'package:shadertoy/src/model/render_pass.dart';
import 'package:shadertoy/src/model/sampler.dart';
import 'package:test/test.dart';

void main() {
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
  var renderPass1 = RenderPass(
      name: 'name1',
      type: RenderPassType.buffer,
      description: 'description1',
      code: 'code1',
      inputs: [input],
      outputs: [output]);

  test('Test a render pass', () {
    expect(renderPass1.name, 'name1');
    expect(renderPass1.type, RenderPassType.buffer);
    expect(renderPass1.description, 'description1');
    expect(renderPass1.code, 'code1');
    expect(renderPass1.inputs, [input]);
    expect(renderPass1.outputs, [output]);
  });

  test('Convert a render pass to a JSON serializable map and back', () {
    var json = renderPass1.toJson();
    var renderPass2 = RenderPass.fromJson(json);
    expect(renderPass1, equals(renderPass2));
  });

  test('Create a render pass from a json map', () {
    var json = {
      'name': 'Image',
      'type': 'image',
      'description': '',
      'code':
          '#define PI 3.14159265359\n#define HALF_PI 1.57079632675\n#define TWO_PI 6.283185307\n\n#define SECONDS 6.0\n#define COUNT 32\n\nvec2 random2(vec2 st)\n{\n    st = vec2( dot(st,vec2(127.1,311.7)),\n              dot(st,vec2(29.5,183.3)) );\n    return -1.0 + 2.0*fract(sin(st)*43758.5453123);\n}\n\nfloat random(vec2 st)\n{\n    return fract(sin(dot(st.yx,vec2(14.7891,43.123)))*312991.41235);\n}\n\nfloat random (in float x)\n{\n    return fract(sin(x)*43758.5453123);\n}\n\n// iq\nfloat v_noise(vec2 st) {\n    vec2 i = floor(st);\n    vec2 f = fract(st);\n\n    vec2 u = f*f*(3.0-2.0*f);\n\n    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),\n                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),\n                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),\n                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);\n}\n\nmat2 rotate(float angle)\n{\n    return mat2( cos(angle),-sin(angle),sin(angle),cos(angle) );\n}\n\nvec2 ratio(vec2 st)\n{\n    return  vec2(\n            max(st.x/st.y,1.0),\n            max(st.y/st.x,1.0)\n            );\n}\n\nvec2 center(vec2 st)\n{\n    float aspect = iResolution.x/iResolution.y;\n    st.x = st.x * aspect - aspect * 0.5 + 0.5;\n    return st;\n}\n\nvec3 time()\n{\n    float period = mod(iTime,SECONDS);\n    vec3 t = vec3(fract(iTime/SECONDS),period, 1.0-fract(period));\n    return t;       // return fract(length),period,period phase\n}\n\nfloat scene(vec2 st, vec3 t)\n{\n    st = st * 2.0 - 1.0;\n\n    float seed = 29192.173;\n    float center = length(st-0.5) - 0.5;\n\n    float n_scale = 0.12;\n\n    float n_1 = v_noise(st + sin(PI*t.x)) * n_scale;\n    float n_2 = v_noise(st+seed - sin(PI*t.x)) * n_scale;\n\n    float d = 1.0;\n    for(int i = 1; i <= COUNT; i++)\n    {\n        float spread = 1.0 / float(i);\n        float speed = ceil(3.0*spread);\n        float r = random(float(i)*5.0 + seed);\n        float r_scalar = r * 2.0 - 1.0;\n\n        vec2 pos = st - vec2(0.0);\n            pos += vec2(0.01) * rotate(TWO_PI * r_scalar + TWO_PI * t.x * speed * sign(r_scalar));\n            pos *= rotate(TWO_PI * r_scalar + TWO_PI * t.x * speed * sign(r_scalar) + v_noise(pos + float(i) + iTime) );\n            pos += mix(n_1,n_2,0.5+0.5*sin(TWO_PI*t.x*speed));\n\n        float s = .45 + .126 * r;\n\n        float a = atan(pos.y,pos.x)/PI;\n            a = abs(a);\n            a = smoothstep(0.0,1.0,a);\n\n        float c = length(pos);\n            c = abs(c-s);\n            c -= 0.0004 + .0125 * a;\n\n        d = min(d,c);\n    }\n\n    return d;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    // timing\n    vec3 t = time();\n\n    // space\n    vec2 st = fragCoord/iResolution.xy;\n    st = center( st );\n\n    st = st * 2.0 - 1.0;\n    st = st * (1.0 + .03 * sin(TWO_PI*t.x));\n    st = st * 0.5 + 0.5;\n\n    // scene\n    float s = scene(st, t);\n\n    // aa\n    float pixelSmoothing = 2.0;\n    float aa = ratio(iResolution.xy).x/iResolution.x*pixelSmoothing;\n    \n    // color\n    vec3 color = vec3(0.08);\n        color = mix(color,vec3(1.0),1.0-smoothstep(-aa,aa,s));\n        color = 1.0 - color;\n\n    // vignette\n    float size = length(st-.5)-1.33;\n    float vignette = (size) * 0.75 + random(st) *.08;        \n    color = mix(color,vec3(0.0, 0.0, 0.0),vignette+.5);\n\t\n    float d = v_noise(st*7.0+iTime*0.25);\n    \n    fragColor = vec4(color,mix(.25,.25+.75*d,1.0-smoothstep(-aa,aa,s)));\n}\n\n/** SHADERDATA\n{\n\t\"title\": \"Enso or Arrival\",\n\t\"description\": \"A play on Enso, let’s be a little uninhibited and free for just a moment\",\n\t\"model\": \"person\"\n}\n*/',
      'inputs': [],
      'outputs': [
        {'id': '37', 'channel': 0}
      ]
    };

    expect(() => RenderPass.fromJson(json), returnsNormally);
  });

  test('Create a render pass from a json map with a invalid type', () {
    var json = {
      'name': 'Image',
      'type': 'xxx',
      'description': '',
      'code':
          '#define PI 3.14159265359\n#define HALF_PI 1.57079632675\n#define TWO_PI 6.283185307\n\n#define SECONDS 6.0\n#define COUNT 32\n\nvec2 random2(vec2 st)\n{\n    st = vec2( dot(st,vec2(127.1,311.7)),\n              dot(st,vec2(29.5,183.3)) );\n    return -1.0 + 2.0*fract(sin(st)*43758.5453123);\n}\n\nfloat random(vec2 st)\n{\n    return fract(sin(dot(st.yx,vec2(14.7891,43.123)))*312991.41235);\n}\n\nfloat random (in float x)\n{\n    return fract(sin(x)*43758.5453123);\n}\n\n// iq\nfloat v_noise(vec2 st) {\n    vec2 i = floor(st);\n    vec2 f = fract(st);\n\n    vec2 u = f*f*(3.0-2.0*f);\n\n    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),\n                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),\n                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),\n                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);\n}\n\nmat2 rotate(float angle)\n{\n    return mat2( cos(angle),-sin(angle),sin(angle),cos(angle) );\n}\n\nvec2 ratio(vec2 st)\n{\n    return  vec2(\n            max(st.x/st.y,1.0),\n            max(st.y/st.x,1.0)\n            );\n}\n\nvec2 center(vec2 st)\n{\n    float aspect = iResolution.x/iResolution.y;\n    st.x = st.x * aspect - aspect * 0.5 + 0.5;\n    return st;\n}\n\nvec3 time()\n{\n    float period = mod(iTime,SECONDS);\n    vec3 t = vec3(fract(iTime/SECONDS),period, 1.0-fract(period));\n    return t;       // return fract(length),period,period phase\n}\n\nfloat scene(vec2 st, vec3 t)\n{\n    st = st * 2.0 - 1.0;\n\n    float seed = 29192.173;\n    float center = length(st-0.5) - 0.5;\n\n    float n_scale = 0.12;\n\n    float n_1 = v_noise(st + sin(PI*t.x)) * n_scale;\n    float n_2 = v_noise(st+seed - sin(PI*t.x)) * n_scale;\n\n    float d = 1.0;\n    for(int i = 1; i <= COUNT; i++)\n    {\n        float spread = 1.0 / float(i);\n        float speed = ceil(3.0*spread);\n        float r = random(float(i)*5.0 + seed);\n        float r_scalar = r * 2.0 - 1.0;\n\n        vec2 pos = st - vec2(0.0);\n            pos += vec2(0.01) * rotate(TWO_PI * r_scalar + TWO_PI * t.x * speed * sign(r_scalar));\n            pos *= rotate(TWO_PI * r_scalar + TWO_PI * t.x * speed * sign(r_scalar) + v_noise(pos + float(i) + iTime) );\n            pos += mix(n_1,n_2,0.5+0.5*sin(TWO_PI*t.x*speed));\n\n        float s = .45 + .126 * r;\n\n        float a = atan(pos.y,pos.x)/PI;\n            a = abs(a);\n            a = smoothstep(0.0,1.0,a);\n\n        float c = length(pos);\n            c = abs(c-s);\n            c -= 0.0004 + .0125 * a;\n\n        d = min(d,c);\n    }\n\n    return d;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    // timing\n    vec3 t = time();\n\n    // space\n    vec2 st = fragCoord/iResolution.xy;\n    st = center( st );\n\n    st = st * 2.0 - 1.0;\n    st = st * (1.0 + .03 * sin(TWO_PI*t.x));\n    st = st * 0.5 + 0.5;\n\n    // scene\n    float s = scene(st, t);\n\n    // aa\n    float pixelSmoothing = 2.0;\n    float aa = ratio(iResolution.xy).x/iResolution.x*pixelSmoothing;\n    \n    // color\n    vec3 color = vec3(0.08);\n        color = mix(color,vec3(1.0),1.0-smoothstep(-aa,aa,s));\n        color = 1.0 - color;\n\n    // vignette\n    float size = length(st-.5)-1.33;\n    float vignette = (size) * 0.75 + random(st) *.08;        \n    color = mix(color,vec3(0.0, 0.0, 0.0),vignette+.5);\n\t\n    float d = v_noise(st*7.0+iTime*0.25);\n    \n    fragColor = vec4(color,mix(.25,.25+.75*d,1.0-smoothstep(-aa,aa,s)));\n}\n\n/** SHADERDATA\n{\n\t\"title\": \"Enso or Arrival\",\n\t\"description\": \"A play on Enso, let’s be a little uninhibited and free for just a moment\",\n\t\"model\": \"person\"\n}\n*/',
      'inputs': [],
      'outputs': [
        {'id': '37', 'channel': 0}
      ]
    };

    expect(() => RenderPass.fromJson(json), throwsArgumentError);
  });
}
