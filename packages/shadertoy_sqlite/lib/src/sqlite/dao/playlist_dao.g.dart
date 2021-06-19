// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PlaylistDaoMixin on DatabaseAccessor<MoorStore> {
  $PlaylistTableTable get playlistTable => attachedDatabase.playlistTable;
  $PlaylistShaderTableTable get playlistShaderTable =>
      attachedDatabase.playlistShaderTable;
  Selectable<String> playlistId() {
    return customSelect('SELECT id FROM Playlist',
            variables: [], readsFrom: {playlistTable})
        .map((QueryRow row) => row.read<String>('id'));
  }
}
