import 'dart:collection';
import 'dart:io';

import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_cli/src/command/http.dart';
import 'package:shadertoy_cli/src/control/progress_bar.dart';
import 'package:shadertoy_cli/src/control/table.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

abstract class SyncCommand extends HttpCommand implements SyncTaskRunner {
  SyncCommand() {
    argParser
      ..addOption('concurrency',
          abbr: 'c',
          help: 'Maximum number of simultaneous shader requests',
          valueHelp: 'concurrency',
          defaultsTo: '10')
      ..addOption('timeout',
          abbr: 't',
          help: 'Shader request timeout in seconds',
          valueHelp: 'timeout',
          defaultsTo: '30');
  }

  @override
  Future<List<T>> process<T extends IterableMixin<APIResponse>>(
      List<Future<T>> tasks,
      {String? message,
      String title = '',
      int progressBarWidth = 10}) async {
    var responses = <T>[];

    if (tasks.isNotEmpty) {
      if (verbose || !stdout.hasTerminal) {
        responses = await Future.wait(tasks);
      } else {
        final bar = ProgressBar('$title[:bar] :percent :etas',
            total: tasks.length, width: progressBarWidth);
        final barTasks = <Future<T>>[];
        for (var i = 0; i < tasks.length; i++) {
          barTasks.add(tasks[i].then((T response) {
            bar.tick();
            return response;
          }));
        }
        responses = await Future.wait(barTasks);
      }

      final table = <List<String>>[];
      for (var response in responses) {
        ResponseError? error;
        for (APIResponse item in response) {
          error = item.error;
          if (error != null) {
            table.add([
              error.context ?? '(none)',
              error.target ?? '(none)',
              error.message
            ]);
          }
        }
      }

      if (table.isNotEmpty) {
        stderr.write(tabulate(table, const ['Context', 'Target', 'Message']));
      }
    }

    return responses;
  }
}
