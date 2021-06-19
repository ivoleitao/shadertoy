import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/input.dart';
import 'package:shadertoy/src/model/output.dart';

part 'render_pass.g.dart';

enum RenderPassType {
  /// Sound
  sound,

  /// Common
  common,

  /// Image
  image,

  /// Buffer
  buffer,

  /// Cubemap
  cubemap
}

@JsonSerializable()

/// Renderpass class
class RenderPass extends Equatable {
  @JsonKey(name: 'name')

  /// The name of the render pass
  final String name;

  @JsonKey(name: 'type')

  /// The type of the render pass
  final RenderPassType type;

  @JsonKey(name: 'description')

  /// The render pass description
  final String? description;

  @JsonKey(name: 'code')

  /// the code
  final String code;

  @JsonKey(name: 'inputs')

  /// The list of inputs
  final List<Input> inputs;

  @JsonKey(name: 'outputs')

  /// The list of outputs
  final List<Output> outputs;

  /// Builds a [RenderPass]
  ///
  /// * [name]: The render pass name
  /// * [type]: The render pass type
  /// * [description]: The render pass description
  /// * [code]: The render pass code
  /// * [inputs]: The list of [Input]
  /// * [outputs]: The list of [Output]
  const RenderPass(
      {required this.name,
      required this.type,
      this.description,
      required this.code,
      required this.inputs,
      required this.outputs});

  @override
  List<Object?> get props => [name, type, description, code, inputs, outputs];

  /// Creates a [RenderPass] from json map
  factory RenderPass.fromJson(Map<String, dynamic> json) =>
      _$RenderPassFromJson(json);

  /// Creates a json map from a [RenderPass]
  Map<String, dynamic> toJson() => _$RenderPassToJson(this);

  /// Builds a copy of a [RenderPass]
  ///
  /// * [name]: The render pass name
  /// * [type]: The render pass type
  /// * [description]: The render pass description
  /// * [code]: The render pass code
  /// * [inputs]: The list of [Input]
  /// * [outputs]: The list of [Output]
  RenderPass copyWith(
      {String? name,
      RenderPassType? type,
      String? description,
      String? code,
      List<Input>? inputs,
      List<Output>? outputs}) {
    return RenderPass(
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      code: code ?? this.code,
      inputs: inputs ?? this.inputs,
      outputs: outputs ?? this.outputs,
    );
  }
}
