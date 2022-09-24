import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/request/request.dart';

part 'find_shaders.g.dart';

@JsonSerializable()
class FindShadersRequest extends APIRequest {
  @JsonKey(name: 'shaders')

  /// The set of ids
  final Set<String> ids;

  /// Builds a [FindShadersRequest]
  FindShadersRequest(this.ids);

  @override
  List<Object> get props => [ids];

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
