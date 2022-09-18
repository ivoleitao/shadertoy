import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

Future<QueryExecutor> memoryExecutor(ShadertoySqliteOptions options) async {
  return Future.value(
      NativeDatabase.memory(logStatements: options.logStatementsEnabled));
}

Future<QueryExecutor> localExecutor(ShadertoySqliteOptions options) {
  return Future.value(NativeDatabase(File(options.path),
      logStatements: options.logStatementsEnabled));
}

/// Converts a [SqliteException] to a [ResponseError]
///
/// * [sqle]: The [SqliteException]
/// * [context]: The optional context of the error
/// * [target]: The optional target of the error
///
/// Used to create a consistent response when there is a internal error
ResponseError toResponseError(SqliteException sqle,
    {String? context, String? target}) {
  // ignore: unused_local_variable
  const int sqliteAbort = 4;
  // ignore: unused_local_variable
  const int sqliteAuth = 23;
  // ignore: unused_local_variable
  const int sqliteBusy = 5;
  // ignore: unused_local_variable
  const int sqliteCantopen = 14;
  // ignore: unused_local_variable
  const int sqliteConstraint = 19;
  // ignore: unused_local_variable
  const int sqliteCorrupt = 11;
  // ignore: unused_local_variable
  const int sqliteDone = 101;
  // ignore: unused_local_variable
  const int sqliteEmpty = 16;
  // ignore: unused_local_variable
  const int sqliteError = 1;
  // ignore: unused_local_variable
  const int sqliteFormat = 24;
  // ignore: unused_local_variable
  const int sqliteFull = 13;
  // ignore: unused_local_variable
  const int sqliteInternal = 2;
  // ignore: unused_local_variable
  const int sqliteInterrupt = 9;
  // ignore: unused_local_variable
  const int sqliteIoerr = 10;
  // ignore: unused_local_variable
  const int sqliteLocked = 6;
  // ignore: unused_local_variable
  const int sqliteMismatch = 20;
  // ignore: unused_local_variable
  const int sqliteMisuse = 21;
  // ignore: unused_local_variable
  const int sqliteNolfs = 22;
  // ignore: unused_local_variable
  const int sqliteNomem = 7;
  // ignore: unused_local_variable
  const int sqliteNotadb = 26;
  // ignore: unused_local_variable
  const int sqliteNotfound = 12;
  // ignore: unused_local_variable
  const int sqliteNotice = 27;
  // ignore: unused_local_variable
  const int sqliteOk = 0;
  // ignore: unused_local_variable
  const int sqlitePerm = 3;
  // ignore: unused_local_variable
  const int sqliteProtocol = 15;
  // ignore: unused_local_variable
  const int sqliteRange = 25;
  // ignore: unused_local_variable
  const int sqliteReadonly = 8;
  // ignore: unused_local_variable
  const int sqliteRow = 100;
  // ignore: unused_local_variable
  const int sqliteSchema = 17;
  // ignore: unused_local_variable
  const int sqliteToobig = 18;
  // ignore: unused_local_variable
  const int sqliteWarning = 28;
  // ignore: unused_local_variable
  const int sqliteAbortRollback = 516;
  // ignore: unused_local_variable
  const int sqliteBusyRecovery = 261;
  // ignore: unused_local_variable
  const int sqliteBusySnapshot = 517;
  // ignore: unused_local_variable
  const int sqliteBusyTimeout = 773;
  // ignore: unused_local_variable
  const int sqliteCantopenConvpath = 1038;
  // ignore: unused_local_variable
  const int sqliteCantopenDirtywal = 1294;
  // ignore: unused_local_variable
  const int sqliteCantopenFullpath = 782;
  // ignore: unused_local_variable
  const int sqliteCantopenIsdir = 526;
  // ignore: unused_local_variable
  const int sqliteCantopenNotempdir = 270;
  // ignore: unused_local_variable
  const int sqliteCantopenSymlink = 1550;
  // ignore: unused_local_variable
  const int sqliteConstraintCheck = 275;
  // ignore: unused_local_variable
  const int sqliteConstraintCommithook = 531;
  // ignore: unused_local_variable
  const int sqliteConstraintForeignkey = 787;
  // ignore: unused_local_variable
  const int sqliteConstraintFunction = 1043;
  // ignore: unused_local_variable
  const int sqliteConstraintNotnull = 1299;
  // ignore: unused_local_variable
  const int sqliteConstraintPinned = 2835;
  // ignore: unused_local_variable
  const int sqliteConstraintPrimarykey = 1555;
  // ignore: unused_local_variable
  const int sqliteConstraintRowid = 2579;
  // ignore: unused_local_variable
  const int sqliteConstraintTrigger = 1811;
  // ignore: unused_local_variable
  const int sqliteConstraintUnique = 2067;
  // ignore: unused_local_variable
  const int sqliteConstraintVtab = 2323;
  // ignore: unused_local_variable
  const int sqliteCorruptIndex = 779;
  // ignore: unused_local_variable
  const int sqliteCorruptSequence = 523;
  // ignore: unused_local_variable
  const int sqliteCorruptVtab = 267;
  // ignore: unused_local_variable
  const int sqliteErrorMissingCollseq = 257;
  // ignore: unused_local_variable
  const int sqliteErrorRetry = 513;
  // ignore: unused_local_variable
  const int sqliteErrorSnapshot = 769;
  // ignore: unused_local_variable
  const int sqliteIoerrAccess = 3338;
  // ignore: unused_local_variable
  const int sqliteIoerrAuth = 7178;
  // ignore: unused_local_variable
  const int sqliteIoerrBeginAtomic = 7434;
  // ignore: unused_local_variable
  const int sqliteIoerrBlocked = 2826;
  // ignore: unused_local_variable
  const int sqliteIoerrCheckreservedlock = 3594;
  // ignore: unused_local_variable
  const int sqliteIoerrClose = 4106;
  // ignore: unused_local_variable
  const int sqliteIoerrCommitAtomic = 7690;
  // ignore: unused_local_variable
  const int sqliteIoerrConvpath = 6666;
  // ignore: unused_local_variable
  const int sqliteIoerrData = 8202;
  // ignore: unused_local_variable
  const int sqliteIoerrDelete = 2570;
  // ignore: unused_local_variable
  const int sqliteIoerrDeleteNoent = 5898;
  // ignore: unused_local_variable
  const int sqliteIoerrDirClose = 4362;
  // ignore: unused_local_variable
  const int sqliteIoerrDirFsync = 1290;
  // ignore: unused_local_variable
  const int sqliteIoerrFstat = 1802;
  // ignore: unused_local_variable
  const int sqliteIoerrFsync = 1034;
  // ignore: unused_local_variable
  const int sqliteIoerrFettemppath = 6410;
  // ignore: unused_local_variable
  const int sqliteIoerrLock = 3850;
  // ignore: unused_local_variable
  const int sqliteIoerrMmap = 6154;
  // ignore: unused_local_variable
  const int sqliteIoerrNomem = 308;
  // ignore: unused_local_variable
  const int sqliteIoerrRdlock = 231;
  // ignore: unused_local_variable
  const int sqliteIoerrRead = 266;
  // ignore: unused_local_variable
  const int sqliteIoerrRollbackAtomic = 7946;
  // ignore: unused_local_variable
  const int sqliteIoerrSeek = 5642;
  // ignore: unused_local_variable
  const int sqliteIoerrShmlock = 5130;
  // ignore: unused_local_variable
  const int sqliteIoerrShmmap = 5386;
  // ignore: unused_local_variable
  const int sqliteIoerrShmopen = 4618;
  // ignore: unused_local_variable
  const int sqliteIoerrShmsize = 4874;
  // ignore: unused_local_variable
  const int sqliteIoerrShortRead = 522;
  // ignore: unused_local_variable
  const int sqliteIoerrTruncate = 1546;
  // ignore: unused_local_variable
  const int sqliteIoerrUnlock = 2058;
  // ignore: unused_local_variable
  const int sqliteIoerrVnode = 6922;
  // ignore: unused_local_variable
  const int sqliteIoerrWrite = 778;
  // ignore: unused_local_variable
  const int sqliteLockedSharedcache = 262;

  if (sqle.resultCode == sqliteAuth) {
    return ResponseError.authorization(
        message: sqle.message, context: context, target: target);
  } else if (sqle.extendedResultCode == sqliteBusyTimeout) {
    return ResponseError.backendTimeout(
        message: sqle.message, context: context, target: target);
  } else if (sqle.resultCode == sqliteAbort ||
      sqle.extendedResultCode == sqliteAbortRollback) {
    return ResponseError.aborted(
        message: sqle.message, context: context, target: target);
  } else if (sqle.extendedResultCode == sqliteConstraintPrimarykey ||
      sqle.extendedResultCode == sqliteConstraintUnique ||
      sqle.extendedResultCode == sqliteConstraintRowid) {
    return ResponseError.conflict(
        message: sqle.message, context: context, target: target);
  } else if (sqle.resultCode == sqliteConstraint ||
      sqle.extendedResultCode == sqliteConstraintCheck ||
      sqle.extendedResultCode == sqliteConstraintNotnull ||
      sqle.extendedResultCode == sqliteConstraintForeignkey) {
    return ResponseError.unprocessableEntity(
        message: sqle.message, context: context, target: target);
  }

  return ResponseError.unknown(
      message: sqle.message, context: context, target: target);
}

/// Catches and handles a [SqliteException] error in a future
///
/// * [future]: The future
/// * [handle]: The error handling function
Future<R> catchSqlError<R extends APIResponse>(Future<R> future,
    R Function(SqliteException) handle, ShadertoySqliteOptions options) {
  return catchError<R, SqliteException>(future, handle, options.errorHandling);
}
