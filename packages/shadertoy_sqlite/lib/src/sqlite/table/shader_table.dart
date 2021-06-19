import 'package:moor/moor.dart';

@DataClassName('ShaderEntry')

/// The shader table
class ShaderTable extends Table {
  @override
  String get tableName => 'Shader';

  /// The id of the shader
  TextColumn get id => text()();

  /// The id of the user that created this shader
  TextColumn get userId => text()();

  /// The version of this shader
  TextColumn get version => text()();

  /// The name of the shader
  TextColumn get name => text()();

  /// The date this shader was published
  DateTimeColumn get date => dateTime()();

  /// A description of the shader
  TextColumn get description => text().nullable()();

  /// The number of views this shader had
  IntColumn get views => integer().withDefault(Constant(0))();

  /// The number of likes this shader had
  IntColumn get likes => integer().withDefault(Constant(0))();

  /// The privacy of this shader
  TextColumn get privacy => text()();

  /// The flags of this shader
  IntColumn get flags => integer().withDefault(Constant(0))();

  /// A json list of the tags of this shader
  TextColumn get tagsJson => text().withDefault(Constant('[]'))();

  /// The render passses in json
  TextColumn get renderPassesJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}
