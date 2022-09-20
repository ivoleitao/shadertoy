// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindCommentsResponse _$FindCommentsResponseFromJson(
        Map<String, dynamic> json) =>
    FindCommentsResponse(
      total: json['Comments'] as int?,
      comments: (json['Results'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentsResponseToJson(
        FindCommentsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Comments': instance.total,
      'Results': instance.comments?.map((e) => e.toJson()).toList(),
    };
