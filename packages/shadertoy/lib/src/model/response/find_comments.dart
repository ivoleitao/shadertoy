import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/comment.dart';

import 'error.dart';
import 'response.dart';

part 'find_comments.g.dart';

@JsonSerializable()

/// Find comments API response
///
/// The response returned upon the execution of a find comments API call
/// When [FindCommentsResponse.error] is *not null* there was an error in the find comments call
/// When [FindCommentsResponse.error] is *null* the [FindCommentsResponse.comments] has the returned comments
class FindCommentsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Comments')

  /// The total number of comments
  final int total;

  @JsonKey(name: 'Results')

  /// The list of [Comment] returned
  final List<Comment>? comments;

  @override
  List get props {
    return [total, comments, error];
  }

  /// Builds a [FindCommentsResponse]
  ///
  /// [total]: The total number of comments returned
  /// [comments]: The list of [Comment]
  /// [error]: An error if there was error while fetching the comments
  FindCommentsResponse({int? total, this.comments, ResponseError? error})
      : total = total ?? comments?.length ?? 0,
        super(error: error);

  /// Creates a [FindCommentsResponse] from json map
  factory FindCommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentsResponseFromJson(json);

  /// Creates a json map from a [FindCommentsResponse]
  Map<String, dynamic> toJson() => _$FindCommentsResponseToJson(this);
}
