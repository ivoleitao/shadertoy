import 'package:drift/drift.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/shader_table.dart';

@DataClassName('CommentEntry')

/// The comments per user and shader table
class CommentTable extends Table {
  @override
  String get tableName => 'Comment';

  /// The comment id
  TextColumn get id => text()();

  /// The shader id
  TextColumn get shaderId =>
      text().references(ShaderTable, #id, onDelete: KeyAction.cascade)();

  /// The user id
  TextColumn get userId => text()();

  /// An optional user picture
  TextColumn get picture => text().nullable()();

  /// The date/time of the comment
  DateTimeColumn get date => dateTime()();

  /// The comment
  TextColumn get comment => text()();

  /// If this comment should be not appear
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
