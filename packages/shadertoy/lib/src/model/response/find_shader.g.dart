// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_shader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindShaderResponse _$FindShaderResponseFromJson(Map<String, dynamic> json) =>
    FindShaderResponse(
      shader: json['Shader'] == null
          ? null
          : Shader.fromJson(json['Shader'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShaderResponseToJson(FindShaderResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Shader': instance.shader?.toJson(),
    };
