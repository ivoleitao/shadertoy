// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindShadersRequest _$FindShadersRequestFromJson(Map<String, dynamic> json) {
  return FindShadersRequest(
    (json['shaders'] as List<dynamic>).map((e) => e as String).toSet(),
  );
}

Map<String, dynamic> _$FindShadersRequestToJson(FindShadersRequest instance) =>
    <String, dynamic>{
      'shaders': instance.ids.toList(),
    };
