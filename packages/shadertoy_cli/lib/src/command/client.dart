import 'package:shadertoy_client/shadertoy_client.dart';

import 'api.dart';
import 'base.dart';

/// Provides a base definition of a command that interacts with a
/// shadertoy http client
abstract class ClientCommand extends APICommand implements HybridCommand {
  /// Builds an [ClientCommand]
  ClientCommand();

  @override
  void run() {
    final user = argResults?['user'];
    final password = argResults?['password'];
    final apiKey = argResults?['apiKey'];

    return call(newShadertoyHybridClient(
        apiKey: apiKey, user: user, password: password));
  }
}
