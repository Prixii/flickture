typedef VirtualFileItemId = String;
typedef LocalFileId = String;

enum FileType {
  jpg,
  png,
  gif,
  mp4,
  mov,
  other,
  unknown;

  static FileType fromString(String type) {
    for (final fileType in FileType.values) {
      if (fileType.name == type) {
        return fileType;
      }
    }
    return FileType.unknown;
  }
}
