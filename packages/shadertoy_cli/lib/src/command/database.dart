import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

import 'sync.dart';

abstract class DatabaseCommand extends SyncCommand {
  DatabaseCommand() {
    argParser
      ..addOption('path',
          abbr: 'f',
          help: 'The target path',
          valueHelp: 'path',
          defaultsTo: '.')
      ..addOption('name',
          abbr: 'n',
          help: 'The database name',
          valueHelp: 'name',
          defaultsTo: 'shadertoy')
      ..addMultiOption('shader',
          abbr: 's', help: 'The id(s) of the shader(s)', valueHelp: 'id')
      ..addMultiOption('playlist',
          abbr: 'l',
          help: 'The id(s) of the playlist(s)',
          valueHelp: 'id',
          defaultsTo: ['week', 'featured']);
  }

  ShadertoyStore newStore(String dbPath);

  @override
  void call(ShadertoyHybrid client) async {
    final String fsPath = argResults?['path'];
    final String name = argResults?['name'];
    final List<String> shaderIds = argResults?['shader'];
    final List<String> playlistIds = argResults?['playlist'];

    final String concurrencyArg = argResults?['concurrency'];
    final concurrency = int.tryParse(concurrencyArg);
    if (concurrency == null || concurrency < 1) {
      runner?.usageException('Invalid concurrency value \'$concurrencyArg\'');
      return;
    }

    final String timeoutArg = argResults?['timeout'];
    final timeout = int.tryParse(timeoutArg);
    if (timeout == null || timeout < 1) {
      runner?.usageException('Invalid timeout value \'$timeoutArg\'');
      return null;
    }

    final store = newStore(p.join(fsPath, '$name.sdb'));
    final fs = LocalFileSystem();
    final dir = fs.directory(fsPath)..createSync(recursive: true);
    client.rsync(store,
        fs: fs,
        dir: dir,
        runner: this,
        concurrency: concurrency,
        timeout: timeout,
        shaderIds: shaderIds,
        playlistIds: playlistIds);
  }
}
