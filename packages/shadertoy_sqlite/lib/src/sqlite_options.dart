import 'package:shadertoy/shadertoy_api.dart';

/// Options for the Shadertoy Moor store
class ShadertoyMoorOptions extends ShadertoyClientOptions {
  /// The default number of shaders fetched for a paged call.
  static const int DefaultShaderCount = 12;

  /// The default number of shaders fetched for a user paged call.
  static const int DefaultUserShaderCount = 8;

  /// The default number of shaders fetched for a playlist paged call.
  static const int DefaultPlaylistShaderCount = 15;

  /// The number of shaders requested for paged call
  final int shaderCount;

  /// The number of shaders requested for a user paged call
  final int userShaderCount;

  /// The number of shaders requested for a playlist paged call
  final int playlistShaderCount;

  /// Builds a [ShadertoyMoorOptions]
  ///
  /// * [shaderCount]: The number of shaders requested for a paged call
  /// * [userShaderCount]: The number of shaders requested for a user paged call
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
  /// * [errorHandling]: The error handling mode
  ShadertoyMoorOptions(
      {int? shaderCount,
      int? userShaderCount,
      int? playlistShaderCount,
      ErrorMode? errorHandling})
      : shaderCount = shaderCount ?? DefaultShaderCount,
        userShaderCount = userShaderCount ?? DefaultUserShaderCount,
        playlistShaderCount = playlistShaderCount ?? DefaultPlaylistShaderCount,
        super(errorHandling: errorHandling) {
    assert(this.shaderCount >= 1);
    assert(this.userShaderCount >= 1);
    assert(this.playlistShaderCount >= 1);
  }

  /// Builds a copy of a [ShadertoyMoorOptions]
  ///
  /// * [shaderCount]: The number of shaders requested for a paged call
  /// * [userShaderCount]: The number of shaders requested for a user paged call
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
  /// * [errorHandling]: The error handling mode
  ShadertoyMoorOptions copyWith(
      {int? shaderCount,
      int? userShaderCount,
      int? playlistShaderCount,
      ErrorMode? errorHandling}) {
    return ShadertoyMoorOptions(
        shaderCount: shaderCount ?? this.shaderCount,
        userShaderCount: userShaderCount ?? this.userShaderCount,
        playlistShaderCount: playlistShaderCount ?? this.playlistShaderCount,
        errorHandling: errorHandling ?? this.errorHandling);
  }
}
