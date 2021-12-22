import 'package:moor/moor.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/sync_table.dart';

part 'sync_dao.g.dart';

@UseDao(tables: [SyncTable])

/// Sync data access object
class SyncDao extends DatabaseAccessor<MoorStore> with _$SyncDaoMixin {
  /// Creates a [SyncDao]
  ///
  /// * [store]: A pre-initialized [MoorStore] store
  SyncDao(MoorStore store) : super(store);

  /// Converts a [SyncEntry] into a [Sync]
  ///
  /// * [entry]: The entry to convert
  Sync _toEntity(SyncEntry entry) => Sync(
      type: SyncType.values.byName(entry.type),
      subType: entry.subType,
      target: entry.target,
      status: SyncStatus.values.byName(entry.status),
      message: entry.message,
      created: entry.created,
      updated: entry.updated);

  /// Converts a [SyncEntry] into a [Sync] or returns null of [entry] is null
  ///
  /// * [entry]: The entry to convert
  Sync? _toEntityOrNull(SyncEntry? entry) =>
      entry != null ? _toEntity(entry) : null;

  /// Get's the [Sync] with id [type], [subType] and [target]
  ///
  /// * [type]: The type of the sync
  /// * [subType]: The subtype of the sync
  /// * [target]: The target of the sync
  Future<Sync?> findById(SyncType type, String subType, String target) {
    return (select(syncTable)
          ..where((t) =>
              t.type.equals(type.name) &
              t.subType.equals(subType) &
              t.target.equals(target)))
        .getSingleOrNull()
        .then(_toEntityOrNull);
  }

  /// Converts a list of [SyncEntry] into a list of [Sync]
  ///
  /// * [entries]: The list of entries to convert
  List<Sync> _toEntities(List<SyncEntry> entries) {
    return entries.map((entry) => _toEntity(entry)).toList();
  }

  /// Returns all the syncs
  Future<List<Sync>> findAll() {
    return select(syncTable).get().then(_toEntities);
  }

  /// Executes a sync query
  ///
  /// * [type]: The target type
  /// * [subType]: The target sub type
  /// * [target]: The target
  /// * [status]: The status of the sync
  /// * [createdBefore]: Syncs created before this date
  /// * [updatedBefore]: Syncs updated before this date
  Future<List<SyncEntry>> _getSyncQuery(
      {SyncType? type,
      String? subType,
      String? target,
      SyncStatus? status,
      DateTime? createdBefore,
      DateTime? updatedBefore}) {
    final query = select(syncTable);

    final hasType = type != null;
    final hasSubType = subType != null && subType.isNotEmpty;
    final hasTarget = target != null && target.isNotEmpty;
    final hasStatus = status != null;
    final hasCreatedBefore = createdBefore != null;
    final hasUpdatedBefore = updatedBefore != null;
    if (hasType ||
        hasSubType ||
        hasTarget ||
        hasStatus ||
        hasCreatedBefore ||
        hasUpdatedBefore) {
      query.where((entry) {
        Expression<bool?>? exp;

        if (hasType) {
          exp = entry.type.equals(type.name);
        }

        if (hasSubType) {
          final subTypeExp = entry.subType.equals(subType);
          exp = (exp == null ? subTypeExp : exp & subTypeExp);
        }

        if (hasTarget) {
          final targetTypeExp = entry.target.equals(target);
          exp = (exp == null ? targetTypeExp : exp & targetTypeExp);
        }

        if (hasStatus) {
          final statusTypeExp = entry.status.equals(status.name);
          exp = (exp == null ? statusTypeExp : exp & statusTypeExp);
        }

        if (hasCreatedBefore) {
          final hasCreatedBeforeExp =
              entry.created.isSmallerThanValue(createdBefore);
          exp = (exp == null ? hasCreatedBeforeExp : exp & hasCreatedBeforeExp);
        }

        if (hasUpdatedBefore) {
          final hasUpdatedBeforeExp =
              entry.updated.isSmallerThanValue(updatedBefore);
          exp = (exp == null ? hasUpdatedBeforeExp : exp & hasUpdatedBeforeExp);
        }

        return exp!;
      });
    }

    return query.get();
  }

  /// Query syncs
  ///
  /// * [type]: The target type
  /// * [subType]: The target sub type
  /// * [target]: The target
  /// * [status]: The status of the sync
  /// * [createdBefore]: Syncs created before this date
  /// * [updatedBefore]: Syncs updated before this date
  Future<List<Sync>> find(
      {SyncType? type,
      String? subType,
      String? target,
      SyncStatus? status,
      DateTime? createdBefore,
      DateTime? updatedBefore}) {
    return _getSyncQuery(
            type: type,
            subType: subType,
            target: target,
            status: status,
            createdBefore: createdBefore,
            updatedBefore: updatedBefore)
        .then(_toEntities);
  }

  /// Converts a [Sync] into a [SyncEntry]
  ///
  /// * [entity]: The entity to convert
  SyncEntry _toEntry(Sync entity) {
    return SyncEntry(
        type: entity.type.name,
        subType: entity.subType,
        target: entity.target,
        status: entity.status.name,
        message: entity.message,
        created: entity.created,
        updated: entity.updated);
  }

  /// Saves a [Sync]
  ///
  /// * [sync]: The [Sync] to save
  ///
  /// Returns the rowid of the inserted row
  Future<int> save(Sync sync) {
    return into(syncTable)
        .insert(_toEntry(sync), mode: InsertMode.insertOrReplace);
  }

  /// Converts a list of [Sync] into a list of [SyncEntry]
  ///
  /// * [syncs]: The list of [Sync] to convert
  List<SyncEntry> _toSyncEntries(List<Sync> syncs) {
    return syncs.map((sync) => _toEntry(sync)).toList();
  }

  /// Saves a list of [Sync]
  ///
  /// * [syncs]: The list of [Sync] to save
  Future<void> saveAll(List<Sync> syncs) {
    return batch((b) => b.insertAll(syncTable, _toSyncEntries(syncs),
        mode: InsertMode.insertOrReplace));
  }

  /// Deletes a [Sync] by [type], [subType] and [target]
  ///
  /// * [type]: The type of the sync
  /// * [subType]: The subtype of the sync
  /// * [target]: The target of the sync
  Future<void> deleteById(SyncType type, String subType, String target) {
    return (delete(syncTable)
          ..where((t) =>
              t.type.equals(type.name) &
              t.subType.equals(subType) &
              t.target.equals(target)))
        .go();
  }
}
