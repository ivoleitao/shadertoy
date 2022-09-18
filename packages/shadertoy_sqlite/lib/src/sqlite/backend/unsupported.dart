import 'package:drift/drift.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy/shadertoy_util.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';

/// Builds a platform [ShadertoySqliteOptions]
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
ShadertoySqliteOptions getOptions(
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
      path: path,
      foreignKeysEnabled: foreignKeysEnabled,
      logStatementsEnabled: logStatementsEnabled,
      webBackend: webBackend,
      sqliteWasmPath: sqliteWasmPath,
      shaderCount: shaderCount,
      userShaderCount: userShaderCount,
      playlistShaderCount: playlistShaderCount,
      errorHandling: errorHandling);
}

Future<QueryExecutor> memoryExecutor(ShadertoySqliteOptions options) {
  throw Future.error(UnsupportedError(
      'No suitable backend implementation was found on this platform.'));
}

Future<QueryExecutor> localExecutor(ShadertoySqliteOptions options) async {
  return Future.error(UnsupportedError(
      'No suitable backend implementation was found on this platform.'));
}

/// Converts a [Exception] to a [ResponseError]
///
/// * [sqle]: The [Exception]
/// * [context]: The optional context of the error
/// * [target]: The optional target of the error
///
/// Used to create a consistent response when there is a internal error
ResponseError toResponseError(Exception sqle,
    {String? context, String? target}) {
  return ResponseError.unknown(
      message: sqle.toString(), context: context, target: target);
}

/// Catches and handles a [Exception] error in a future
///
/// * [future]: The future
/// * [handle]: The error handling function
Future<R> catchSqlError<R extends APIResponse>(Future<R> future,
    R Function(Exception) handle, ShadertoySqliteOptions options) {
  return catchError<R, Exception>(future, handle, options.errorHandling);
}
