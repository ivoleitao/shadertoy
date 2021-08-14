import 'package:shadertoy/shadertoy_api.dart';

import 'extended.dart';

/// Shadertoy shader command
class ShaderCommand extends ExtendedCommand {
  @override
  final name = 'shader';
  @override
  final description = 'Gets one or more shaders by id';

  /// Builds a [ShaderCommand]
  ShaderCommand() {
    argParser.addMultiOption('ids',
        abbr: 'i', help: 'The id(s) of the shader(s)', valueHelp: 'ids');
  }

  @override
  void call(ShadertoyExtendedClient client) async {
    final List<String>? ids = argResults?['ids'];

    if (ids == null || ids.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final results =
        await Future.wait(ids.map((id) => client.findShaderById(id)));
    for (var sr in results) {
      final shader = sr.shader;
      final error = sr.error;
      if (shader != null) {
        logJson(shader.toJson());
      } else if (error != null) {
        logJson(error.toJson());
      }
    }
  }
}
