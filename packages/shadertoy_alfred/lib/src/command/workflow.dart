import 'dart:io' show exitCode, stderr;

import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:args/command_runner.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:shadertoy_alfred/src/constants/config.dart';

class _StderrConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      stderr.writeln(line);
    }
  }
}

/// Base workflow command class
abstract class WorkflowCommand extends Command {
  final logger = Logger(
      filter: ProductionFilter(),
      printer: SimplePrinter(),
      output: _StderrConsoleOutput());

  /// The updater instance
  final AlfredUpdater updater = AlfredUpdater(
      githubRepositoryUrl: Config.repository,
      currentVersion: Config.version,
      updateInterval: Config.updateInterval);

  /// Builds a [WorkflowCommand]
  WorkflowCommand() {
    argParser
      ..addFlag('verbose',
          abbr: 'v', help: 'Verbose logging', defaultsTo: false)
      ..addFlag('update', abbr: 'u', defaultsTo: true);
  }

  /// Obtains the verbose flag out of the arguments
  /// This flag indicates if the ouput should be detailed or sumarized
  bool get verbose {
    return argResults?['verbose'] ?? false;
  }

  @protected
  AlfredWorkflow init() {
    Logger.level = verbose ? Level.debug : Level.info;
    logger.d('Initializing workflow with:');
    logger.d('\tCurrent Version:${Config.version}');
    logger.d('\tUpdate repository:${Config.repository}');
    logger.d('\tUpdate Interval:${Config.updateInterval}');
    return AlfredWorkflow();
  }

  @protected
  Future<void> prepareWorflow(AlfredWorkflow workflow) {
    exitCode = 0;
    workflow.clearItems();

    return Future.value();
  }

  @protected
  Future<void> runWorkflow(AlfredWorkflow workflow) {
    return Future.value();
  }

  @protected
  void fail(AlfredWorkflow workflow, int errorCode, String message) {
    logger.e('Error ($errorCode): $message');
    exitCode = errorCode;
    workflow.addItem(AlfredItem(title: message));
  }

  @override
  void run() async {
    final workflow = init();

    try {
      await prepareWorflow(workflow);
    } on FormatException catch (err) {
      fail(workflow, 2, err.toString());
    } catch (err) {
      fail(workflow, 1, err.toString());
      if (verbose) rethrow;
    } finally {
      await runWorkflow(workflow);
    }
  }
}
