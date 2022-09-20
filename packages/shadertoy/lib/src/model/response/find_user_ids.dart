import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'error.dart';
import 'response.dart';

part 'find_user_ids.g.dart';

@JsonSerializable()

/// Find user ids API response
///
/// The response returned upon the execution of a find user ids API call
/// When [FindUserIdsResponse.error] is *not null* there was an error in the find user ids call
/// When [FindUserIdsResponse.error] is *null* the [FindUserIdsResponse.ids] has the returned use ids
class FindUserIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Users')

  /// The total number of user ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of user ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindUserIdsResponse]
  ///
  /// [total]: The total number of user ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the shader ids
  FindUserIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindUserIdsResponse] from json map
  factory FindUserIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUserIdsResponseFromJson(json);

  /// Creates a json map from a [FindUserIdsResponse]
  Map<String, dynamic> toJson() => _$FindUserIdsResponseToJson(this);
}
