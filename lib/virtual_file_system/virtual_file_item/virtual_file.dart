import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class VirtualFile extends VirtualFileItem {
  late FileType type;
  VirtualFile({required super.name, required super.id, required super.parentId})
    : super(isDeleted: false) {
    type = FileType.fromString(getFileType(name));
  }

  String getFileType(String fileName) {
    return fileName.split('.').last;
  }

  Future<bool> generateThumbnail() async {
    throw UnimplementedError();
  }
}
