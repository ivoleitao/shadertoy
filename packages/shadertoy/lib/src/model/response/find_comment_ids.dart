import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'error.dart';
import 'response.dart';

part 'find_comment_ids.g.dart';

@JsonSerializable()

/// Find comment ids API response
///
/// The response returned upon the execution of a find comment ids API call
/// When [FindCommentIdsResponse.error] is *not null* there was an error in the find comment ids call
/// When [FindCommentIdsResponse.error] is *null* the [FindCommentIdsResponse.ids] has the returned comment ids
class FindCommentIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Comments')

  /// The total number of comment ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of comment ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindCommentIdsResponse]
  ///
  /// [total]: The total number of comment ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the comment ids
  FindCommentIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindCommentIdsResponse] from json map
  factory FindCommentIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentIdsResponseFromJson(json);

  /// Creates a json map from a [FindCommentIdsResponse]
  Map<String, dynamic> toJson() => _$FindCommentIdsResponseToJson(this);
}
