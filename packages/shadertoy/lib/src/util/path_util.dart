import 'package:path/path.dart' as p;

/// Sanitizes the picture path
///
/// * [path]: The picture path
String picturePath(String path) =>
    p.isAbsolute(path) ? path.substring(1) : path;
