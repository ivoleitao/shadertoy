// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dao.dart';

// ignore_for_file: type=lint
mixin _$CommentDaoMixin on DatabaseAccessor<DriftStore> {
  $ShaderTableTable get shaderTable => attachedDatabase.shaderTable;
  $CommentTableTable get commentTable => attachedDatabase.commentTable;
  $SyncTableTable get syncTable => attachedDatabase.syncTable;
  Selectable<String> commentId() {
    return customSelect('SELECT id FROM Comment', variables: [], readsFrom: {
      commentTable,
    }).map((QueryRow row) => row.read<String>('id'));
  }
}
