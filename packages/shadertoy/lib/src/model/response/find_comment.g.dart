// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindCommentResponse _$FindCommentResponseFromJson(Map<String, dynamic> json) =>
    FindCommentResponse(
      comment: json['Comment'] == null
          ? null
          : Comment.fromJson(json['Comment'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentResponseToJson(
        FindCommentResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Comment': instance.comment?.toJson(),
    };
