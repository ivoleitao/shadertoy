import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

/// An abstaction for a [ShadertoyClient] command
abstract class ClientCommand<T extends ShadertoyClient> {
  /// Executes a command with the provided [client]
  ///
  /// * [client]: An instance of a [ShadertoyClient]
  void call(T client);
}

/// An abstaction for a [ShadertoyExtendedClient] command
abstract class ExtendedClientCommand
    extends ClientCommand<ShadertoyExtendedClient> {}

/// An abstaction for a [ShadertoyHybrid] command
abstract class HybridCommand extends ClientCommand<ShadertoyHybrid> {}

/// Base Shadertoy command class
abstract class BaseCommand extends Command {
  /// The default json indent
  static const String _defaultJsonIndent = '  ';

  /// Builds a [BaseCommand]
  BaseCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Verbose logging', defaultsTo: false);
  }

  /// Obtains the verbose flag out of the arguments
  /// This flag indicates if the ouput should be detailed or sumarized
  bool get verbose {
    return argResults?['verbose'] ?? false;
  }

  /// Applies [JsonEncoder] to the provided [object] with the specified [indent]
  ///
  /// * [object]: The object to output the json from
  /// * [indent]: The indent value, defaults to '  ' (two spaces)
  String formatJson(Object object, {String indent = _defaultJsonIndent}) {
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(object);
  }

  /// Logs the [message]
  ///
  /// * [message]: The message to log
  void log(String? message) {
    print(message);
  }

  /// Logs the formatted json representation of the [object] with [indent]
  ///
  /// * [object]: The object to output the json from
  /// * [indent]: The indent value, defaults to '  ' (two spaces)
  void logJson(Object object, {String indent = _defaultJsonIndent}) {
    log(formatJson(object, indent: indent));
  }
}
