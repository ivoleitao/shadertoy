import 'package:shadertoy/shadertoy_api.dart';

import 'multi.dart';

class PlaylistCommand extends MultiCommand {
  @override
  final name = 'playlist';
  @override
  final description = 'Gets one or more playlists by id';

  PlaylistCommand() {
    argParser.addMultiOption('ids',
        abbr: 'i', help: 'The id(s) of the playlist', valueHelp: 'ids');
  }

  @override
  void call(ShadertoyExtendedClient client) async {
    final List<String>? ids = argResults?['ids'];

    if (ids == null || ids.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final results =
        await Future.wait(ids.map((id) => client.findPlaylistById(id)));
    for (var pr in results) {
      final playlist = pr.playlist;
      if (playlist != null) {
        logJson(playlist.toJson());
      }
    }
  }
}
