import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

abstract class ClientCommand<T extends ShadertoyClient> {
  void call(T client);
}

abstract class ExtendedClientCommand
    extends ClientCommand<ShadertoyExtendedClient> {}

abstract class HybridCommand extends ClientCommand<ShadertoyHybrid> {}

abstract class BaseCommand extends Command {
  static const String _defaultJsonIndent = '  ';

  BaseCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Verbose logging', defaultsTo: false);
  }

  bool get verbose {
    return argResults?['verbose'] ?? false;
  }

  String formatJson(Object object, {String indent = _defaultJsonIndent}) {
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(object);
  }

  void log(String? message) {
    print(message);
  }

  void logJson(Object object, {String indent = _defaultJsonIndent}) {
    log(formatJson(object, indent: indent));
  }
}
