import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/user.dart';

import 'response.dart';

part 'find_user.g.dart';

@JsonSerializable()

/// Find user API response
///
/// The response returned upon the execution of a find user API call
/// When [FindUserResponse.fail] is *not null* there was an error in the find user call
/// When [FindUserResponse.fail] is *null* the [FindUserResponse.user] has the returned user
class FindUserResponse extends APIResponse {
  @JsonKey(name: 'User')

  /// The user returned, null when there is an error
  final User? user;

  /// Builds a [FindUserResponse]
  ///
  /// [user]: The user
  /// [error]: An error if there was error while fetching the user
  FindUserResponse({this.user, super.error});

  @override
  List<Object?> get props {
    return [...super.props, user];
  }

  /// Creates a [FindUserResponse] from json map
  factory FindUserResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUserResponseFromJson(json);

  /// Creates a json map from a [FindUserResponse]
  Map<String, dynamic> toJson() => _$FindUserResponseToJson(this);
}
