import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/response/error.dart';
import 'package:test/test.dart';

void main() {
  test('Builds a error from a string message and vice-versa', () {
    var converter = ResponseErrorConverter();
    expect(converter.fromJson('message'),
        ResponseError(code: ErrorCode.unknown, message: 'message'));
    expect(
        converter
            .toJson(ResponseError(code: ErrorCode.unknown, message: 'message')),
        'message');
  });
}
