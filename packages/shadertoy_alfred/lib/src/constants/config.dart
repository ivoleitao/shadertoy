import 'package.dart';

class Config {
  Config._();

  static final Duration updateInterval = Duration(days: 7);
  static final String version = pubspec.version?.toString() ?? '';
  static final Uri repository = pubspec.repository ?? Uri.parse('');
}
