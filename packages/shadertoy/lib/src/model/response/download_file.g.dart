// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadFileResponse _$DownloadFileResponseFromJson(
        Map<String, dynamic> json) =>
    DownloadFileResponse(
      bytes: (json['Bytes'] as List<dynamic>?)?.map((e) => e as int).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$DownloadFileResponseToJson(
        DownloadFileResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Bytes': instance.bytes,
    };
