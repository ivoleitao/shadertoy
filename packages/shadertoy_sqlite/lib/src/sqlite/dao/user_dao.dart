import 'package:drift/drift.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/sync_table.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/user_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(
    tables: [UserTable, SyncTable], queries: {'userId': 'SELECT id FROM User'})

/// User data access object
class UserDao extends DatabaseAccessor<DriftStore> with _$UserDaoMixin {
  /// Creates a [UserDao]
  ///
  /// * [store]: A pre-initialized [DriftStore] store
  UserDao(super.store);

  /// Converts a [UserEntry] into a [User]
  ///
  /// * [entry]: The entry to convert
  User _toEntity(UserEntry entry) => User(
      id: entry.id,
      picture: entry.picture,
      memberSince: entry.memberSince,
      following: entry.following,
      followers: entry.followers,
      about: entry.about);

  /// Converts a [UserEntry] into a [User] or returns null of [entry] is null
  ///
  /// * [entry]: The entry to convert
  User? _toEntityOrNull(UserEntry? entry) =>
      entry != null ? _toEntity(entry) : null;

  /// Get's the [User] with id [userId]
  ///
  /// * [userId]: The id of the user
  Future<User?> findById(String userId) {
    return (select(userTable)..where((t) => t.id.equals(userId)))
        .getSingleOrNull()
        .then(_toEntityOrNull);
  }

  /// Returns all the user ids
  Future<List<String>> findAllIds() {
    return userId().get();
  }

  /// Converts a list of [UserEntry] into a list of [User]
  ///
  /// * [entries]: The list of entries to convert
  List<User> _toEntities(List<UserEntry> entries) {
    return entries.map((entry) => _toEntity(entry)).toList();
  }

  /// Returns all the users
  Future<List<User>> findAll() {
    return select(userTable).get().then(_toEntities);
  }

  /// Converts a [User] into a [UserEntry]
  ///
  /// * [entity]: The entity to convert
  UserEntry _toEntry(User entity) {
    return UserEntry(
        id: entity.id,
        picture: entity.picture,
        memberSince: entity.memberSince,
        following: entity.following,
        followers: entity.followers,
        about: entity.about);
  }

  /// Saves a [User]
  ///
  /// * [user]: The [User] to save
  ///
  /// Returns the rowid of the inserted row
  Future<int> save(User user) {
    return into(userTable)
        .insert(_toEntry(user), mode: InsertMode.insertOrReplace);
  }

  /// Converts a list of [User] into a list of [UserEntry]
  ///
  /// * [users]: The list of [User] to convert
  List<UserEntry> _toUserEntries(List<User> users) {
    return users.map((user) => _toEntry(user)).toList();
  }

  /// Saves a list of [User]
  ///
  /// * [users]: The list of [User] to save
  Future<void> saveAll(List<User> users) {
    return batch((b) => b.insertAll(userTable, _toUserEntries(users),
        mode: InsertMode.insertOrReplace));
  }

  /// Deletes a [User] by [userId]
  ///
  /// * [userId]: The id of the [User]
  Future<void> deleteById(String userId) {
    return transaction(() async {
      // Delete any sync reference
      await (delete(syncTable)
            ..where((sync) =>
                sync.type.equals(SyncType.user.name) &
                sync.target.equals(userId)))
          .go();

      // Delete the user
      await (delete(userTable)..where((user) => user.id.equals(userId))).go();
    });
  }
}
