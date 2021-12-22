import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// The sync type
enum SyncType {
  /// User
  user,

  /// Shader
  shader,

  /// Comment
  comment,

  /// Playlist
  playlist,

  /// Asset
  asset
}

/// The sync status
enum SyncStatus {
  /// Successfully synchronized
  ok,

  /// Error during synchronization
  error
}

@JsonSerializable()

/// Stores information about a sync operation
class Sync extends Equatable {
  static const defaultSubtype = 'default';

  @JsonKey(name: 'type')

  /// The target type
  final SyncType type;

  @JsonKey(name: 'subType')

  /// The target sub type
  final String subType;

  @JsonKey(name: 'target')

  /// The target
  final String target;

  @JsonKey(name: 'status')

  /// The status of the sync
  final SyncStatus status;

  @JsonKey(name: 'message')

  /// The last sync message
  final String? message;

  @JsonKey(name: 'created')

  /// The first time the target was synced
  final DateTime created;

  @JsonKey(name: 'updated')

  /// The last time the target was synced
  final DateTime updated;

  /// Builds a [Sync]
  ///
  /// * [type]: The target type
  /// * [subType]: The target sub type
  /// * [target]: The target
  /// * [status]: The status of the sync
  /// * [message]: An optional sync message
  /// * [created]: The shader description
  /// * [updated]: The last time the target was synced
  const Sync(
      {required this.type,
      String? subType,
      required this.target,
      required this.status,
      this.message,
      required this.created,
      DateTime? updated})
      : subType = subType ?? defaultSubtype,
        updated = updated ?? created;

  @override
  List<Object?> get props =>
      [type, subType, target, status, message, created, updated];

  /// Builds a copy of a [Sync]
  ///
  /// * [type]: The target type
  /// * [subType]: The target sub type
  /// * [target]: The target
  /// * [status]: The status of the sync
  /// * [message]: An optional sync message
  /// * [created]: The shader description
  /// * [updated]: The last time the target was synced
  Sync copyWith(
      {SyncType? type,
      String? subType,
      String? target,
      SyncStatus? status,
      String? message,
      DateTime? created,
      DateTime? updated}) {
    return Sync(
        type: type ?? this.type,
        subType: subType ?? this.subType,
        target: target ?? this.target,
        status: status ?? this.status,
        message: message ?? this.message,
        created: created ?? this.created,
        updated: updated ?? this.updated);
  }
}
