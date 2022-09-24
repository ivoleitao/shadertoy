import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'login.g.dart';

@JsonSerializable()

/// Login API response
///
/// The response returned upon the execution of a login in the Shadertoy website
/// When [LoginResponse.error] is *not null* there was an error in the login process
/// When [LoginResponse.error] is *null* the login was sucessfull
class LoginResponse extends APIResponse {
  /// Builds an [LoginResponse]
  ///
  /// An optional [error] can be provided
  LoginResponse({super.error});

  /// Creates a [LoginResponse] from json map
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Creates a json map from a [LoginResponse]
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
