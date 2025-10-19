import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class VirtualFolder extends VirtualFileItem {
  final childrenId = <VirtualFileItemId>[];

  VirtualFolder({
    required super.name,
    required super.parentId,
    required super.id,
  }) : super(isDeleted: false);

  bool addChild(VirtualFileItem child) {
    child.parentId = id;
    childrenId.add(child.id);
    return true;
  }

  bool addChildren(List<VirtualFileItem> children) {
    var result = true;
    for (final child in children) {
      if (!addChild(child)) {
        result = false;
      }
    }
    return result;
  }
}
