import 'package:shadertoy/shadertoy_api.dart';

import 'multi.dart';

/// Shadertoy comments command
class CommentsCommand extends MultiCommand {
  @override
  final name = 'comments';
  @override
  final description = 'Gets shader comments by id';

  /// Builds a [CommentsCommand]
  CommentsCommand() {
    argParser.addOption('id',
        abbr: 'i', help: 'The id of the shader', valueHelp: 'id');
  }

  @override
  void call(ShadertoyExtendedClient api) async {
    final String? id = argResults?['id'];

    if (id == null || id.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final response = await api.findCommentsByShaderId(id);
    final comments = response.comments;
    if (comments != null) {
      logJson(comments.map((Comment comment) => comment.toJson()).toList());
    }
  }
}
