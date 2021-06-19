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

  @JsonKey(name: 'ctype')

  /// The input type
  final InputType? type;

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
  /// * [type]: The type
  /// * [channel]: The channel number
  /// * [sampler]: The sampler
  /// * [published]: The published
  const Input(
      {required this.id,
      this.src,
      this.filePath,
      this.previewFilePath,
      this.type,
      required this.channel,
      required this.sampler,
      required this.published});

  @override
  List<Object?> get props => [id, src, type, channel, sampler, published];

  /// Creates a [Input] from json map
  factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);

  /// Creates a json map from a [Input]
  Map<String, dynamic> toJson() => _$InputToJson(this);

  /// Builds a copy of a [Input]
  ///
  /// * [id]: The input id
  /// * [src]: The source
  /// * [type]: The type
  /// * [channel]: The channel number
  /// * [sampler]: The sampler
  /// * [published]: The published
  Input copyWith({
    String? id,
    String? src,
    String? filePath,
    String? previewFilePath,
    InputType? type,
    int? channel,
    Sampler? sampler,
    int? published,
  }) {
    return Input(
      id: id ?? this.id,
      src: src ?? this.src,
      filePath: filePath ?? this.filePath,
      previewFilePath: previewFilePath ?? this.previewFilePath,
      type: type ?? this.type,
      channel: channel ?? this.channel,
      sampler: sampler ?? this.sampler,
      published: published ?? this.published,
    );
  }
}
