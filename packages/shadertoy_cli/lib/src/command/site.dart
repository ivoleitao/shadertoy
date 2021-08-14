import 'package:shadertoy_client/shadertoy_client.dart';

import 'base.dart';

/// Provides a base definition of a command that interacts with a
/// shadertoy site client
abstract class SiteCommand extends BaseCommand implements SiteClientCommand {
  /// Builds an [SiteCommand]
  SiteCommand() {
    argParser
      ..addOption('user', abbr: 'u', help: 'The user', valueHelp: 'user')
      ..addOption('password',
          abbr: 'p', help: 'The password', valueHelp: 'password');
  }

  @override
  void run() {
    final String? user = argResults?['user'];
    final String? password = argResults?['password'];

    return call(newShadertoySiteClient(user: user, password: password));
  }
}
