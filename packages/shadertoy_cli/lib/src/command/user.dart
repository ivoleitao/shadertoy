import 'package:shadertoy/shadertoy_api.dart';

import 'extended.dart';

/// Shadertoy user command
class UserCommand extends ExtendedCommand {
  @override
  final name = 'user';
  @override
  final description = 'Gets one or more users by id';

  /// Builds a [UserCommand]
  UserCommand() {
    argParser.addMultiOption('ids',
        abbr: 'i', help: 'The id(s) of the user(s)', valueHelp: 'ids');
  }

  @override
  void call(ShadertoyExtendedClient client) async {
    final List<String>? ids = argResults?['ids'];

    if (ids == null || ids.isEmpty) {
      runner?.printUsage();
      return null;
    }

    final results = await Future.wait(ids.map((id) => client.findUserById(id)));
    for (var sr in results) {
      final user = sr.user;
      if (user != null) {
        logJson(user.toJson());
      }
    }
  }
}
