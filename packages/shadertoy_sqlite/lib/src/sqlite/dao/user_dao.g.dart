// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$UserDaoMixin on DatabaseAccessor<MoorStore> {
  $UserTableTable get userTable => attachedDatabase.userTable;
  Selectable<String> userId() {
    return customSelect('SELECT id FROM User',
        variables: [],
        readsFrom: {userTable}).map((QueryRow row) => row.read<String>('id'));
  }
}
