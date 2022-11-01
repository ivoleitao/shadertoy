import 'dart:io' show exitCode;

import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:shadertoy_alfred/src/constant/config.dart';
import 'package:shadertoy_alfred/src/constant/constants.dart';

/// Base workflow command class
abstract class WorkflowCommand extends Command {
  /// The updater instance
  final AlfredUpdater updater = AlfredUpdater(
      githubRepositoryUrl: Constants.repository,
      currentVersion: Constants.version,
      updateInterval: Config.updateInterval);

  /// Builds a [WorkflowCommand]
  WorkflowCommand() {
    argParser
      ..addFlag('verbose',
          abbr: 'v', help: 'Verbose logging', defaultsTo: false)
      ..addFlag('update', abbr: 'u', defaultsTo: false);
  }

  /// Obtains the verbose flag out of the arguments
  /// This flag indicates if the ouput should be detailed or sumarized
  bool get verbose {
    return argResults?['verbose'] ?? false;
  }

  @protected
  AlfredWorkflow init() {
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
