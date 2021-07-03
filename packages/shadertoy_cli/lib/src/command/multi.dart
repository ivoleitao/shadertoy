import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

import 'base.dart';

abstract class MultiCommand extends BaseCommand
    implements ExtendedClientCommand {
  MultiCommand() {
    argParser
      ..addOption('user', abbr: 'u', help: 'The user', valueHelp: 'user')
      ..addOption('password',
          abbr: 'p', help: 'The password', valueHelp: 'password')
      ..addOption('apiKey', abbr: 'k', help: 'The api key', valueHelp: 'apiKey')
      ..addOption('file',
          abbr: 'f', help: 'The database location', valueHelp: 'file');
  }

  @override
  void run() {
    final user = argResults?['user'];
    final password = argResults?['password'];
    final apiKey = argResults?['apiKey'];
    final dbPath = argResults?['file'];

    ShadertoyExtendedClient client;
    if (dbPath != null) {
      client = newShadertoySqliteStore(
          VmDatabase(File(dbPath), logStatements: verbose));
    } else {
      client = newShadertoyHybridClient(
          apiKey: apiKey, user: user, password: password);
    }

    return call(client);
  }
}
