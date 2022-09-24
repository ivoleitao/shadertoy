import 'package:json_annotation/json_annotation.dart';

part 'find_shaders.g.dart';

@JsonSerializable()
class FindShadersRequest {
  @JsonKey(name: 'shaders')

  /// The set of ids
  final Set<String> ids;

  /// Builds a [FindShadersRequest]
  const FindShadersRequest(this.ids);

  /// Creates a [FindShadersRequest] from json map
  factory FindShadersRequest.fromJson(Map<String, dynamic> json) =>
      _$FindShadersRequestFromJson(json);

  /// Creates a json map from a [FindShadersRequest]
  Map<String, dynamic> toJson() => _$FindShadersRequestToJson(this);

  /// Builds a copy of a [FindShadersRequest]
  FindShadersRequest copyWith({
    Set<String>? ids,
  }) {
    return FindShadersRequest(ids ?? this.ids);
  }
}
