import 'dart:collection';
import 'dart:io';

import 'package:progress_bar/progress_bar.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

import 'hybrid.dart';

/// Provides the base for a command that performs a synchronization between the
/// shadertoy client and a shadertoy store
abstract class SyncCommand extends HybridCommand implements SyncTaskRunner {
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

  /// Provides a way of outputing a table in the command line interface with
  /// and [header] and a [body]
  ///
  /// * [header]: The header data
  /// * [body]: The body data
  String _tabulate(List<String> header, List<List<String>> body) {
    var retString = '';
    final cols = header.length;
    final colLength = List.filled(cols, 0, growable: true);
    if (body.any((model) => model.length != cols)) {
      throw Exception('Column\'s no. of each model does not match.');
    }

    //preparing colLength.
    for (var i = 0; i < cols; i++) {
      final chunk = <String>[];
      chunk.add(header[i]);
      for (var model in body) {
        chunk.add(model[i]);
      }
      colLength[i] = ([for (var c in chunk) c.length]..sort()).last;
    }
    // here we got prepared colLength.

    String fillSpace(int maxSpace, String text) {
      return '${text.padLeft(maxSpace)} | ';
    }

    void addRow(List<String> model, List<List<String>> row) {
      final l = <String>[];
      for (var i = 0; i < cols; i++) {
        final max = colLength[i];
        l.add(fillSpace(max, model[i]));
      }
      row.add(l);
    }

    final rowList = <List<String>>[];
    addRow(header, rowList);
    final topBar = List.generate(cols, (i) => '-' * colLength[i]);
    addRow(topBar, rowList);
    for (final model in body) {
      addRow(model, rowList);
    }
    for (final row in rowList) {
      var rowText = row.join();
      rowText = rowText.substring(0, rowText.length - 2);
      retString += '$rowText\n';
    }

    return retString;
  }

  @override
  Future<List<T>> process<T extends IterableMixin<APIResponse>>(
      List<Future<T>> tasks,
      {String? message,
      int progressBarWidth = 10}) async {
    var responses = <T>[];

    if (tasks.isNotEmpty) {
      if (verbose || !stdout.hasTerminal) {
        if (message != null) {
          log(message);
        }
        responses = await Future.wait(tasks);
      } else {
        final bar = ProgressBar('${message ?? ''}: [:bar] :percent :eta',
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
        stderr.write(_tabulate(const ['Context', 'Target', 'Message'], table));
      }
    }

    return responses;
  }
}
