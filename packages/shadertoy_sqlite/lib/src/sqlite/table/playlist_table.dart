import 'package:drift/drift.dart';

@DataClassName('PlaylistEntry')

/// The playlist table
class PlaylistTable extends Table {
  @override
  String get tableName => 'Playlist';

  /// The id of the playlist
  TextColumn get id => text()();

  /// The id of the user that created the playlist
  TextColumn get userId => text()();

  /// The name of the playlist
  TextColumn get name => text()();

  /// The description of the playlist
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}
