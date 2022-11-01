import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'comments.g.dart';

@JsonSerializable()

/// Comments response
///
/// The response returned from a call to the Shadertoy comments endpoint
/// When [CommentsResponse.fail] is *not null* there was an error while fetching the comments
/// When [CommentsResponse.fail] is *null* the [CommentsResponse] has a individual list of
/// text, date, user id's and user picture all with the same size. The first index of
/// of the text list corresponds to the first index of the date list and so on. This is a structure
/// used for the intermediary storage of the response. It is transformed in [FindCommentsResponse] later
class CommentsResponse extends APIResponse {
  @JsonKey(name: 'text')

  /// The list of comment texts
  final List<String>? texts;

  @JsonKey(name: 'date')

  /// The list of date for each comment
  final List<String>? dates;

  @JsonKey(name: 'username')

  /// The list of user id's that posted the comment
  final List<String>? userIds;

  @JsonKey(name: 'userpicture')

  /// The list of user pictures for each comment
  final List<String>? userPictures;

  @JsonKey(name: 'id')

  /// A list of the comment ids
  final List<String>? ids;

  @JsonKey(name: 'hidden')

  /// A list with a hidden flag for each comment
  final List<int>? hidden;

  /// Builds a [CommentsResponse]
  ///
  /// * [texts]: The list of text comments
  /// * [dates]: The list of dates for each comment
  /// * [userIds]: The list of user id's for each comment
  /// * [userPictures]: The list user pictures for each comment
  /// * [ids]: A list of the comment ids
  /// * [hidden]: A list with a hidden flag for each comment
  /// * [error]: An error if there was error while fetching the comments
  CommentsResponse(
      {this.texts,
      this.dates,
      this.userIds,
      this.userPictures,
      this.ids,
      this.hidden,
      super.error});

  @override
  List<Object?> get props {
    return [...super.props, texts, dates, userIds, userPictures, ids, hidden];
  }

  /// Creates a [CommentsResponse] from json list
  factory CommentsResponse.fromList(List<dynamic> json) => CommentsResponse(
      texts: const [],
      dates: const [],
      userIds: const [],
      userPictures: const [],
      ids: const [],
      hidden: const []);

  /// Creates a [CommentsResponse] from json map
  factory CommentsResponse.fromMap(Map<String, dynamic> json) =>
      _$CommentsResponseFromJson(json);

  /// Creates a [CommentsResponse] from json list or map
  factory CommentsResponse.from(dynamic data) => data is List
      ? CommentsResponse.fromList(data)
      : CommentsResponse.fromMap(data);

  /// Creates a json map from a [CommentsResponse]
  Map<String, dynamic> toJson() => _$CommentsResponseToJson(this);
}
