import 'package:shadertoy_client/shadertoy_client.dart';

import 'base.dart';

/// Provides a base definition of a command that interacts with a
/// shadertoy ws client
abstract class WSCommand extends BaseCommand implements WSClientCommand {
  /// Builds an [WSCommand]
  WSCommand() {
    argParser.addOption('apiKey',
        abbr: 'k', help: 'The api key', valueHelp: 'apiKey');
  }

  @override
  void run() {
    final String? apiKey = argResults?['apiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      runner?.printUsage();
      return;
    }

    return call(newShadertoyWSClient(apiKey));
  }
}
