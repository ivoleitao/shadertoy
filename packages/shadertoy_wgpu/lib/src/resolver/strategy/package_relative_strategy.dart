import 'dart:cli' as cli;
import 'dart:ffi';
import 'dart:isolate' show Isolate;

import '../library_resolver.dart';
import 'load_library_strategy.dart';

/// An [PackageRelativeStrategy] will attempt to resolve the shared
/// library via a location based on a package-relative convention.
///
/// **Prebuilt Libraries:** There is a library layout convention used for
/// locating prebuilt shared libraries. This strategy requires a:
/// * [LibraryResolver.packageName], which is a [String] identifier to fully
/// resolve a dart package (package:{packageName})
/// * [LibraryResolver.libraryName], which is a [String] identifier to fully
/// resolve a dart library (package:{packageName}/{libraryName}.dart)
/// * [LibraryResolver.moduleName], which is a [String] identifier to fully
/// resolve the location of the library blobs as every library should be defined
/// in its own subdirectory of lib/src (package:{packageName}/src/{moduleName})
///
/// The blobs directory will contain the shared libraries which have the name in
/// the form $libraryName_$moduleName-$os$bitness.$extension. In the case of this
/// library on Win64, it is named *shadertoy_wgpu_ffi-win64.dll*.
class PackageRelativeStrategy extends LoadLibraryStrategy {
  /// Return the opened [DynamicLibrary] if the library was resolved via
  /// package relative resolution, [:null:] otherwise.
  @override
  DynamicLibrary? openFor(LibraryResolver resolver) {
    final packageName = resolver.packageName;
    final libraryName = resolver.libraryName;
    final moduleName = resolver.moduleName;
    final packageLibrary = 'package:$packageName/$libraryName.dart';
    final packageUri = _resolvePackagedLibraryLocation(packageLibrary);
    final blobs = packageUri?.resolve('src/$moduleName/blobs/');
    final filePath = blobs?.resolve(resolver.defaultLibraryFileName);
    if (filePath == null) return null;
    return open(filePath.toFilePath());
  }

  /// Resolve package-relative [packagePath] by converting it to a non-package
  /// relative [Uri].
  Uri? _resolvePackagedLibraryLocation(String packagePath) {
    const timeoutSeconds = 5;
    final libraryUri = Uri.parse(packagePath);
    final packageUriFuture = Isolate.resolvePackageUri(libraryUri);
    final packageUri = cli.waitFor(packageUriFuture,
        timeout: const Duration(seconds: timeoutSeconds));
    return packageUri;
  }
}
