import 'dart:ffi';
import 'dart:io';

import '../library_resolver.dart';
import 'load_library_strategy.dart';

/// An [SystemResolutionStrategy] will attempt to resolve the shared
/// library using the default rules of the operating system.
class SystemResolutionStrategy extends LoadLibraryStrategy {
  /// String path to open.
  final String path;

  /// Construct an instance of this strategy with the [path] to open.
  SystemResolutionStrategy(this.path) : super();

  /// Return the opened [DynamicLibrary] if the library was resolved via
  /// os path resolution, [:null:] otherwise.
  @override
  DynamicLibrary? openFor(LibraryResolver resolver) {
    if (Platform.isIOS) return DynamicLibrary.process();
    return open(path);
  }
}
