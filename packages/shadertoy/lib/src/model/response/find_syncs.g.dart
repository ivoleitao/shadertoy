// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_syncs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindSyncsResponse _$FindSyncsResponseFromJson(Map<String, dynamic> json) =>
    FindSyncsResponse(
      total: json['Syncs'] as int?,
      syncs: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindSyncResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindSyncsResponseToJson(FindSyncsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Syncs': instance.total,
      'Results': instance.syncs?.map((e) => e.toJson()).toList(),
    };
