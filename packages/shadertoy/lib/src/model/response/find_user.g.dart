// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindUserResponse _$FindUserResponseFromJson(Map<String, dynamic> json) =>
    FindUserResponse(
      user: json['User'] == null
          ? null
          : User.fromJson(json['User'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUserResponseToJson(FindUserResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'User': instance.user?.toJson(),
    };
