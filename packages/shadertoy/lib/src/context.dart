import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'context.g.dart';

/// Maintains a context with Shadertoy related configurations and contant values
///
/// It's provided as a one stop source for contextual information in the Shadertoy clients
@JsonSerializable()
class ShadertoyContext extends Equatable {
  /// The relative path to the shader images previews
  static const String ShaderMediaPath = 'media/shaders';

  /// The relative path to the user image thumbnails
  static const String UserMediaPath = 'media/users';

  /// The relative path to the signin url
  static const String SignInPath = 'signin';

  /// The relative path to the signout url
  static const String SignOutPath = 'signout';

  /// The relative path to the shader embedding
  static const String EmbedPath = 'embed';

  /// The relative path to the browse url
  static const String BrowsePath = 'browse';

  /// The relative path to the shader view url
  static const String ViewPath = 'view';

  /// The relative path to the img url
  static const String ImgPath = 'img';

  /// The base url of the shadertoy website
  @JsonKey(name: 'baseUrl')
  final String baseUrl;

  /// Builds a Shadertoy context with [baseUrl]
  const ShadertoyContext(this.baseUrl);

  /// The relative path of the shader view url
  /// * [shaderId]: The shader id
  static String shaderViewPath(String shaderId) {
    return '$ViewPath/$shaderId';
  }

  /// The relative path of the shader embed url
  /// * [shaderId]: The shader id
  static String shaderEmbedPath(String shaderId) {
    return '$EmbedPath/$shaderId';
  }

  /// The relative path of the shader picture url
  /// * [shaderId]: The shader id
  static String shaderPicturePath(String shaderId) {
    return '$ShaderMediaPath/$shaderId.jpg';
  }

  @override
  List<Object> get props => [baseUrl];

  /// The relative path of the shader view url
  /// * [shaderId]: The shader id
  String getShaderViewPath(String shaderId) {
    return shaderViewPath(shaderId);
  }

  /// The relative path of the shader embed url
  /// * [shaderId]: The shader id
  String getShaderEmbedPath(String shaderId) {
    return shaderEmbedPath(shaderId);
  }

  /// The relative path of the shader picture url
  /// * [shaderId]: The shader id
  String getShaderPicturePath(String shaderId) {
    return shaderPicturePath(shaderId);
  }

  /// The signin url
  String get signInUrl {
    return '$baseUrl/$SignInPath';
  }

  /// The signout url
  String get signOutUrl {
    return '$baseUrl/$SignOutPath';
  }

  /// The browse url
  String get shaderBrowseUrl {
    return '$baseUrl/$BrowsePath';
  }

  /// The shader view url
  /// * [shaderId]: The shader id
  String getShaderViewUrl(String shaderId) {
    return '$baseUrl/${getShaderViewPath(shaderId)}';
  }

  /// The shader embed url
  /// * [shaderId]: The shader id
  /// * [gui]: If the GUI should be presented or hidden
  /// * [t]: The starting point in seconds
  /// * [paused]: If the shader should start paused
  /// * [muted]: If the sound should be muted
  String getShaderEmbedUrl(String shaderId,
      {bool gui = false, int t = 10, bool paused = false, bool muted = false}) {
    return '$baseUrl/${shaderEmbedPath(shaderId)}?gui=$gui&t=$t&paused=$paused&muted=$muted';
  }

  /// The shader picture url
  /// * [shaderId]: The shader id
  String getShaderPictureUrl(String shaderId) {
    return '$baseUrl/${getShaderPicturePath(shaderId)}';
  }

  /// Creates a [ShadertoyContext] out of a json map
  factory ShadertoyContext.fromJson(Map<String, dynamic> json) =>
      _$ShadertoyContextFromJson(json);

  /// Creates a json map from a [ShadertoyContext]
  Map<String, dynamic> toJson() => _$ShadertoyContextToJson(this);
}
