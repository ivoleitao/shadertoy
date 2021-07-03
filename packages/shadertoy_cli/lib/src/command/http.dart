import 'package:shadertoy_client/shadertoy_client.dart';

import 'base.dart';

abstract class HttpCommand extends BaseCommand implements HybridCommand {
  HttpCommand() {
    argParser
      ..addOption('user', abbr: 'u', help: 'The user', valueHelp: 'user')
      ..addOption('password',
          abbr: 'p', help: 'The password', valueHelp: 'password')
      ..addOption('apiKey',
          abbr: 'k', help: 'The api key', valueHelp: 'apiKey');
  }

  @override
  void run() {
    final user = argResults?['user'];
    final password = argResults?['password'];
    final apiKey = argResults?['apiKey'];

    return call(newShadertoyHybridClient(
        apiKey: apiKey, user: user, password: password));
  }
}
