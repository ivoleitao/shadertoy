import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/value_converter.dart';

part 'sampler.g.dart';

enum FilterType {
  /// None
  none,

  /// Nearest
  nearest,

  /// Linear
  linear,

  /// Mipmap
  mipmap
}

/// The wrap type
enum WrapType {
  /// None
  none,

  /// Clamp
  clamp,

  /// Repeat
  repeat,

  /// Mirror
  mirror
}

@JsonSerializable()

/// The sampler class
class Sampler extends Equatable {
  @JsonKey(name: 'filter')

  /// The filter type
  final FilterType filter;

  @JsonKey(name: 'wrap')

  /// The wrap type
  final WrapType wrap;

  @JsonKey(name: 'vflip')
  @StringToBoolConverter()

  /// Vertical flip
  final bool vflip;

  @JsonKey(name: 'srgb')
  @StringToBoolConverter()

  /// SRGB color space
  final bool srgb;

  @JsonKey(name: 'internal')

  /// Internal
  final String internal;

  /// Builds a [Sampler]
  ///
  /// * [filter]: Filter type
  /// * [wrap]: Wrap type
  /// * [vflip]: Vertical flip
  /// * [srgb]: Srgb color space
  /// * [internal]: Internal
  const Sampler(
      {required this.filter,
      required this.wrap,
      required this.vflip,
      required this.srgb,
      required this.internal});

  @override
  List<Object> get props => [filter, wrap, vflip, srgb, internal];

  /// Creates a [Sampler] from json map
  factory Sampler.fromJson(Map<String, dynamic> json) =>
      _$SamplerFromJson(json);

  /// Creates a json map from a [Sampler]
  Map<String, dynamic> toJson() => _$SamplerToJson(this);

  /// Builds a copy of a [Sampler]
  ///
  /// * [filter]: Filter type
  /// * [wrap]: Wrap type
  /// * [vflip]: Vertical flip
  /// * [srgb]: Srgb color space
  /// * [internal]: Internal
  Sampler copyWith({
    FilterType? filter,
    WrapType? wrap,
    bool? vflip,
    bool? srgb,
    String? internal,
  }) {
    return Sampler(
      filter: filter ?? this.filter,
      wrap: wrap ?? this.wrap,
      vflip: vflip ?? this.vflip,
      srgb: srgb ?? this.srgb,
      internal: internal ?? this.internal,
    );
  }
}
