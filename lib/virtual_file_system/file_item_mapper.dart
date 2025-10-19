import 'package:flickture/virtual_file_system/bi_map.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class FileItemMapper {
  List<String> visibleFolders = [];
  BiMap<LocalFileId, VirtualFileItemId> fileIdMap = BiMap();
  Map<VirtualFileItemId, VirtualFileItem> virtualFileItemMap = {};

  Future<void> init() async {}

  LocalFileId? findLocalFileIdByVirtualFileItemId(VirtualFileItemId id) {
    return fileIdMap.getKey(id);
  }

  VirtualFileItemId? findVirtualFileItemIdByLocalFileId(LocalFileId id) {
    return fileIdMap.getValue(id);
  }

  bool addVisibleFolder(String folderName) {
    throw UnimplementedError();
  }

  bool removeVisibleFolder(String folderName) {
    throw UnimplementedError();
  }

  VirtualFileItem? getVirtualFileItem(VirtualFileItemId id) {
    return virtualFileItemMap[id];
  }
}
