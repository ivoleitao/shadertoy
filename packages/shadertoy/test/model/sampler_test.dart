import 'package:shadertoy/src/model/sampler.dart';
import 'package:test/test.dart';

void main() {
  var sampler1 = Sampler(
      filter: FilterType.linear,
      wrap: WrapType.clamp,
      vflip: true,
      srgb: true,
      internal: 'internal1');

  test('Test a sampler', () {
    expect(sampler1.filter, FilterType.linear);
    expect(sampler1.wrap, WrapType.clamp);
    expect(sampler1.vflip, true);
    expect(sampler1.srgb, true);
    expect(sampler1.internal, 'internal1');
  });

  test('Convert a sampler to a JSON serializable map and back', () {
    var json = sampler1.toJson();
    var sampler2 = Sampler.fromJson(json);
    expect(sampler1, equals(sampler2));
  });
}
