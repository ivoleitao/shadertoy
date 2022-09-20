// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_comment_ids.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindCommentIdsResponse _$FindCommentIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindCommentIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentIdsResponseToJson(
        FindCommentIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };
