import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'find_playlist_ids.g.dart';

@JsonSerializable()

/// Find playlist ids API response
///
/// The response returned upon the execution of a find playlist ids API call
/// When [FindPlaylistIdsResponse.fail] is *not null* there was an error in the find playlist ids call
/// When [FindPlaylistIdsResponse.fail] is *null* the [FindPlaylistIdsResponse.ids] has the returned playlist ids
class FindPlaylistIdsResponse extends APIResponse {
  @JsonKey(name: 'Playlists')

  /// The total number of playlist ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of playlist ids returned
  final List<String>? ids;

  /// Builds a [FindPlaylistIdsResponse]
  ///
  /// [total]: The total number of playlist ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the playlist ids
  FindPlaylistIdsResponse({int? count, this.ids, super.error})
      : total = count ?? ids?.length ?? 0;

  @override
  List<Object?> get props {
    return [...super.props, total, ids];
  }

  /// Creates a [FindPlaylistIdsResponse] from json map
  factory FindPlaylistIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistIdsResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistIdsResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistIdsResponseToJson(this);
}
