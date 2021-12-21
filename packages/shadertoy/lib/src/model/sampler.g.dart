// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sampler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sampler _$SamplerFromJson(Map<String, dynamic> json) => Sampler(
      filter: $enumDecode(_$FilterTypeEnumMap, json['filter']),
      wrap: $enumDecode(_$WrapTypeEnumMap, json['wrap']),
      vflip: const StringToBoolConverter().fromJson(json['vflip'] as String),
      srgb: const StringToBoolConverter().fromJson(json['srgb'] as String),
      internal: json['internal'] as String,
    );

Map<String, dynamic> _$SamplerToJson(Sampler instance) => <String, dynamic>{
      'filter': _$FilterTypeEnumMap[instance.filter],
      'wrap': _$WrapTypeEnumMap[instance.wrap],
      'vflip': const StringToBoolConverter().toJson(instance.vflip),
      'srgb': const StringToBoolConverter().toJson(instance.srgb),
      'internal': instance.internal,
    };

const _$FilterTypeEnumMap = {
  FilterType.none: 'none',
  FilterType.nearest: 'nearest',
  FilterType.linear: 'linear',
  FilterType.mipmap: 'mipmap',
};

const _$WrapTypeEnumMap = {
  WrapType.none: 'none',
  WrapType.clamp: 'clamp',
  WrapType.repeat: 'repeat',
  WrapType.mirror: 'mirror',
};
