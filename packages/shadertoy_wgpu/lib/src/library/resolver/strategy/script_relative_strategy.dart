import 'dart:ffi';
import 'dart:io';

import '../library_resolver.dart';
import 'load_library_strategy.dart';

/// An [ScriptRelativeStrategy] will attempt to resolve the shared
/// library via the directory location that the current script lives in.
///
/// **Script Directory:** Check the directory that the script is running in
/// and detect if there is a shared library file whose name conforms to the
/// convention described above.
class ScriptRelativeStrategy extends LoadLibraryStrategy {
  /// Return the [String] id of the [ScriptRelativeStrategy].
  @override
  String get strategyId => 'Script-Relative-Strategy';

  /// Return the opened [DynamicLibrary] if the library was resolved via
  /// script relative resolution, [:null:] otherwise.
  @override
  DynamicLibrary? openFor(LibraryResolver resolver) {
    final libraryName = resolver.defaultLibraryFileName;
    final scriptBlobPath =
        '${File.fromUri(Platform.script).parent.path}/$libraryName';
    final scriptType = FileSystemEntity.typeSync(scriptBlobPath);
    return scriptType != FileSystemEntityType.notFound
        ? open(scriptBlobPath)
        : null;
  }
}
