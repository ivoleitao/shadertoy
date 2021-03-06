import 'dart:ffi';

import '../library_resolver.dart';
import 'load_library_strategy.dart';

/// Placeholder for [PackageRelativeStrategy].
///
/// The purpose of this is to be a placeholder for build
/// configurations that do not support `dart:cli`.
class PackageRelativeStrategy extends LoadLibraryStrategy {
  /// Return [:null:].
  @override
  DynamicLibrary? openFor(LibraryResolver resolver) {
    return null;
  }
}
