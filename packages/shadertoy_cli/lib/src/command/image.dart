import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_wgpu/shadertoy_wgpu.dart';

import 'hybrid.dart';

/// Shadertoy image command
class ImageCommand extends HybridCommand {
  @override
  final name = 'image';
  @override
  final description = 'Renders a shader to an image';

  /// Builds a [ImageCommand]
  ImageCommand() {
    argParser
      ..addOption('id',
          abbr: 'i', help: 'The id of the shader', valueHelp: 'id')
      ..addOption('path',
          abbr: 'f', help: 'The target file path', valueHelp: 'path')
      ..addOption('width', help: 'The width of the image', valueHelp: 'width')
      ..addOption('height',
          help: 'The height of the image', valueHelp: 'height');
  }

  @override
  void call(ShadertoyHybrid client) async {
    final String? id = argResults?['id'];
    if (id == null || id.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final result = await client.findShaderById(id);
    if (result.ok) {
      final shader = result.shader;
      if (shader != null) {
        logJson(shader);
        final renderer = newShadertoyRenderer();
        renderer.msg(shader.info.name);
      }
    } else {
      final error = result.error;
      if (error != null) {
        log(error.message);
      }
    }
  }
}
