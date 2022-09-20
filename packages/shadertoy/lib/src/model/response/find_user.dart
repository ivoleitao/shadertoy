import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/user.dart';

import 'error.dart';
import 'response.dart';

part 'find_user.g.dart';

@JsonSerializable()

/// Find user API response
///
/// The response returned upon the execution of a find user API call
/// When [FindUserResponse.error] is *not null* there was an error in the find user call
/// When [FindUserResponse.error] is *null* the [FindUserResponse.user] has the returned user
class FindUserResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'User')

  /// The user returned, null when there is an error
  final User? user;

  @override
  List get props {
    return [user, error];
  }

  /// Builds a [FindUserResponse]
  ///
  /// [user]: The user
  /// [error]: An error if there was error while fetching the user
  FindUserResponse({this.user, ResponseError? error}) : super(error: error);

  /// Creates a [FindUserResponse] from json map
  factory FindUserResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUserResponseFromJson(json);

  /// Creates a json map from a [FindUserResponse]
  Map<String, dynamic> toJson() => _$FindUserResponseToJson(this);
}
