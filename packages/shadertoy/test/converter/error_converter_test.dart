import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/response.dart';
import 'package:test/test.dart';

void main() {
  test('Builds a error from a string message and vice-versa', () {
    var converter = ResponseErrorConverter();
    expect(converter.fromJson('message'),
        ResponseError(code: ErrorCode.UNKNOWN, message: 'message'));
    expect(
        converter
            .toJson(ResponseError(code: ErrorCode.UNKNOWN, message: 'message')),
        'message');
  });
}
