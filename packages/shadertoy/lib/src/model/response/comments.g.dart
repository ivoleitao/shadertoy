// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsResponse _$CommentsResponseFromJson(Map<String, dynamic> json) =>
    CommentsResponse(
      texts: (json['text'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dates: (json['date'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userIds: (json['username'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      userPictures: (json['userpicture'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ids: (json['id'] as List<dynamic>?)?.map((e) => e as String).toList(),
      hidden: (json['hidden'] as List<dynamic>?)?.map((e) => e as int).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$CommentsResponseToJson(CommentsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'text': instance.texts,
      'date': instance.dates,
      'username': instance.userIds,
      'userpicture': instance.userPictures,
      'id': instance.ids,
      'hidden': instance.hidden,
    };
