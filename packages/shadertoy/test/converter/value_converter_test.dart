import 'package:shadertoy/src/converter/value_converter.dart';
import 'package:test/test.dart';

void main() {
  test('Converts 0 to false and 1 to true and vice-versa', () {
    var converter = IntToBoolConverter();
    expect(converter.fromJson(0), false);
    expect(converter.toJson(false), 0);
    expect(converter.fromJson(1), true);
    expect(converter.toJson(true), 1);
  });

  test('Converts \"false\" to false and \"true\" to true and vice-versa', () {
    var converter = StringToBoolConverter();
    expect(converter.fromJson('false'), false);
    expect(converter.toJson(false), 'false');
    expect(converter.fromJson('true'), true);
    expect(converter.toJson(true), 'true');
  });
}
