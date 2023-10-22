import 'dart:html' as html;

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_client/src/dio_client.dart';

class DioClient extends DioHttpClient {
  @protected
  List<Cookie> getCookies(String? cookies) {
    if (cookies == null) {
      return <Cookie>[];
    }

    return cookies
        .split(';')
        .where((e) => e.isNotEmpty)
        .map((c) => Cookie.fromSetCookieValue(c))
        .toList();
  }

  @protected
  List<Cookie> getDocumentCookies() {
    return getCookies(html.document.cookie);
  }

  /// Provides the list of [Cookie] received
  @override
  Future<List<Cookie>> get cookies => Future.value(getDocumentCookies());

  DioClient(ShadertoyHttpOptions options, {Dio? dio})
      : super(dio ?? Dio(BaseOptions(baseUrl: options.baseUrl))) {
    if (options.supportsCookies) {
      client.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) {
        options.extra["withCredentials"] = true;
        return handler.next(options);
      }));
    }
  }

  String _getCookieString(String name, String value, {int? days}) {
    String maxAge;
    if (days != null) {
      final seconds = days * 86400;
      maxAge = '; max-age=$seconds';
    } else {
      maxAge = '; expires=Thu, 01 Jan 1970 00:00:00 GMT; max-age=0';
    }
    return '$name=$value$maxAge';
  }

  /// Clears the cookies
  @override
  void clearCookies() {
    for (Cookie cookie in getDocumentCookies()) {
      html.document.cookie = _getCookieString(cookie.name, cookie.value);
    }
  }
}
