/// The regex used to extract from a filename triplets
/// of digits of later conversion to a letter
final RegExp codePairsRegExp = RegExp(r'\d{3}');

/// Converts a shaderId to a filename suitable for case sensitive OS's
///
/// * [shaderId]: The id of the shader
///
/// Returns a filename through the conversion of a shaderId letter by letter to the equivalent
/// String but where each letter is represented ascii code padded til 3 with '0's
String shaderIdToFileName(String shaderId) {
  return shaderId.runes.fold(
      '',
      (previousValue, element) =>
          previousValue + element.toString().padLeft(3, '0'));
}

/// Convertes a filename to a shader id
///
/// * [fileName]: The name of the file
///
/// Returns a shader id from a filename through the conversion of each ascii code
/// to the respectve letter. Each ascii code is extracted from a 3 digit number
/// so the number or digits in filename should be actually a multiple of 3
String fileNameToShaderId(String fileName) {
  return String.fromCharCodes(
      codePairsRegExp.allMatches(fileName).map((m) => int.parse(m.group(0)!)));
}
