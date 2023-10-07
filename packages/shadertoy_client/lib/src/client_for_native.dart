import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shadertoy_client/src/dio_client.dart';

import 'http_options.dart';

class DioClient extends DioHttpClient {
  /// Object implementing a cookie storage strategy
  late final DefaultCookieJar _cookieJar;

  /// Provides the list of [Cookie] received
  Future<List<Cookie>> get cookies =>
      _cookieJar.loadForRequest(Uri.parse(client.options.baseUrl));

  DioClient(ShadertoyHttpOptions options, {Dio? dio})
      : super(dio ?? Dio(BaseOptions(baseUrl: options.baseUrl))) {
    if (options.supportsCookies) {
      _cookieJar = DefaultCookieJar();
      client.interceptors.add(CookieManager(_cookieJar));
    }
  }

  /// Clears the cookies
  void clearCookies() {
    _cookieJar.deleteAll();
  }
}
