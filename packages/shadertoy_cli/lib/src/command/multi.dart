import 'base.dart';

/// Provides a base definition of a command that interacts with the
/// Shadertoy http APIs thus needing to either receive the user and password
/// or in alternative the API key for the rest interface
abstract class MultiCommand extends BaseCommand {
  /// Builds an [MultiCommand]
  MultiCommand() {
    argParser
      ..addOption('user', abbr: 'u', help: 'The user', valueHelp: 'user')
      ..addOption('password',
          abbr: 'p', help: 'The password', valueHelp: 'password')
      ..addOption('apiKey',
          abbr: 'k', help: 'The api key', valueHelp: 'apiKey');
  }
}
