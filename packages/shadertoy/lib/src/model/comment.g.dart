// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['id'] as String,
    shaderId: json['shaderId'] as String,
    userId: json['userId'] as String,
    picture: json['picture'] as String?,
    date: DateTime.parse(json['date'] as String),
    text: json['text'] as String,
    hidden: json['hidden'] as bool,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'shaderId': instance.shaderId,
      'userId': instance.userId,
      'picture': instance.picture,
      'date': instance.date.toIso8601String(),
      'text': instance.text,
      'hidden': instance.hidden,
    };
