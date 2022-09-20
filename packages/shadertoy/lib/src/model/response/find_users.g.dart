// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindUsersResponse _$FindUsersResponseFromJson(Map<String, dynamic> json) =>
    FindUsersResponse(
      total: json['Users'] as int?,
      users: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUsersResponseToJson(FindUsersResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Users': instance.total,
      'Results': instance.users?.map((e) => e.toJson()).toList(),
    };
