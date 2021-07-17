// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      id: json['id'] as String,
      date: const StringEpochInSecondsConverter()
          .fromJson(json['date'] as String),
      views: json['viewed'] as int? ?? 0,
      name: json['name'] as String,
      userId: json['username'] as String,
      description: json['description'] as String?,
      likes: json['likes'] as int? ?? 0,
      privacy: _$enumDecode(_$ShaderPrivacyEnumMap, json['published']),
      flags: json['flags'] as int? ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      hasLiked: json['hasliked'] == null
          ? false
          : const IntToBoolConverter().fromJson(json['hasliked'] as int),
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'id': instance.id,
      'date': const StringEpochInSecondsConverter().toJson(instance.date),
      'viewed': instance.views,
      'name': instance.name,
      'username': instance.userId,
      'description': instance.description,
      'likes': instance.likes,
      'published': _$ShaderPrivacyEnumMap[instance.privacy],
      'flags': instance.flags,
      'tags': instance.tags,
      'hasliked': const IntToBoolConverter().toJson(instance.hasLiked),
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

const _$ShaderPrivacyEnumMap = {
  ShaderPrivacy.private: 0,
  ShaderPrivacy.unlisted: 1,
  ShaderPrivacy.public: 2,
  ShaderPrivacy.publicApi: 3,
};
