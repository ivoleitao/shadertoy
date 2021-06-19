import 'package:envify/envify.dart';

part 'env.g.dart';

@Envify(path: '.env')
abstract class Env {
  static const String apiKey = _Env.apiKey;
  static const String user = _Env.user;
  static const String password = _Env.password;
}
