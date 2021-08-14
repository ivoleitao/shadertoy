import 'dart:io';

import 'package:shadertoy_cli/src/command/site.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

/// Shadertoy preview command
class PreviewCommand extends SiteCommand {
  @override
  final name = 'preview';
  @override
  final description = 'Gets a shader preview by id';

  /// Builds a [PreviewCommand]
  PreviewCommand() {
    argParser
      ..addOption('id',
          abbr: 'i', help: 'The id of the shader', valueHelp: 'id')
      ..addOption('path',
          abbr: 'f', help: 'The target file path', valueHelp: 'path')
      ..addOption('width',
          abbr: 'w', help: 'The width of the image', valueHelp: 'width')
      ..addOption('height',
          abbr: 'h', help: 'The height of the image', valueHelp: 'height');
  }

  @override
  void call(ShadertoySite client) async {
    final String? id = argResults?['id'];
    if (id == null || id.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final String path = argResults?['path'] ?? '$id.jpg';

    final result = await client.downloadShaderPicture(id);
    if (result.ok) {
      final bytes = result.bytes;
      if (bytes != null) {
        File(path).writeAsBytesSync(bytes);
      }
    }
  }
}
