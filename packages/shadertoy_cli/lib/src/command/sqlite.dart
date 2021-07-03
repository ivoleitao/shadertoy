import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

import 'database.dart';

class SqliteCommand extends DatabaseCommand {
  @override
  final name = 'sqlite';
  @override
  final description = 'Scrapes shaders to a sqlite database';

  SqliteCommand();

  @override
  ShadertoyStore newStore(String dbPath) {
    return newShadertoySqliteStore(
        VmDatabase(File(dbPath), logStatements: verbose));
  }
}
