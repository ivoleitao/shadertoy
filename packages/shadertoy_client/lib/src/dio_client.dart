import 'package:dio/dio.dart';

abstract class DioHttpClient {
  final Dio client;

  DioHttpClient(this.client);
}
