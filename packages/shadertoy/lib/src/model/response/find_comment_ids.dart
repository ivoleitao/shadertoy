import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'find_comment_ids.g.dart';

@JsonSerializable()

/// Find comment ids API response
///
/// The response returned upon the execution of a find comment ids API call
/// When [FindCommentIdsResponse.fail] is *not null* there was an error in the find comment ids call
/// When [FindCommentIdsResponse.fail] is *null* the [FindCommentIdsResponse.ids] has the returned comment ids
class FindCommentIdsResponse extends APIResponse {
  @JsonKey(name: 'Comments')

  /// The total number of comment ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of comment ids returned
  final List<String>? ids;

  /// Builds a [FindCommentIdsResponse]
  ///
  /// [total]: The total number of comment ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the comment ids
  FindCommentIdsResponse({int? count, this.ids, super.error})
      : total = count ?? ids?.length ?? 0;

  @override
  List<Object?> get props {
    return [...super.props, total, ids];
  }

  /// Creates a [FindCommentIdsResponse] from json map
  factory FindCommentIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentIdsResponseFromJson(json);

  /// Creates a json map from a [FindCommentIdsResponse]
  Map<String, dynamic> toJson() => _$FindCommentIdsResponseToJson(this);
}
