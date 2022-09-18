import 'dart:io';

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
  Future<ShadertoyStore> newMetadataStore(String path) {
    return newShadertoySqliteLocalStore(
        path: path, logStatementsEnabled: verbose);
  }

  @override
  Future<VaultStore> newAssetStore(String path) {
    return newSqliteLocalVaultStore(file: File(path));
  }
}
