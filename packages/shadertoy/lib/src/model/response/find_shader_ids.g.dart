// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_shader_ids.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindShaderIdsResponse _$FindShaderIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindShaderIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShaderIdsResponseToJson(
        FindShaderIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };
