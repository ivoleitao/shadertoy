import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'error.dart';
import 'find_shader.dart';
import 'response.dart';

part 'find_shaders.g.dart';

@JsonSerializable()

/// Find shaders API response
///
/// The response returned upon the execution of a find shaders API call
/// When [FindShadersResponse.error] is *not null* there was an error in the find shaders call
/// When [FindShadersResponse.error] is *null* the [FindShadersResponse.shaders] has the returned shaders
class FindShadersResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Shaders')

  /// The total number of shaders
  final int total;

  @JsonKey(name: 'Results')

  /// The list of the shaders returned
  final List<FindShaderResponse>? shaders;

  @override
  List get props {
    return [total, shaders, error];
  }

  /// Builds a [FindShadersResponse]
  ///
  /// [total]: The total number of shader returned
  /// [shaders]: The list of shaders
  /// [error]: An error if there was error while fetching the shaders
  FindShadersResponse({int? total, this.shaders, ResponseError? error})
      : total = total ?? shaders?.length ?? 0,
        super(error: error);

  /// Creates a [FindShadersResponse] from json map
  factory FindShadersResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShadersResponseFromJson(json);

  /// Creates a json map from a [FindShadersResponse]
  Map<String, dynamic> toJson() => _$FindShadersResponseToJson(this);
}
