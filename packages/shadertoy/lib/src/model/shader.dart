import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/context.dart';
import 'package:shadertoy/src/model/info.dart';
import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/render_pass.dart';
import 'package:shadertoy/src/util/path_util.dart';

part 'shader.g.dart';

@JsonSerializable()

/// The Shader class
class Shader extends Equatable {
  @JsonKey(name: 'ver')

  /// The shader version
  final String version;

  @JsonKey(name: 'info')

  /// The shader meta information
  final Info info;

  @JsonKey(name: 'renderpass')

  /// The shader render passes
  final List<RenderPass> renderPasses;

  /// Builds a [Shader]
  ///
  /// * [version]: The shader version
  /// * [info]: The shader meta information
  /// * [renderPasses]: The shader render passes
  const Shader(
      {required this.version, required this.info, required this.renderPasses});

  /// Returns the list of input source paths
  Set<String> inputSourcePaths() {
    final paths = <String>{};

    for (var rp in renderPasses) {
      final inputs = rp.inputs;

      for (var i in inputs) {
        if (i.type == InputType.buffer || i.type == InputType.texture) {
          final src = i.src ?? i.filePath;
          if (src != null && src.isNotEmpty) {
            paths.add(picturePath(src));
          }
        }
      }
    }

    return paths;
  }

  /// Returns the list of picture paths
  Set<String> picturePaths() {
    return {ShadertoyContext.shaderPicturePath(info.id), ...inputSourcePaths()};
  }

  @override
  List<Object> get props => [version, info, renderPasses];

  /// Creates a [Shader] from json map
  factory Shader.fromJson(Map<String, dynamic> json) => _$ShaderFromJson(json);

  /// Creates a json map from a [Shader]
  Map<String, dynamic> toJson() => _$ShaderToJson(this);

  /// Builds a copy of a [Shader]
  ///
  /// * [version]: The shader version
  /// * [info]: The shader meta information
  /// * [renderPasses]: The shader render passes
  Shader copyWith({
    String? version,
    Info? info,
    List<RenderPass>? renderPasses,
  }) {
    return Shader(
      version: version ?? this.version,
      info: info ?? this.info,
      renderPasses: renderPasses ?? this.renderPasses,
    );
  }
}
