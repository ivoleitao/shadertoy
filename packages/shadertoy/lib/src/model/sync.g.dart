// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sync _$SyncFromJson(Map<String, dynamic> json) => Sync(
      type: $enumDecode(_$SyncTypeEnumMap, json['type']),
      target: json['target'] as String,
      status: $enumDecode(_$SyncStatusEnumMap, json['status']),
      message: json['message'] as String?,
      creationTime: DateTime.parse(json['creationTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$SyncToJson(Sync instance) => <String, dynamic>{
      'type': _$SyncTypeEnumMap[instance.type],
      'target': instance.target,
      'status': _$SyncStatusEnumMap[instance.status],
      'message': instance.message,
      'creationTime': instance.creationTime.toIso8601String(),
      'updateTime': instance.updateTime.toIso8601String(),
    };

const _$SyncTypeEnumMap = {
  SyncType.user: 'user',
  SyncType.shader: 'shader',
  SyncType.comment: 'comment',
  SyncType.playlist: 'playlist',
  SyncType.asset: 'asset',
};

const _$SyncStatusEnumMap = {
  SyncStatus.ok: 'ok',
  SyncStatus.error: 'error',
};
