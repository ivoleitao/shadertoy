import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

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
  ShadertoyStore newStore(String path) {
    return newShadertoySqliteStore(file: File(path), logStatements: verbose);
  }

  @override
  Vault<Uint8List> newVault(String path) {
    final file = File(path);
    final name = p.basenameWithoutExtension(path);

    return newSqliteLocalVaultStore(file: file).vault<Uint8List>(name: name);
  }
}
