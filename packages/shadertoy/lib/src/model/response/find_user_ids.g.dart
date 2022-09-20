// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_user_ids.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindUserIdsResponse _$FindUserIdsResponseFromJson(Map<String, dynamic> json) =>
    FindUserIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUserIdsResponseToJson(
        FindUserIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };
