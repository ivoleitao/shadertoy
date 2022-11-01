import 'dart:io';

import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_util.dart';
import 'package:shadertoy_alfred/src/command/workflow.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

/// Base script filter command class
abstract class ScriptFilterCommand extends WorkflowCommand {
  /// The auto-update item
  static const _updateItem = AlfredItem(
    title: 'Auto-Update available!',
    subtitle: 'Press <enter> to auto-update to a new version of this workflow.',
    arg: 'update:workflow',
    match:
        'Auto-Update available! Press <enter> to auto-update to a new version of this workflow.',
    icon: AlfredItemIcon(path: 'alfred.png'),
    valid: true,
  );

  /// If an automatic update should be triggered once the worklow executed
  final bool automaticUpdate;

  /// Builds a [ScriptFilterCommand]
  ScriptFilterCommand({this.automaticUpdate = true});

  @protected
  Future<File?> downloadShaderPicture(
      ShadertoySite client, String shaderId) async {
    final String fileName = '${shaderIdToFileName(shaderId)}.jpg';
    final String filePath = p.join(
      p.dirname(Platform.script.toFilePath()),
      'image_cache',
      fileName,
    );
    final File file = File(filePath);

    return file.exists().then((exists) {
      if (!exists) {
        return client.downloadShaderPicture(shaderId).then((response) {
          final bytes = response.bytes;
          return bytes != null
              ? file
                  .create(recursive: true)
                  .then((_) => file.writeAsBytes(bytes))
              : null;
        });
      }

      return file;
    });
  }

  @protected
  Future<void> runWithUpdate(AlfredWorkflow workflow) async {
    if (automaticUpdate && await updater.updateAvailable()) {
      return workflow.run(addToBeginning: _updateItem);
    } else {
      return workflow.run();
    }
  }

  @override
  Future<void> runWorkflow(AlfredWorkflow workflow) {
    return super.runWorkflow(workflow).then((_) => runWithUpdate(workflow));
  }
}
