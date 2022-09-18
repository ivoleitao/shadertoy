import 'package:shadertoy/src/api.dart';
import 'package:shadertoy/src/response.dart';

Future<R> catchError<R extends APIResponse, E>(
    Future<R> future, R Function(E) handle, ErrorMode errorMode) {
  return future.catchError((e) {
    if (e is E) {
      final apiResponse = handle(e);
      if (errorMode == ErrorMode.handleAndReturn) {
        return Future.value(apiResponse);
      } else if (errorMode == ErrorMode.handleAndRetrow) {
        return Future<R>.error(apiResponse.error ??
            ResponseError.unknown(message: 'Unknown Error'));
      }
    }
    return Future<R>.error(e);
  });
}
