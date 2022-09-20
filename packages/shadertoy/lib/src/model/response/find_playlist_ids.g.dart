// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_playlist_ids.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindPlaylistIdsResponse _$FindPlaylistIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistIdsResponseToJson(
        FindPlaylistIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };
