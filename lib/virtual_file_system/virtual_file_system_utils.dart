class VirtualFileSystemUtils {
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
