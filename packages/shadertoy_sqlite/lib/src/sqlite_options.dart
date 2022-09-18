import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';

enum WebBackend { sqljs, wasm }

/// Options for the Shadertoy Sqlite store
class ShadertoySqliteOptions extends ShadertoyClientOptions {
  /// The default value for the path
  static const String defaultPath = 'shadertoy.db';

  /// The default value for the foreign keys flag
  static const bool defaultForeignKeysEnabled = true;

  /// The default value for the log statements flag
  static const bool defaultLogStatementsEnabled = false;

  /// The default value for the web backend
  static const WebBackend defaultWebBackend = WebBackend.sqljs;

  /// The default location of the sqlite wasm for the wasm backend
  static const String defaultSqliteWasmPath = 'sqlite3.wasm';

  /// The default number of shaders fetched for a paged call.
  static const int defaultShaderCount = 12;

  /// The default number of shaders fetched for a user paged call.
  static const int defaultUserShaderCount = 8;

  /// The default number of shaders fetched for a playlist paged call.
  static const int defaultPlaylistShaderCount = 15;

  /// The path to the database
  final String path;

  /// The name of the database
  String get name => p.basename(path);

  /// If the foreign keys are enabled
  final bool foreignKeysEnabled;

  /// If the generated sql statements should be printed before executing
  final bool logStatementsEnabled;

  /// The web backend
  final WebBackend webBackend;

  /// The sqlite wasm path
  final String sqliteWasmPath;

  /// The number of shaders requested for paged call
  final int shaderCount;

  /// The number of shaders requested for a user paged call
  final int userShaderCount;

  /// The number of shaders requested for a playlist paged call
  final int playlistShaderCount;

  /// Builds a [ShadertoySqliteOptions]
  ///
  /// * [path]: The path to the database
  /// * [foreignKeysEnabled]: If the foreign keys are enabled
  /// * [logStatementsEnabled]: If true (defaults to `false`), generated sql statements will be printed before executing.
  /// * [webBackend]: The web backend to use
  /// * [sqliteWasmPath]: The sqlite wasm path for the wasm backend
  /// * [shaderCount]: The number of shaders requested for a paged call
  /// * [userShaderCount]: The number of shaders requested for a user paged call
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
  /// * [errorHandling]: The error handling mode
  ShadertoySqliteOptions(
      {String? path,
      bool? foreignKeysEnabled,
      bool? logStatementsEnabled,
      WebBackend? webBackend,
      String? sqliteWasmPath,
      int? shaderCount,
      int? userShaderCount,
      int? playlistShaderCount,
      ErrorMode? errorHandling})
      : path = path ?? defaultPath,
        foreignKeysEnabled = foreignKeysEnabled ?? defaultForeignKeysEnabled,
        logStatementsEnabled =
            logStatementsEnabled ?? defaultLogStatementsEnabled,
        webBackend = webBackend ?? defaultWebBackend,
        sqliteWasmPath = sqliteWasmPath ?? defaultSqliteWasmPath,
        shaderCount = shaderCount ?? defaultShaderCount,
        userShaderCount = userShaderCount ?? defaultUserShaderCount,
        playlistShaderCount = playlistShaderCount ?? defaultPlaylistShaderCount,
        super(errorHandling: errorHandling) {
    assert(this.shaderCount >= 1);
    assert(this.userShaderCount >= 1);
    assert(this.playlistShaderCount >= 1);
  }

  /// Builds a copy of a [ShadertoySqliteOptions]
  ///
  /// * [path]: The path to the database
  /// * [foreignKeysEnabled]: If the foreign keys are enabled
  /// * [logStatementsEnabled]: If true (defaults to `false`), generated sql statements will be printed before executing.
  /// * [webBackend]: The web backend to use
  /// * [sqliteWasmPath]: The sqlite wasm path for the wasm backend
  /// * [shaderCount]: The number of shaders requested for a paged call
  /// * [userShaderCount]: The number of shaders requested for a user paged call
  /// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
  /// * [errorHandling]: The error handling mode
  ShadertoySqliteOptions copyWith(
      {String? path,
      bool? foreignKeysEnabled,
      bool? logStatementsEnabled,
      WebBackend? webBackend,
      String? sqliteWasmPath,
      int? shaderCount,
      int? userShaderCount,
      int? playlistShaderCount,
      ErrorMode? errorHandling}) {
    return ShadertoySqliteOptions(
        path: path ?? this.path,
        foreignKeysEnabled: foreignKeysEnabled ?? this.foreignKeysEnabled,
        logStatementsEnabled: logStatementsEnabled ?? this.logStatementsEnabled,
        webBackend: webBackend ?? this.webBackend,
        sqliteWasmPath: sqliteWasmPath ?? this.sqliteWasmPath,
        shaderCount: shaderCount ?? this.shaderCount,
        userShaderCount: userShaderCount ?? this.userShaderCount,
        playlistShaderCount: playlistShaderCount ?? this.playlistShaderCount,
        errorHandling: errorHandling ?? this.errorHandling);
  }
}
