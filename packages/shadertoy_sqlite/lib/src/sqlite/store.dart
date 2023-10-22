import 'package:drift/drift.dart';
import 'package:shadertoy_sqlite/src/sqlite/dao/comment_dao.dart';
import 'package:shadertoy_sqlite/src/sqlite/dao/playlist_dao.dart';
import 'package:shadertoy_sqlite/src/sqlite/dao/sync_dao.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/comment_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/playlist_shader_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/playlist_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/shader_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/sync_table.dart';
import 'package:shadertoy_sqlite/src/sqlite_options.dart';

import 'dao/shader_dao.dart';
import 'dao/user_dao.dart';
import 'table/user_table.dart';

part 'store.g.dart';

@DriftDatabase(tables: [
  UserTable,
  ShaderTable,
  CommentTable,
  PlaylistTable,
  PlaylistShaderTable,
  SyncTable
], daos: [
  UserDao,
  ShaderDao,
  CommentDao,
  PlaylistDao,
  SyncDao
])

/// The Drift storage abstraction
class DriftStore extends _$DriftStore {
  /// The current schema version
  static const int _schemaVersion = 1;

  /// The store options
  final ShadertoySqliteOptions storeOptions;

  /// Creates a [DriftStore]
  ///
  /// * [executor]: The selected [QueryExecutor]
  DriftStore(super.executor, this.storeOptions);

  @override
  int get schemaVersion => _schemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      if (storeOptions.foreignKeysEnabled) {
        await customStatement('PRAGMA foreign_keys=ON');
      }
    });
  }
}
