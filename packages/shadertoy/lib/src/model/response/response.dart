import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'error.dart';

/// Base API response class
///
/// It should be used as the base class for every API response. It provides support for
/// error aware responses with a field that should be set when there was an error in
/// the API
abstract class APIResponse {
  @JsonKey(name: 'Error')
  @ResponseErrorConverter()

  /// The error
  final ResponseError? error;

  /// Returns `true` if there is not error
  ///
  /// Simply check if [error] is null
  bool get ok {
    return error == null;
  }

  /// Builds an [APIResponse]
  ///
  /// An optional [error] can be provided
  APIResponse({this.error});
}
