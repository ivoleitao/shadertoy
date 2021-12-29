// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CommentDaoMixin on DatabaseAccessor<DriftStore> {
  $CommentTableTable get commentTable => attachedDatabase.commentTable;
  $SyncTableTable get syncTable => attachedDatabase.syncTable;
  Selectable<String> commentId() {
    return customSelect('SELECT id FROM Comment', variables: [], readsFrom: {
      commentTable,
    }).map((QueryRow row) => row.read<String>('id'));
  }
}
