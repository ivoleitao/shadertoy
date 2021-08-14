import 'package:shadertoy_client/shadertoy_client.dart';

import 'base.dart';
import 'multi.dart';

/// Provides a base definition of a command that interacts with the
/// Shadertoy hybrid API
abstract class HybridCommand extends MultiCommand
    implements HybridClientCommand {
  /// Builds an [HybridCommand]
  HybridCommand();

  @override
  void run() {
    final user = argResults?['user'];
    final password = argResults?['password'];
    final apiKey = argResults?['apiKey'];

    return call(newShadertoyHybridClient(
        apiKey: apiKey, user: user, password: password));
  }
}
