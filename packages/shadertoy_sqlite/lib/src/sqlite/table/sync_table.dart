import 'package:drift/drift.dart';

@DataClassName('SyncEntry')

/// The sync table
class SyncTable extends Table {
  @override
  String get tableName => 'Sync';

  /// The type
  TextColumn get type => text()();

  /// The sub type
  TextColumn get subType => text()();

  /// The target
  TextColumn get target => text()();

  /// The status.
  TextColumn get status => text()();

  /// The message.
  TextColumn get message => text().nullable()();

  /// The creation time
  DateTimeColumn get created => dateTime()();

  /// The update time
  DateTimeColumn get updated => dateTime()();

  @override
  Set<Column> get primaryKey => {type, subType, target};
}
