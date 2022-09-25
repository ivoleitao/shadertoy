/// Shadertoy sqlite storage.
///
/// Provides an implementation of the Shadertoy storage API based on the drift package
library shadertoy_sqlite;

import 'package:drift/drift.dart';
import 'package:shadertoy/shadertoy_api.dart';
// Use a conditional import to expose the right backend depending
// on the platform.
import 'package:shadertoy_sqlite/src/sqlite/backend/unsupported.dart'
    if (dart.library.js) 'package:shadertoy_sqlite/src/sqlite/backend/web.dart'
    if (dart.library.ffi) 'package:shadertoy_sqlite/src/sqlite/backend/native.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';
import 'package:shadertoy_sqlite/src/sqlite_store.dart';

export 'src/sqlite_options.dart';
export 'src/sqlite_store.dart';

DriftStore _newStore(QueryExecutor executor, ShadertoySqliteOptions options) {
  return DriftStore(executor, options);
}

/// Creates a [ShadertoyStore] backed by a in-memory [ShadertoySqliteStore]
///
/// * [foreignKeysEnabled]: If the foreign keys are enabled
/// * [logStatementsEnabled]: If true (defaults to `false`), generated sql statements will be printed before executing.
/// * [webBackend]: The web backend to use
/// * [sqliteWasmPath]: The sqlite wasm path for the wasm backend
/// * [shaderCount]: The number of shaders requested for a paged call
/// * [userShaderCount]: The number of shaders requested for a user paged call
/// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
/// * [errorHandling]: The error handling mode
Future<ShadertoyStore> newShadertoySqliteMemoryStore(
    {bool? foreignKeysEnabled,
    bool? logStatementsEnabled,
    WebBackend? webBackend,
    String? sqliteWasmPath,
    int? shaderCount,
    int? userShaderCount,
    int? playlistShaderCount,
    ErrorMode? errorHandling}) {
  final options = getOptions(
      foreignKeysEnabled: foreignKeysEnabled,
      logStatementsEnabled: logStatementsEnabled,
      webBackend: webBackend,
      sqliteWasmPath: sqliteWasmPath,
      shaderCount: shaderCount,
      userShaderCount: userShaderCount,
      playlistShaderCount: playlistShaderCount,
      errorHandling: errorHandling);

  return memoryExecutor(options)
      .then((executor) => _newStore(executor, options))
      .then((store) => ShadertoySqliteStore(store, options));
}

/// Creates a [ShadertoyStore] backed by a local [ShadertoySqliteStore]
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
Future<ShadertoyStore> newShadertoySqliteLocalStore(
    {String? path,
    bool? foreignKeysEnabled,
    bool? logStatementsEnabled,
    WebBackend? webBackend,
    String? sqliteWasmPath,
    int? shaderCount,
    int? userShaderCount,
    int? playlistShaderCount,
    ErrorMode? errorHandling}) async {
  final options = getOptions(
      path: path,
      foreignKeysEnabled: foreignKeysEnabled,
      logStatementsEnabled: logStatementsEnabled,
      webBackend: webBackend,
      sqliteWasmPath: sqliteWasmPath,
      shaderCount: shaderCount,
      userShaderCount: userShaderCount,
      playlistShaderCount: playlistShaderCount,
      errorHandling: errorHandling);

  return localExecutor(options)
      .then((executor) => _newStore(executor, options))
      .then((store) => ShadertoySqliteStore(store, options));
}
