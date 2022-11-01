import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/shader.dart';

import 'response.dart';

part 'find_shader.g.dart';

@JsonSerializable()

/// Find shader API response
///
/// The response returned upon the execution of a find shader API call
/// When [FindShaderResponse.fail] is *not null* there was an error in the find shader call
/// When [FindShaderResponse.fail] is *null* the [FindShaderResponse.shader] has the returned shader
class FindShaderResponse extends APIResponse {
  @JsonKey(name: 'Shader')

  /// The shader returned, null when there is an error
  final Shader? shader;

  /// Builds an [FindShaderResponse]
  ///
  /// * [shader]: The shader
  /// * [error]: An error
  ///
  /// Upon construction either [shader] or [error] should be provided, not both
  FindShaderResponse({this.shader, super.error});

  @override
  List<Object?> get props {
    return [...super.props, shader];
  }

  /// Creates a [FindShaderResponse] from json map
  factory FindShaderResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShaderResponseFromJson(json);

  /// Creates a json map from a [FindShaderResponse]
  Map<String, dynamic> toJson() => _$FindShaderResponseToJson(this);
}
