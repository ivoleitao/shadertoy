import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'find_shader_ids.g.dart';

@JsonSerializable()

/// Find shader ids API response
///
/// The response returned upon the execution of a find shader ids API call
/// When [FindShaderIdsResponse.fail] is *not null* there was an error in the find shader ids call
/// When [FindShaderIdsResponse.fail] is *null* the [FindShaderIdsResponse.ids] has the returned shader ids
class FindShaderIdsResponse extends APIResponse {
  @JsonKey(name: 'Shaders')

  /// The total number of shader ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of shader ids returned
  final List<String>? ids;

  /// Builds a [FindShaderIdsResponse]
  ///
  /// [total]: The total number of shader ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the shader ids
  FindShaderIdsResponse({int? count, this.ids, super.error})
      : total = count ?? ids?.length ?? 0;

  @override
  List<Object?> get props {
    return [...super.props, total, ids];
  }

  /// Creates a [FindShaderIdsResponse] from json map
  factory FindShaderIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShaderIdsResponseFromJson(json);

  /// Creates a json map from a [FindShaderIdsResponse]
  Map<String, dynamic> toJson() => _$FindShaderIdsResponseToJson(this);
}
