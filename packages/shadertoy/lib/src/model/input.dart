import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/model/sampler.dart';

part 'input.g.dart';

enum InputType {
  /// Texture
  texture,

  /// Volume
  volume,

  /// Cubemap
  cubemap,

  /// Music
  music,

  /// Music stream
  musicstream,

  /// Mic
  mic,

  /// Buffer
  buffer,

  /// Keyboard
  keyboard,

  /// Video
  video,

  /// Webcam
  webcam
}

@JsonSerializable()

/// An input
class Input extends Equatable {
  /// Transforms a input to string or uses an existing int value
  static String _idFromJson(dynamic input) =>
      input is int ? input.toString() : input;

  @JsonKey(name: 'id', fromJson: _idFromJson)

  /// The input id
  final String id;

  @JsonKey(name: 'src')

  /// The source
  final String? src;

  @JsonKey(name: 'filepath')

  /// The filepath
  final String? filePath;

  @JsonKey(name: 'previewfilepath')

  /// The preview file path
  final String? previewFilePath;

  @JsonKey(name: 'type')

  /// The input type with 'type' source
  final InputType? type1;

  @JsonKey(name: 'ctype')

  /// The input type with 'ctype' source
  final InputType? type2;

  @JsonKey(includeFromJson: false, includeToJson: false)

  /// Returns either the [type1] value or the [type2] value
  InputType? get type => type1 ?? type2;

  @JsonKey(name: 'channel')

  /// The channel number
  final int channel;

  @JsonKey(name: 'sampler')

  /// The sampler
  final Sampler sampler;

  @JsonKey(name: 'published')

  /// The published
  final int published;

  /// Builds a [Input]
  ///
  /// * [id]: The input id
  /// * [src]: The source
  /// * [filePath]: The file path
  /// * [previewFilePath]: The preview file path
  /// * [type]: The type. If present [type1] and [type2] values are ignored and both fields set with [type]
  /// * [type1]: The type1
  /// * [type2]: The type2
  /// * [channel]: The channel number
  /// * [sampler]: The sampler
  /// * [published]: The published
  const Input(
      {required this.id,
      this.src,
      this.filePath,
      this.previewFilePath,
      InputType? type,
      InputType? type1,
      InputType? type2,
      required this.channel,
      required this.sampler,
      required this.published})
      : type1 = type ?? type1,
        type2 = type ?? type2;

  @override
  List<Object?> get props =>
      [id, src, type1, type2, channel, sampler, published];

  /// Creates a [Input] from json map
  factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);

  /// Creates a json map from a [Input]
  Map<String, dynamic> toJson() => _$InputToJson(this);

  /// Builds a copy of a [Input]
  ///
  /// * [id]: The input id
  /// * [src]: The source
  /// * [filePath]: The file path
  /// * [previewFilePath]: The preview file path
  /// * [type]: The type. If present [type1] and [type2] values are ignored and both fields set with [type]
  /// * [type1]: The type1
  /// * [type2]: The type2
  /// * [channel]: The channel number
  /// * [sampler]: The sampler
  /// * [published]: The published
  Input copyWith({
    String? id,
    String? src,
    String? filePath,
    String? previewFilePath,
    InputType? type,
    InputType? type1,
    InputType? type2,
    int? channel,
    Sampler? sampler,
    int? published,
  }) {
    return Input(
      id: id ?? this.id,
      src: src ?? this.src,
      filePath: filePath ?? this.filePath,
      previewFilePath: previewFilePath ?? this.previewFilePath,
      type1: (type ?? type1) ?? this.type1,
      type2: (type ?? type2) ?? this.type2,
      channel: channel ?? this.channel,
      sampler: sampler ?? this.sampler,
      published: published ?? this.published,
    );
  }
}
