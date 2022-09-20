// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_shaders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindShadersRequest _$FindShadersRequestFromJson(Map<String, dynamic> json) =>
    FindShadersRequest(
      (json['shaders'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$FindShadersRequestToJson(FindShadersRequest instance) =>
    <String, dynamic>{
      'shaders': instance.ids.toList(),
    };
