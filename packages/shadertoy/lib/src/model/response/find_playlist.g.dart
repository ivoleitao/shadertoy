// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindPlaylistResponse _$FindPlaylistResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistResponse(
      playlist: json['Playlist'] == null
          ? null
          : Playlist.fromJson(json['Playlist'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistResponseToJson(
        FindPlaylistResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Playlist': instance.playlist?.toJson(),
    };
