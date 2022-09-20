import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/response/find_playlist.dart';

import 'error.dart';
import 'response.dart';

part 'find_playlists.g.dart';

@JsonSerializable()

/// Find playlists API response
///
/// The response returned upon the execution of a find playlists API call
/// When [FindPlaylistsResponse.error] is *not null* there was an error in the find playlists call
/// When [FindPlaylistsResponse.error] is *null* the [FindPlaylistsResponse.playlists] has the returned playlists
class FindPlaylistsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Playlists')

  /// The total number of playlists
  final int total;

  @JsonKey(name: 'Results')

  /// The list of playlists returned
  final List<FindPlaylistResponse>? playlists;

  @override
  List get props {
    return [total, playlists, error];
  }

  /// Builds a [FindPlaylistsResponse]
  ///
  /// [total]: The total number of playlists returned
  /// [playlists]: The list of [Playlist]
  /// [error]: An error if there was error while fetching the playlists
  FindPlaylistsResponse({int? total, this.playlists, ResponseError? error})
      : total = total ?? playlists?.length ?? 0,
        super(error: error);

  /// Creates a [FindPlaylistsResponse] from json map
  factory FindPlaylistsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistsResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistsResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistsResponseToJson(this);
}
