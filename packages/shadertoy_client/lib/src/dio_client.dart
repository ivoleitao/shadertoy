import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

abstract class DioHttpClient {
  final Dio client;

  DioHttpClient(this.client);

  Future<List<Cookie>> get cookies;

  void clearCookies();
}
