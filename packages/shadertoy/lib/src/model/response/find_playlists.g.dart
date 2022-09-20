// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_playlists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindPlaylistsResponse _$FindPlaylistsResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistsResponse(
      total: json['Playlists'] as int?,
      playlists: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindPlaylistResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistsResponseToJson(
        FindPlaylistsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Playlists': instance.total,
      'Results': instance.playlists?.map((e) => e.toJson()).toList(),
    };
