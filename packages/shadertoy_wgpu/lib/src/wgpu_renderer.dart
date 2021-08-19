import 'ffi/dispatcher.dart';

class ShadertoyRenderer {
  final WgpuDispatcher dispatcher;

  ShadertoyRenderer(this.dispatcher);

  void msg(String msg) {
    dispatcher.msg(msg);
  }
}

ShadertoyRenderer newShadertoyRenderer() {
  return ShadertoyRenderer(WgpuDispatcher());
}
