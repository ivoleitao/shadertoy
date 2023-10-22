import 'dart:html' as html;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shadertoy_client/src/browser_client.dart';
import 'package:shadertoy_client/src/http_options.dart';

class TestClient extends DioClient {
  final _setCookieReg = RegExp('(?<=)(,)(?=[^;]+?=)');

  List<Cookie> _getHeaderCookies(List<String> setCookieHeaderValue) {
    final list = setCookieHeaderValue
        .map((str) => str.split(_setCookieReg))
        .expand((cookie) => cookie)
        .where((cookie) => cookie.isNotEmpty)
        .map((str) => Cookie.fromSetCookieValue(str))
        .toList();

    return list;
  }

  List<Cookie> _getResponseCookies(Response response) {
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies == null || setCookies.isEmpty) {
      return <Cookie>[];
    }

    return _getHeaderCookies(setCookies);
  }

  String _getCookieString(List<Cookie> cookies) {
    cookies.sort((a, b) {
      if (a.path == null && b.path == null) {
        return 0;
      } else if (a.path == null) {
        return -1;
      } else if (b.path == null) {
        return 1;
      } else {
        return b.path!.length.compareTo(a.path!.length);
      }
    });
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  void _saveCookies(Response response) {
    final cookieString = _getCookieString(_getResponseCookies(response));

    html.document.cookie = cookieString;
  }

  TestClient(ShadertoyHttpOptions options, {Dio? dio})
      : super(options, dio: dio) {
    if (options.supportsCookies) {
      client.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final newCookies = _getCookieString([
            ...getCookies(options.headers[HttpHeaders.cookieHeader] as String?),
            ...getDocumentCookies(),
          ]);
          options.headers[HttpHeaders.cookieHeader] =
              newCookies.isNotEmpty ? newCookies : null;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _saveCookies(response);
          return handler.next(response);
        },
        onError: (err, handler) {
          final response = err.response;
          if (response != null) {
            _saveCookies(response);
          }

          handler.next(err);
        },
      ));
    }
  }
}
