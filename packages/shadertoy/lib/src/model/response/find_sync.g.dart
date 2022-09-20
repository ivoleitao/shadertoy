// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindSyncResponse _$FindSyncResponseFromJson(Map<String, dynamic> json) =>
    FindSyncResponse(
      sync: json['Sync'] == null
          ? null
          : Sync.fromJson(json['Sync'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindSyncResponseToJson(FindSyncResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Sync': instance.sync?.toJson(),
    };
