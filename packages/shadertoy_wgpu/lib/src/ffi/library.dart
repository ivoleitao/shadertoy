import 'dart:ffi';

import 'package:shadertoy_wgpu/src/resolver/library_resolver.dart';

import 'constants.dart';
import 'functions.dart';
import 'types.dart';

/// [WgpuLibrary] is the gateway to the native shadertoy_wgpu shared library.
///
/// It has a series of mixins for making available constants, types and
/// functions that are described in C header files.
class WgpuLibrary
    with LibraryResolver, WgpuConstants, WgpuTypes, WgpuFunctions {
  /// Unique name of this package.
  @override
  String get packageName => 'shadertoy_wgpu';

  /// Unique name of this library.
  @override
  String get libraryName => 'shadertoy_wgpu';

  /// Library path the user can define to override normal resolution.
  static String? _userDefinedLibraryPath;

  /// Return the library path defined by the user.
  static String? get userDefinedLibraryPath => _userDefinedLibraryPath;

  /// Set the library [path] defined by the user.
  ///
  /// Throw a [StateError] if this library has already been initialized.
  static set userDefinedLibraryPath(String? path) {
    if (_initialized == true) {
      throw StateError('Wgpu library already initialized.');
    }
    _userDefinedLibraryPath = path;
  }

  /// Singleton instance.
  static final WgpuLibrary _instance = WgpuLibrary._(_userDefinedLibraryPath);

  /// Tracks library init state.
  ///
  /// Set to [:true:] if this library is opened and all functions are resolved.
  static bool _initialized = false;

  /// Dart native library object.
  late final DynamicLibrary? _libraryImpl;

  /// Return the [WgpuLibrary] singleton library instance.
  factory WgpuLibrary() {
    return _instance;
  }

  /// Internal constructor that opens the native shared library and resolves
  /// all the functions.
  WgpuLibrary._(String? libraryPath) {
    _libraryImpl = openLibrary(path: libraryPath);
    if (_libraryImpl != null) {
      resolveFunctions(_libraryImpl!);
      _initialized = true;
    }
  }
}
