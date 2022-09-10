// Copyright (c) 2021, Instantiations, Inc. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed by
// a BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';

import 'strategy/envvar_strategy.dart';
import 'strategy/load_library_strategy.dart';
import 'strategy/package_relative_strategy_stub.dart'
    if (dart.library.cli) 'strategy/package_relative_strategy.dart';
import 'strategy/script_relative_strategy.dart';
import 'strategy/system_resolution_strategy.dart';

/// Provides the capability to locate and open native shared libraries.
///
/// There are several mechanisms used to resolve shared libraries.
/// The implementation for each mechanism is defined by subclasses of
/// [LoadLibraryStrategy].
mixin LibraryResolver {
  static const String defaultModuleName = 'ffi';

  /// Mixer Responsibility: Return the package name for path resolution.
  String get packageName;

  /// Mixer Responsibility: Return the library name for path resolution.
  String get libraryName;

  /// Mixer Responsibility: Return the optional module name for path resolution.
  String get moduleName => defaultModuleName;

  /// Ordered list of strategies for resolving and opening shared libraries.
  final List<LoadLibraryStrategy> _strategies = [];

  /// Open the shared library whose path is resolved either by the supplied
  /// [path] or by the mixer [moduleName].
  ///
  /// If [path] is provided, then it acts as an override to any other lookup
  /// mechanisms.
  ///
  /// Each strategy in [_strategies] will be requested to open the shared
  /// library in order.
  DynamicLibrary? openLibrary({String? path}) {
    _initStrategies(path);
    for (final strategy in _strategies) {
      final library = strategy.openFor(this);
      if (library != null) return library;
    }
    return null;
  }

  /// Computes the library filename for this os and architecture.
  ///
  /// Throws an exception if invoked on an unsupported platform.
  String get defaultLibraryFileName {
    final bitness = sizeOf<IntPtr>() == 4 ? '32' : '64';
    String os, extension;
    if (Platform.isLinux) {
      os = 'linux';
      extension = 'so';
    } else if (Platform.isMacOS) {
      os = 'mac';
      extension = 'dylib';
    } else if (Platform.isWindows) {
      os = 'win';
      extension = 'dll';
    } else if (Platform.isAndroid) {
      os = 'android';
      extension = 'so';
    } else if (Platform.isIOS) {
      os = 'ios';
      extension = 'dylib';
    } else {
      throw Exception('Unsupported platform!');
    }

    return '${libraryName}_$moduleName-$os$bitness.$extension';
  }

  /// Add the [strategy] to the list of [_strategies].
  void add(LoadLibraryStrategy strategy) => strategy.addTo(_strategies);

  /// Initialize the strategies used to open shared libraries.
  void _initStrategies(String? userDefinedPath) {
    _strategies.clear();
    if (userDefinedPath != null) {
      _strategies.add(SystemResolutionStrategy(userDefinedPath));
    } else {
      _strategies
        ..add(EnvVarStrategy())
        ..add(PackageRelativeStrategy())
        ..add(ScriptRelativeStrategy())
        ..add(SystemResolutionStrategy(defaultLibraryFileName));
    }
  }
}
