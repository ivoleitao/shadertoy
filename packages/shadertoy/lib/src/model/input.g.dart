// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) {
  return Input(
    id: Input._idFromJson(json['id']),
    src: json['src'] as String?,
    filePath: json['filepath'] as String?,
    previewFilePath: json['previewfilepath'] as String?,
    type: _$enumDecodeNullable(_$InputTypeEnumMap, json['ctype']),
    channel: json['channel'] as int,
    sampler: Sampler.fromJson(json['sampler'] as Map<String, dynamic>),
    published: json['published'] as int,
  );
}

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
      'id': instance.id,
      'src': instance.src,
      'filepath': instance.filePath,
      'previewfilepath': instance.previewFilePath,
      'ctype': _$InputTypeEnumMap[instance.type],
      'channel': instance.channel,
      'sampler': instance.sampler.toJson(),
      'published': instance.published,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

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
