import 'package:drift/drift.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/playlist_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/shader_table.dart';

@DataClassName('PlaylistShaderEntry')

/// And associative table between playlist and shader
class PlaylistShaderTable extends Table {
  @override
  String get tableName => 'PlaylistShader';

  /// The playlist id
  TextColumn get playlistId =>
      text().references(PlaylistTable, #id, onDelete: KeyAction.cascade)();

  /// The shader id
  TextColumn get shaderId =>
      text().references(ShaderTable, #id, onDelete: KeyAction.cascade)();

  /// The order of the shader on the playlist
  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {playlistId, shaderId};
}
