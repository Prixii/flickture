import 'package:flickture/virtual_file_system/file_item_mapper.dart';
import 'package:flickture/virtual_file_system/file_system_adapter/file_system_adapter.dart';
import 'package:flickture/virtual_file_system/media_change_observer/media_change_observer.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/special_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class VirtualFileManager {
  late final VirtualFolder root;
  late final TrashBin trashBin;
  late final StarFolder starFolder;

  late final FileSystemAdapter fileSystemAdapter;

  late final FileItemMapper fileItemMapper;

  late final MediaChangeObserver mediaChangeObserver;

  VirtualFolder createVirtualFolder() {
    throw UnimplementedError();
  }

  VirtualFile createVirtualFile() {
    throw UnimplementedError();
  }

  bool deleteVirtualItem(VirtualFileItemId id) {
    throw UnimplementedError();
  }

  bool restoreVirtualItem(VirtualFileItemId id) {
    throw UnimplementedError();
  }

  bool starVirtualItem(VirtualFileItemId id) {
    throw UnimplementedError();
  }

  bool unstarVirtualItem(VirtualFileItemId id) {
    throw UnimplementedError();
  }

  bool renameVirtualFileItem(VirtualFileItemId id, String newName) {
    throw UnimplementedError();
  }

  bool moveVirtualItem(VirtualFileItemId id, VirtualFileItemId target) {
    throw UnimplementedError();
  }
}
