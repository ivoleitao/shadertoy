import 'package:ffi/ffi.dart';

import 'library.dart';

/// The [WgpuDispatcher] prepares arguments intended for FFI calls and instructs
/// the [WgpuLibrary] which native call to make.
class WgpuDispatcher {
  /// Library accessor to the wgpu shared lib.
  final WgpuLibrary library;

  /// Construct the [WgpuDispatcher].
  WgpuDispatcher() : library = WgpuLibrary();

  void msg(String msg) {
    final msgPointer = msg.toNativeUtf8();

    try {
      library.msg(msgPointer);
    } finally {
      calloc.free(msgPointer);
    }
  }
}
