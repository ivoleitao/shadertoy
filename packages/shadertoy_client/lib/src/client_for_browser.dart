import 'dart:html' as html;

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:shadertoy_client/src/dio_client.dart';

class DioClient extends DioHttpClient {
  List<Cookie> get _cookies =>
      html.window.document.cookie
          ?.split(';')
          .where((e) => e.isNotEmpty)
          .map((c) => Cookie.fromSetCookieValue(c))
          .toList() ??
      const <Cookie>[];

  /// Provides the list of [Cookie] received
  Future<List<Cookie>> get cookies => Future.value(_cookies);

  DioClient(BaseOptions options, {Dio? dio})
      : super(dio ?? Dio(BaseOptions(baseUrl: options.baseUrl)));

  void _createCookie(String name, String value, int? days) {
    String expires;
    if (days != null) {
      DateTime now = DateTime.now();
      DateTime date = now.add(Duration(days: days));
      expires = '; expires=$date';
    } else {
      DateTime then = DateTime.fromMillisecondsSinceEpoch(0);
      expires = '; expires=$then';
    }
    html.window.document.cookie = '$name=$value$expires; path=/';
  }

  /// Clears the cookies
  void clearCookies() {}
}
