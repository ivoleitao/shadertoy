import 'dart:async';

import 'package:args/command_runner.dart';

import 'command/comments.dart';
import 'command/playlist.dart';
import 'command/search.dart';
import 'command/shader.dart';
import 'command/sqlite.dart';
import 'command/user.dart';

Future run(List<String> args) async {
  final runner = CommandRunner('shadertoy', 'Command-line shadertoy client')
    ..addCommand(UserCommand())
    ..addCommand(ShaderCommand())
    ..addCommand(CommentsCommand())
    ..addCommand(PlaylistCommand())
    ..addCommand(SearchCommand())
    ..addCommand(SqliteCommand());
  await runner.run(args);
}
