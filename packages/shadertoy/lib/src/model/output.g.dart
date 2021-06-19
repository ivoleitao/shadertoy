// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Output _$OutputFromJson(Map<String, dynamic> json) {
  return Output(
    id: Output._idFromJson(json['id']),
    channel: json['channel'] as int,
  );
}

Map<String, dynamic> _$OutputToJson(Output instance) => <String, dynamic>{
      'id': instance.id,
      'channel': instance.channel,
    };
