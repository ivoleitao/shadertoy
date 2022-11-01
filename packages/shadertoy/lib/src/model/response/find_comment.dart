import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/comment.dart';

import 'response.dart';

part 'find_comment.g.dart';

@JsonSerializable()

/// Find comment API response
///
/// The response returned upon the execution of a find comment API call
/// When [FindCommentResponse.fail] is *not null* there was an error in the find comment call
/// When [FindCommentResponse.fail] is *null* the [FindCommentResponse.comment] has the returned comment
class FindCommentResponse extends APIResponse {
  @JsonKey(name: 'Comment')

  /// The comment returned, null when there is an error
  final Comment? comment;

  /// Builds a [FindCommentResponse]
  ///
  /// [comment]: The comment
  /// [error]: An error if there was error while fetching the comment
  FindCommentResponse({this.comment, super.error});

  @override
  List<Object?> get props {
    return [...super.props, comment];
  }

  /// Creates a [FindCommentResponse] from json map
  factory FindCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentResponseFromJson(json);

  /// Creates a json map from a [FindCommentResponse]
  Map<String, dynamic> toJson() => _$FindCommentResponseToJson(this);
}
