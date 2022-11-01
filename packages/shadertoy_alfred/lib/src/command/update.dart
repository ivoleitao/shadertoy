import 'package:alfred_workflow/alfred_workflow.dart';

import 'workflow.dart';

/// Shadertoy workflow update command
class UpdateCommand extends WorkflowCommand {
  @override
  final name = 'update';
  @override
  final description = 'Updates the workflow';

  /// Builds a [UpdateCommand]
  UpdateCommand();

  @override
  Future<void> prepareWorflow(AlfredWorkflow workflow) {
    return updater.update();
  }
}
