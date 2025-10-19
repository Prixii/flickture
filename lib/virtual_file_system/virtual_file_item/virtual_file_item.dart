import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

abstract class VirtualFileItem {
  String name;
  VirtualFileItemId id;
  bool isDeleted;
  VirtualFileItemId? parentId;

  VirtualFileItem({
    required this.name,
    required this.id,
    required this.isDeleted,
    required this.parentId,
  });

  void rename(String newName) {
    name = newName;
  }

  bool get hasParent => parentId != null;
}
