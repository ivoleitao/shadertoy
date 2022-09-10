import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef MsgNative = Void Function(Pointer<Utf8>);
typedef MsgDart = void Function(Pointer<Utf8>);

mixin WgpuFunctions {
  late final MsgDart msg;

  /// Resolve all functions using the [library]
  void resolveFunctions(DynamicLibrary library) {
    msg = library.lookupFunction<MsgNative, MsgDart>('msg');
  }
}
