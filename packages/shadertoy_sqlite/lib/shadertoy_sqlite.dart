/// Shadertoy sqlite storage.
///
/// Provides an implementation of the Shadertoy storage API based on the drift package
library shadertoy_sqlite;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';
import 'package:shadertoy_sqlite/src/sqlite_store.dart';

export 'src/sqlite_options.dart';
export 'src/sqlite_store.dart';

QueryExecutor _memoryExecutor(bool logStatements) {
  return NativeDatabase.memory(logStatements: logStatements);
}

QueryExecutor _localExecutor(File file, bool logStatements) {
  return NativeDatabase(file, logStatements: logStatements);
}

DriftStore _newStore(QueryExecutor executor) {
  return DriftStore(executor);
}

/// Creates a [ShadertoyStore] backed by a [ShadertoySqliteStore]
///
/// * [file]: The file, if not provided a in memory store is returned
/// * [shaderCount]: The number of shaders requested for a paged call
/// * [userShaderCount]: The number of shaders requested for a user paged call
/// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
/// * [errorHandling]: The error handling mode
ShadertoyStore newShadertoySqliteStore(
    {File? file,
    int? shaderCount,
    int? userShaderCount,
    int? playlistShaderCount,
    ErrorMode? errorHandling,
    bool logStatements = false}) {
  return ShadertoySqliteStore(
      _newStore(file != null
          ? _localExecutor(file, logStatements)
          : _memoryExecutor(logStatements)),
      ShadertoySqliteOptions(
          shaderCount: shaderCount,
          userShaderCount: userShaderCount,
          playlistShaderCount: playlistShaderCount,
          errorHandling: errorHandling));
}
