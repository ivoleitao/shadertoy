import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

import 'base.dart';
import 'multi.dart';

/// Provides a base definition of a command that interacts with a
/// shadertoy http or store client
abstract class ExtendedCommand extends MultiCommand
    implements ExtendedClientCommand {
  /// Builds an [ExtendedCommand]
  ExtendedCommand() {
    argParser.addOption('file',
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
