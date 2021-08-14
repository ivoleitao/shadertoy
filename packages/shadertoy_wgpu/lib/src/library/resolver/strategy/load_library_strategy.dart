import 'dart:ffi';

import '../library_resolver.dart';

/// An [LoadLibraryStrategy] is the mechanism used to resolve and open a shared
/// library.
///
/// All [LoadLibraryStrategy] subclasses will have a
/// [LoadLibraryStrategy.strategyId] so they can easily be identified.
///
/// An [LoadLibraryStrategy] will be requested to add itself to a list of
/// strategies.
///
/// All [LoadLibraryStrategy] will provide an implementation of
/// [LoadLibraryStrategy.openFor] which will answer [:true:] if successful,
/// [:false:] if not successful.
abstract class LoadLibraryStrategy {
  /// Return the [String] id of the strategy.
  String get strategyId;

  /// Add this strategy to the list of strategies.
  ///
  /// By default, this strategy will be appended to the end of the list of
  /// [strategies].
  void addTo(List<LoadLibraryStrategy> strategies) {
    strategies.add(this);
  }

  /// Open the shared library located at the provided [path].
  ///
  /// Return [:null:] if there is a problem opening the library at the [path].
  /// Return the opened [DynamicLibrary] on success.
  DynamicLibrary? open(String path) {
    try {
      return DynamicLibrary.open(path);
    } on Exception {
      return null;
    }
  }

  /// Subclass Responsibility: Open the shared library for the [LibraryResolver]
  /// mixin.
  ///
  /// Return the opened [DynamicLibrary] on success, [:null:] on failure.
  DynamicLibrary? openFor(LibraryResolver resolver);
}
