// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) => Input(
      id: Input._idFromJson(json['id']),
      src: json['src'] as String?,
      filePath: json['filepath'] as String?,
      previewFilePath: json['previewfilepath'] as String?,
      type1: $enumDecodeNullable(_$InputTypeEnumMap, json['type']),
      type2: $enumDecodeNullable(_$InputTypeEnumMap, json['ctype']),
      channel: json['channel'] as int,
      sampler: Sampler.fromJson(json['sampler'] as Map<String, dynamic>),
      published: json['published'] as int,
    );

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
      'id': instance.id,
      'src': instance.src,
      'filepath': instance.filePath,
      'previewfilepath': instance.previewFilePath,
      'type': _$InputTypeEnumMap[instance.type1],
      'ctype': _$InputTypeEnumMap[instance.type2],
      'channel': instance.channel,
      'sampler': instance.sampler.toJson(),
      'published': instance.published,
    };

const _$InputTypeEnumMap = {
  InputType.texture: 'texture',
  InputType.volume: 'volume',
  InputType.cubemap: 'cubemap',
  InputType.music: 'music',
  InputType.musicstream: 'musicstream',
  InputType.mic: 'mic',
  InputType.buffer: 'buffer',
  InputType.keyboard: 'keyboard',
  InputType.video: 'video',
  InputType.webcam: 'webcam',
};
