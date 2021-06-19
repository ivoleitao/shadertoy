import 'package:shadertoy/src/converter/epoch_converter.dart';
import 'package:test/test.dart';

void main() {
  test('Convert a String in seconds to an epoch and back', () {
    var converter = StringEpochInSecondsConverter();
    var value = 123123123;
    expect(converter.fromJson(value.toString()),
        DateTime.fromMillisecondsSinceEpoch(value * 1000));
    expect(converter.toJson(DateTime.fromMillisecondsSinceEpoch(value * 1000)),
        value.toString());
  });
}
