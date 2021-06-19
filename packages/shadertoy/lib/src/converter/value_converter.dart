import 'package:json_annotation/json_annotation.dart';

/// Converts int to boolean
///
/// Converts a 0 to false and 1 to true and vice-versa
class IntToBoolConverter implements JsonConverter<bool, int> {
  /// Builds a [IntToBoolConverter]
  const IntToBoolConverter();

  @override

  /// Converts a int to a boolean
  ///
  /// * 0: returns false
  /// * 1: return true
  bool fromJson(int json) {
    return json == 1;
  }

  @override

  /// Converts a boolean to a int
  ///
  /// * false: returns 0
  /// * true: return 1
  int toJson(bool object) {
    return object ? 1 : 0;
  }
}

/// Converts String to boolean
///
/// Converts 'false' to false and 'true' to true and vice-versa
class StringToBoolConverter implements JsonConverter<bool, String> {
  /// Builds a [StringToBoolConverter]
  const StringToBoolConverter();

  @override

  /// Converts a String to a boolean
  ///
  /// * 'false': returns false
  /// * 'true': return true
  bool fromJson(String json) {
    return json == 'true';
  }

  @override

  /// Converts a boolean to a String
  ///
  /// * false: returns 'false'
  /// * true: return 'true'
  String toJson(bool object) {
    return object ? 'true' : 'false';
  }
}
