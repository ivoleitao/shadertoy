import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/comment.dart';

import 'response.dart';

part 'find_comments.g.dart';

@JsonSerializable()

/// Find comments API response
///
/// The response returned upon the execution of a find comments API call
/// When [FindCommentsResponse.fail] is *not null* there was an error in the find comments call
/// When [FindCommentsResponse.fail] is *null* the [FindCommentsResponse.comments] has the returned comments
class FindCommentsResponse extends APIResponse {
  @JsonKey(name: 'Comments')

  /// The total number of comments
  final int total;

  @JsonKey(name: 'Results')

  /// The list of [Comment] returned
  final List<Comment>? comments;

  /// Builds a [FindCommentsResponse]
  ///
  /// [total]: The total number of comments returned
  /// [comments]: The list of [Comment]
  /// [error]: An error if there was error while fetching the comments
  FindCommentsResponse({int? total, this.comments, super.error})
      : total = total ?? comments?.length ?? 0;

  @override
  List<Object?> get props {
    return [...super.props, total, comments];
  }

  /// Creates a [FindCommentsResponse] from json map
  factory FindCommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentsResponseFromJson(json);

  /// Creates a json map from a [FindCommentsResponse]
  Map<String, dynamic> toJson() => _$FindCommentsResponseToJson(this);
}
