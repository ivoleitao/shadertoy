import 'package:args/command_runner.dart';

import 'command/playlist.dart';
import 'command/search.dart';
import 'command/update.dart';

/// Main entry point to execute the shadertoy workflow
///
/// * [args]: The arguments provided to the worlflow
Future run(List<String> args) async {
  final runner = CommandRunner('st', 'Shadertoy workflow runner')
    ..addCommand(UpdateCommand())
    ..addCommand(SearchCommand())
    ..addCommand(PlaylistCommand());
  await runner.run(args);
}
