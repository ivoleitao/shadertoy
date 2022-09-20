import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/shader.dart';

import 'error.dart';
import 'response.dart';

part 'find_shader.g.dart';

@JsonSerializable()

/// Find shader API response
///
/// The response returned upon the execution of a find shader API call
/// When [FindShaderResponse.error] is *not null* there was an error in the find shader call
/// When [FindShaderResponse.error] is *null* the [FindShaderResponse.shader] has the returned shader
class FindShaderResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Shader')

  /// The shader returned, null when there is an error
  final Shader? shader;

  @override
  List get props {
    return [shader, error];
  }

  /// Builds an [FindShaderResponse]
  ///
  /// * [shader]: The shader
  /// * [error]: An error
  ///
  /// Upon construction either [shader] or [error] should be provided, not both
  FindShaderResponse({this.shader, ResponseError? error}) : super(error: error);

  /// Creates a [FindShaderResponse] from json map
  factory FindShaderResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShaderResponseFromJson(json);

  /// Creates a json map from a [FindShaderResponse]
  Map<String, dynamic> toJson() => _$FindShaderResponseToJson(this);
}
