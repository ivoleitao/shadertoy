import 'package:moor/moor.dart';

@DataClassName('UserEntry')

/// The user table
class UserTable extends Table {
  @override
  String get tableName => 'User';

  /// The user id
  TextColumn get id => text()();

  /// The user picture.
  TextColumn get picture => text().nullable()();

  /// The registration date of the user
  DateTimeColumn get memberSince => dateTime()();

  /// The number of followed users
  IntColumn get following => integer().withDefault(Constant(0))();

  /// The number of followers
  IntColumn get followers => integer().withDefault(Constant(0))();

  /// Abouth this user
  TextColumn get about => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
