import 'package:moor/moor.dart';

@DataClassName('PlaylistShaderEntry')

/// And associative table between playlist and shader
class PlaylistShaderTable extends Table {
  @override
  String get tableName => 'PlaylistShader';

  /// The playlist id
  TextColumn get playlistId => text()
      .customConstraint('NOT NULL REFERENCES Playlist(id) ON DELETE CASCADE')();

  /// The shader id
  TextColumn get shaderId => text()
      .customConstraint('NOT NULL REFERENCES Shader(id) ON DELETE CASCADE')();

  /// The order of the shader on the playlist
  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {playlistId, shaderId};
}
