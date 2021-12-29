// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shader_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ShaderDaoMixin on DatabaseAccessor<DriftStore> {
  $ShaderTableTable get shaderTable => attachedDatabase.shaderTable;
  $PlaylistTableTable get playlistTable => attachedDatabase.playlistTable;
  $PlaylistShaderTableTable get playlistShaderTable =>
      attachedDatabase.playlistShaderTable;
  $SyncTableTable get syncTable => attachedDatabase.syncTable;
  Selectable<String> shaderId() {
    return customSelect('SELECT id FROM Shader', variables: [], readsFrom: {
      shaderTable,
    }).map((QueryRow row) => row.read<String>('id'));
  }
}
