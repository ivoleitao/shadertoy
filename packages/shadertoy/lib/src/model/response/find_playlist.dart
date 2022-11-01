import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/playlist.dart';

import 'response.dart';

part 'find_playlist.g.dart';

@JsonSerializable()

/// Find playlist API response
///
/// The response returned upon the execution of a find playlist API call
/// When [FindPlaylistResponse.error] is *not null* there was an error in the find playlist call
/// When [FindPlaylistResponse.error] is *null* the [FindPlaylistResponse.playlist] has the returned playlist
class FindPlaylistResponse extends APIResponse {
  @JsonKey(name: 'Playlist')

  /// The playlist returned, null when there is an error
  final Playlist? playlist;

  /// Builds a [FindPlaylistResponse]
  ///
  /// [playlist]: The playlist
  /// [error]: An error if there was error while fetching the playlist
  FindPlaylistResponse({this.playlist, super.error});

  @override
  List<Object?> get props {
    return [...super.props, playlist];
  }

  /// Creates a [FindPlaylistResponse] from json map
  factory FindPlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistResponseToJson(this);
}
