import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'error.dart';
import 'response.dart';

part 'find_playlist_ids.g.dart';

@JsonSerializable()

/// Find playlist ids API response
///
/// The response returned upon the execution of a find playlist ids API call
/// When [FindPlaylistIdsResponse.error] is *not null* there was an error in the find playlist ids call
/// When [FindPlaylistIdsResponse.error] is *null* the [FindPlaylistIdsResponse.ids] has the returned playlist ids
class FindPlaylistIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Playlists')

  /// The total number of playlist ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of playlist ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindPlaylistIdsResponse]
  ///
  /// [total]: The total number of playlist ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the playlist ids
  FindPlaylistIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindPlaylistIdsResponse] from json map
  factory FindPlaylistIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistIdsResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistIdsResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistIdsResponseToJson(this);
}
