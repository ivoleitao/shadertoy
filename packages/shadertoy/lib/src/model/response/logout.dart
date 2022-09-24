import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'error.dart';
import 'response.dart';

part 'logout.g.dart';

@JsonSerializable()

/// Logout API response
///
/// The response returned upon the execution of a logout in the Shadertoy website
/// When [LogoutResponse.error] is *not null* there was an error in the logout process
/// When [LogoutResponse.error] is *null* the logout was sucessfull
class LogoutResponse extends APIResponse {
  /// Builds an [LogoutResponse]
  ///
  /// An optional [error] can be provided
  LogoutResponse({ResponseError? error}) : super(error: error);

  /// Creates a [LogoutResponse] from json map
  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);

  /// Creates a json map from a [LogoutResponse]
  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}
