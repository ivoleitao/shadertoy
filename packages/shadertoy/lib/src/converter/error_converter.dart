import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/response/error.dart';

/// Converts back and forth from string to a [ResponseError]
class ResponseErrorConverter implements JsonConverter<ResponseError?, String?> {
  /// Builds a [ResponseErrorConverter]
  const ResponseErrorConverter();

  @override

  /// Converts from a string to a [ResponseError] with that string as the [ResponseError.message]
  ResponseError? fromJson(String? json) {
    return json != null ? ResponseError.unknown(message: json) : null;
  }

  @override

  /// Connverts from a [ResponseError] to a string retriving it from [ResponseError.message]
  String? toJson(ResponseError? object) {
    return object?.message;
  }
}
