// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_shaders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindShadersResponse _$FindShadersResponseFromJson(Map<String, dynamic> json) =>
    FindShadersResponse(
      total: json['Shaders'] as int?,
      shaders: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindShaderResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShadersResponseToJson(
        FindShadersResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Shaders': instance.total,
      'Results': instance.shaders?.map((e) => e.toJson()).toList(),
    };
