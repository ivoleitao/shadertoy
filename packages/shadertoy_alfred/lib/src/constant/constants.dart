import 'pubspec.g.dart' as pubspec;

class Constants {
  Constants._();

  static final String version = pubspec.version;
  static final Uri repository = Uri.parse(pubspec.repository);
}
