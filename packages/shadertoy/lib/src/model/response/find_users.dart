import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'error.dart';
import 'find_user.dart';
import 'response.dart';

part 'find_users.g.dart';

@JsonSerializable()

/// Find users API response
///
/// The response returned upon the execution of a find users API call
/// When [FindUsersResponse.error] is *not null* there was an error in the find users call
/// When [FindUsersResponse.error] is *null* the [FindUsersResponse.users] has the returned users
class FindUsersResponse extends APIResponse {
  @JsonKey(name: 'Users')

  /// The total number of users
  final int total;

  @JsonKey(name: 'Results')

  /// The list of the users returned
  final List<FindUserResponse>? users;

  /// Builds a [FindUsersResponse]
  ///
  /// [total]: The total number of users returned
  /// [users]: The list of users
  /// [error]: An error if there was error while fetching the shaders
  FindUsersResponse({int? total, this.users, ResponseError? error})
      : total = total ?? users?.length ?? 0,
        super(error: error);

  /// Creates a [FindUsersResponse] from json map
  factory FindUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUsersResponseFromJson(json);

  /// Creates a json map from a [FindUsersResponse]
  Map<String, dynamic> toJson() => _$FindUsersResponseToJson(this);
}
