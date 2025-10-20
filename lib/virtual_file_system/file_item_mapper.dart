import 'package:flickture/virtual_file_system/bi_map.dart';
import 'package:flickture/virtual_file_system/exception/virtual_file_system_exception.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_utils.dart';

class FileItemMapper {
  late final Set<String> visibleFolders;
  late final BiMap<LocalFileId, VirtualFileItemId> fileIdMap;
  late final Map<VirtualFileItemId, VirtualFileItem> virtualFileItemMap;

  FileItemMapper() {
    visibleFolders = {};
    fileIdMap = BiMap();
    virtualFileItemMap = {};
  }

  Future<void> init() async {}

  LocalFileId? findLocalFileIdByVirtualFileItemId(VirtualFileItemId id) {
    return fileIdMap.getKey(id);
  }

  VirtualFileItemId? findVirtualFileItemIdByLocalFileId(LocalFileId id) {
    return fileIdMap.getValue(id);
  }

  bool addVisibleFolder(String folderName) {
    if (visibleFolders.contains(folderName)) {
      return false;
    }

    visibleFolders.add(folderName);
    return true;
  }

  bool removeVisibleFolder(String folderName) {
    if (!visibleFolders.contains(folderName)) {
      return false;
    }

    visibleFolders.remove(folderName);
    return true;
  }

  T? getVirtualFileItem<T>(VirtualFileItemId id) {
    final item = virtualFileItemMap[id];
    if (item is T) {
      return item as T;
    }
    throw InvalidFileItemTypeException(
      item.runtimeType.toString(),
      T.runtimeType.toString(),
    );
  }

  VirtualFileItem? getVirtualFileItemAny(VirtualFileItemId id) {
    return virtualFileItemMap[id];
  }

  String generateNewVirtualFileItemId() {
    VirtualFileItemId id;
    do {
      id = VirtualFileSystemUtils.generateUniqueId();
    } while (virtualFileItemMap.containsKey(id));
    return id;
  }

  bool addVirtualFileItem(VirtualFileItem item) {
    if (virtualFileItemMap.containsKey(item.id)) {
      return false;
    }

    virtualFileItemMap[item.id] = item;
    return true;
  }
}
