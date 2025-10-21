import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class VirtualFileSystemUtils {
  static String generateUniqueId() {
    return _uuid.v4();
  }
}

String extractFileName(String path) => path.split('/').last;

String extractFileExtension(String path) => path.split('.').last;
