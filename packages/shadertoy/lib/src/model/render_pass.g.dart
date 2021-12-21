// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderPass _$RenderPassFromJson(Map<String, dynamic> json) => RenderPass(
      name: json['name'] as String,
      type: $enumDecode(_$RenderPassTypeEnumMap, json['type']),
      description: json['description'] as String?,
      code: json['code'] as String,
      inputs: (json['inputs'] as List<dynamic>)
          .map((e) => Input.fromJson(e as Map<String, dynamic>))
          .toList(),
      outputs: (json['outputs'] as List<dynamic>)
          .map((e) => Output.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RenderPassToJson(RenderPass instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$RenderPassTypeEnumMap[instance.type],
      'description': instance.description,
      'code': instance.code,
      'inputs': instance.inputs.map((e) => e.toJson()).toList(),
      'outputs': instance.outputs.map((e) => e.toJson()).toList(),
    };

const _$RenderPassTypeEnumMap = {
  RenderPassType.sound: 'sound',
  RenderPassType.common: 'common',
  RenderPassType.image: 'image',
  RenderPassType.buffer: 'buffer',
  RenderPassType.cubemap: 'cubemap',
};
