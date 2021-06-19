import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/sampler.dart';
import 'package:test/test.dart';

void main() {
  var sampler = Sampler(
      filter: FilterType.linear,
      wrap: WrapType.clamp,
      vflip: true,
      srgb: true,
      internal: 'internal1');
  var input1 = Input(
      id: 'id1',
      src: 'src1',
      filePath: 'filePath1',
      previewFilePath: 'previewFilePath1',
      type: InputType.buffer,
      channel: 1,
      sampler: sampler,
      published: 1);

  test('Test a input', () {
    expect(input1.id, 'id1');
    expect(input1.src, 'src1');
    expect(input1.filePath, 'filePath1');
    expect(input1.previewFilePath, 'previewFilePath1');
    expect(input1.type, InputType.buffer);
    expect(input1.channel, 1);
    expect(input1.sampler, sampler);
    expect(input1.published, 1);
  });

  test('Convert a input to a JSON serializable map and back', () {
    var json = input1.toJson();
    var input2 = Input.fromJson(json);
    expect(input1, equals(input2));
  });

  test('Create a input from a json map', () {
    var json = {
      'id': '20250',
      'src':
          'https://soundcloud.com/giorgioiannelli/yann_tiersen-amelie_piano_version',
      'ctype': 'musicstream',
      'channel': 0,
      'sampler': {
        'filter': 'linear',
        'wrap': 'clamp',
        'vflip': 'true',
        'srgb': 'false',
        'internal': 'byte'
      },
      'published': 0
    };

    expect(() => Input.fromJson(json), returnsNormally);
  });

  test('Create a input from a json map with a invalid type', () {
    var json = {
      'id': '20250',
      'filepath':
          '/media/a/f735bee5b64ef98879dc618b016ecf7939a5756040c2cde21ccb15e69a6e1cfb.png',
      'previewfilepath':
          '/media/ap/f735bee5b64ef98879dc618b016ecf7939a5756040c2cde21ccb15e69a6e1cfb.png',
      'ctype': 'xxx',
      'channel': 0,
      'sampler': {
        'filter': 'linear',
        'wrap': 'clamp',
        'vflip': 'true',
        'srgb': 'false',
        'internal': 'byte'
      },
      'published': 0
    };

    expect(() => Input.fromJson(json), throwsArgumentError);
  });
}
