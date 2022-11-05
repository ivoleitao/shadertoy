#! /usr/bin/env dcli

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:dcli/dcli.dart';
import 'package:plist_parser/plist_parser.dart';

const debugTarget = 'target/debug';
const releaseTarget = 'target/release';

void main(List<String> args) async {
  // The dart sdk instance
  final sdk = DartSdk();

  // The dart project
  final project = DartProject.fromPath('.');
  final packageName = project.pubSpec.name;
  final exeName = project.pubSpec.executables.firstOrNull?.name ?? 'st';
  final debugName = '$exeName-debug';

  // The plist parser
  final plist = PlistParser().parseFileSync('info.plist');
  final defaultName = plist['name'] as String;

  final defaultSource = 'bin/$packageName.dart';

  // create the parser and add a --verbose option
  final parser = ArgParser()
    ..addOption('source', abbr: 's', defaultsTo: defaultSource)
    ..addOption('name', abbr: 'n', defaultsTo: defaultName)
    ..addFlag('debug', defaultsTo: false, negatable: false);

  // parse the passed in command line arguments.
  final results = parser.parse(args);

  // get the source option
  final source = results['source'] as String;

  // get the name option
  final name = results['name'] as String;

  // get the debug flag value
  final debug = results['debug'] as bool;

  var target = debugTarget;
  if (debug) {
    if (exists(debugTarget)) {
      deleteDir(debugTarget, recursive: true);
    }
    createDir(debugTarget, recursive: true);
  } else {
    if (exists(releaseTarget)) {
      deleteDir(releaseTarget, recursive: true);
    }
    createDir(releaseTarget, recursive: true);
    target = releaseTarget;
  }

  copy('info.plist', target);
  copy('LICENSE', target);
  copy('README.md', target);
  copyTree('assets', target);

  if (debug) {
    sdk.run(args: [
      'compile',
      'exe',
      source,
      '-o',
      '$target/$exeName',
      '-S',
      '$target/$debugName'
    ], workingDirectory: '.');
    move('$target/$debugName', '$target/$exeName', overwrite: true);
  } else {
    sdk.run(
        args: ['compile', 'exe', source, '-o', '$target/$exeName'],
        workingDirectory: '.');
  }

  final files = find('*', workingDirectory: target).toList();
  final encoder = ZipFileEncoder();
  try {
    encoder.create('$target/$name.alfredworkflow');
    for (final path in files) {
      await encoder.addFile(File(path));
    }
  } finally {
    encoder.close();
  }
}
