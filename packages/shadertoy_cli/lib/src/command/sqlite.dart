import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

import 'database.dart';

/// Command to scrape shadertoy data from the rest and site API into a SQLite database
class SqliteCommand extends DatabaseCommand {
  @override
  final name = 'sqlite';
  @override
  final description = 'Scrapes shaders to a sqlite database';

  /// Builds a [SqliteCommand]
  SqliteCommand();

  @override
  ShadertoyStore newStore(String dbPath) {
    return newShadertoySqliteStore(
        VmDatabase(File(dbPath), logStatements: verbose));
  }
}
