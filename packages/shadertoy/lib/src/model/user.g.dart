// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      picture: json['picture'] as String?,
      memberSince: DateTime.parse(json['memberSince'] as String),
      following: json['following'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      about: json['about'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'picture': instance.picture,
      'memberSince': instance.memberSince.toIso8601String(),
      'following': instance.following,
      'followers': instance.followers,
      'about': instance.about,
    };
