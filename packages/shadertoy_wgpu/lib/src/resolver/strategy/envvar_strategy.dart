import 'dart:ffi';
import 'dart:io';

import '../library_resolver.dart';
import 'load_library_strategy.dart';

/// An [EnvVarStrategy] will attempt to resolve the shared library
/// via environment variable.
///
/// The user may inject an environment variable of the form
/// $libraryName_$moduleName_LIBRARY_PATH if there is more than one native module
/// used or $libraryName_LIBRARY_PATH. For example, if the $libraryName is
/// shadertoy_wgpu and the $moduleName is MOD1 the name of the environment
/// variable is SHADERTOY_WGPU_MOD1_LIBRARY_PATH. Conversely if the $libraryName
/// is shadertoy_wgpu and the $moduleName is [:null:] the name of the environment
/// variable is SHADERTOY_WGPU_LIBRARY_PATH
///
/// The value of the environment variable may contain either the directory
/// that the shared library can be found in, or a full path to the shared
/// library itself. In the case that a directory is defined, then the filename
/// should be $libraryName_$moduleName-$os$bitness.$extension or
/// $libraryName-$os$bitness.$extension if the $moduleName was not defined
///
/// For example on Win64 with $moduleName equal to FFI:
/// * SHADERTOY_WGPU_FFI_LIBRARY_PATH=C:\MyLibs (will look for shadertoy_wgpu_ffi_win64.dll)
/// or on Win64 without the $moduleName defined:
/// * SHADERTOY_WGPU_LIBRARY_PATH=C:\MyLibs (will look for shadertoy_wgpu_win64.dll)
/// finally if the full path is defined on the environment variable it could be
/// something lik:
/// * SHADERTOY_WGPU_FFI_LIBRARY_PATH=C:\MyLibs\shadertoy_wgpu.dll
class EnvVarStrategy extends LoadLibraryStrategy {
  /// Return the opened [DynamicLibrary] if the library was resolved via
  /// environment variable, [:null:] otherwise.
  @override
  DynamicLibrary? openFor(LibraryResolver resolver) {
    final path = _envLibraryFilePath(resolver);
    if (path == null) return null;
    return open(path);
  }

  /// Returns the absolute path of the shared library defined by the user-def
  /// library path.
  String? _envLibraryFilePath(LibraryResolver resolver) {
    final libraryName = resolver.libraryName;
    final moduleName = resolver.moduleName;
    final varName = moduleName != null
        ? '${libraryName.toUpperCase()}_${moduleName.toUpperCase()}'
        : libraryName.toUpperCase();
    var envPath = Platform.environment['{$varName}_LIBRARY_PATH'];
    if (envPath != null) {
      if (FileSystemEntity.typeSync(envPath) ==
          FileSystemEntityType.directory) {
        if (envPath[envPath.length - 1] == Platform.pathSeparator) {
          envPath = envPath.substring(0, envPath.length - 1);
        }
        envPath = '$envPath${Platform.pathSeparator}'
            '${resolver.defaultLibraryFileName}';
      }
      envPath =
          (FileSystemEntity.typeSync(envPath) == FileSystemEntityType.file)
              ? File(envPath).absolute.path
              : null;
    }
    return envPath;
  }
}
