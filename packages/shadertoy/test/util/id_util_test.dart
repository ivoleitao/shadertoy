import 'package:shadertoy/src/util/id_util.dart';
import 'package:test/test.dart';

void main() {
  test(
      'A shader filename is built with the ascii equivalents of each letter / number padded with x3 with 0 to the left',
      () {
    var shaderId = 'WtfGWn';
    expect(shaderIdToFileName(shaderId), '087116102071087110');
  });

  test('A shader id is built from the shader filename', () {
    var shaderFilename = '087116102071087110';
    var shaderId = 'WtfGWn';
    expect(fileNameToShaderId(shaderFilename), equals(shaderId));
  });
}
