import 'package:flickture/virtual_file_system/exception/virtual_file_system_exception.dart';
import 'package:flickture/virtual_file_system/file_item_mapper.dart';
import 'package:flickture/virtual_file_system/file_system_adapter/file_system_adapter.dart';
import 'package:flickture/virtual_file_system/media_change_observer/media_change_observer.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/special_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class VirtualFileManager {
  late final RootFolder root;
  late final TrashBin trashBin;
  late final StarFolder starFolder;

  late final FileSystemAdapter fileSystemAdapter;

  late final FileItemMapper fileItemMapper;

  late final MediaChangeObserver mediaChangeObserver;

  Future<void> init() async {
    mediaChangeObserver.registerObserver();
    fileItemMapper.init();
    await root.init();
  }

  VirtualFolder createVirtualFolder(VirtualFileItemId parentId, String name) {
    final parentFolder = fileItemMapper.getVirtualFileItem<VirtualFolder>(
      parentId,
    );
    if (parentFolder == null) {
      throw ItemNotFoundException(parentId);
    }
    if (alreadyHasFolderName(parentFolder, name)) {
      throw DuplicateNameException(parentFolder.id, name);
    }

    final newId = fileItemMapper.generateNewVirtualFileItemId();
    final newFolder = VirtualFolder(id: newId, name: name, parentId: parentId);
    parentFolder.addChild(newFolder);
    fileItemMapper.addVirtualFileItem(newFolder);
    return newFolder;
  }

  bool alreadyHasFolderName(VirtualFolder folder, String name) {
    return folder.childrenId.any((childId) {
      final item = fileItemMapper.getVirtualFileItemAny(childId);
      return (item is VirtualFolder) && (item.name == name);
    });
  }

  VirtualFile createVirtualFile(VirtualFileItemId parentId) {
    final parentFolder = fileItemMapper.getVirtualFileItem<VirtualFolder>(
      parentId,
    );
    if (parentFolder == null) {
      throw ItemNotFoundException(parentId);
    }

    // 文件不检查重名
    final newId = fileItemMapper.generateNewVirtualFileItemId();
    final newFile = VirtualFile(id: newId, name: '', parentId: parentId);
    parentFolder.addChild(newFile);
    fileItemMapper.addVirtualFileItem(newFile);
    return newFile;
  }

  bool alreadyHasFileName(VirtualFolder folder, String name) {
    return folder.childrenId.any((childId) {
      final item = fileItemMapper.getVirtualFileItemAny(childId);
      return (item is VirtualFile) && (item.name == name);
    });
  }

  bool deleteVirtualItem(VirtualFileItemId id) {
    final item = fileItemMapper.getVirtualFileItemAny(id);
    if (item == null) {
      throw ItemNotFoundException(id);
    }
    if (item is VirtualFolder) {
      return deleteVirtualFolder(item);
    } else if (item is VirtualFile) {
      return deleteVirtualFile(item);
    }
    throw UnsupportedError('Unsupported item type');
  }

  bool deleteVirtualFolder(VirtualFolder folder) {
    for (final childId in folder.childrenId) {
      final child = fileItemMapper.getVirtualFileItemAny(childId);
      if (child is VirtualFolder) {
        deleteVirtualFolder(child);
      } else if (child is VirtualFile) {
        deleteVirtualFile(child);
      }
    }
    trashBin.deleteItem(folder.id);
    return true;
  }

  bool deleteVirtualFile(VirtualFile file) {
    file.isDeleted = true;
    trashBin.deleteItem(file.id);
    return true;
  }

  bool restoreVirtualItem(VirtualFileItemId id) {
    final item = fileItemMapper.getVirtualFileItemAny(id);
    if (item is VirtualFolder) {
      restoreVirtualFolder(item);
    } else if (item is VirtualFile) {
      restoreVirtualFile(item);
    }
    return true;
  }

  bool restoreVirtualFolder(VirtualFolder folder) {
    folder.isDeleted = false;
    trashBin.restore(folder.id);
    return true;
  }

  bool restoreVirtualFile(VirtualFile file) {
    file.isDeleted = false;
    trashBin.restore(file.id);
    return true;
  }

  bool starVirtualFile(VirtualFileItemId id) {
    final file = fileItemMapper.getVirtualFileItem<VirtualFile>(id);
    if (file == null) {
      throw ItemNotFoundException(id);
    }
    starFolder.starFile(id);
    return true;
  }

  bool unstarVirtualFile(VirtualFileItemId id) {
    final file = fileItemMapper.getVirtualFileItem<VirtualFile>(id);
    if (file == null) {
      throw ItemNotFoundException(id);
    }
    starFolder.unstarFile(id);
    return true;
  }

  bool renameVirtualFile(VirtualFileItemId id, String newName) {
    final file = fileItemMapper.getVirtualFileItem<VirtualFile>(id);
    if (file == null) {
      throw ItemNotFoundException(id);
    }
    file.name = newName;
    return true;
  }

  bool renameVirtualFolder(VirtualFileItemId id, String newName) {
    final folder = fileItemMapper.getVirtualFileItem<VirtualFolder>(id);
    if (folder == null) {
      throw ItemNotFoundException(id);
    }
    if (folder.parentId == null) {
      throw InvalidParentIdException(folder.id);
    }

    final folderParent = fileItemMapper.getVirtualFileItem<VirtualFolder>(
      folder.parentId!,
    );
    if (folderParent == null) {
      throw ItemNotFoundException(folder.parentId!);
    }

    if (alreadyHasFolderName(folderParent, newName)) {
      throw DuplicateNameException(folderParent.id, newName);
    }

    folder.name = newName;
    return true;
  }

  bool moveVirtualItem(VirtualFileItemId id, VirtualFileItemId target) {
    if (id == target) {
      throw UnsupportedMoveException(id, target);
    }

    final item = fileItemMapper.getVirtualFileItemAny(id);
    if (item == null) {
      throw ItemNotFoundException(id);
    }

    final targetFolder = fileItemMapper.getVirtualFileItem<VirtualFolder>(
      target,
    );
    if (targetFolder == null) {
      throw ItemNotFoundException(target);
    }

    final originalParentFolder = fileItemMapper
        .getVirtualFileItem<VirtualFolder>(item.parentId!);
    if (originalParentFolder == null) {
      throw ItemNotFoundException(item.parentId!);
    }

    if (item is VirtualFile) {
      return _moveVirtualFile(item, targetFolder, originalParentFolder);
    } else if (item is VirtualFolder) {
      return _moveVirtualFolder(item, targetFolder, originalParentFolder);
    }

    throw UnsupportedMoveException(id, target);
  }

  bool _moveVirtualFolder(
    VirtualFolder toMove,
    VirtualFolder target,
    VirtualFolder originalParentFolder,
  ) {
    if (alreadyHasFolderName(target, toMove.name)) {
      throw DuplicateNameException(target.id, toMove.name);
    }
    toMove.parentId = target.id;
    originalParentFolder.childrenId.remove(toMove.id);
    target.childrenId.add(toMove.id);
    return true;
  }

  bool _moveVirtualFile(
    VirtualFile toMove,
    VirtualFolder target,
    VirtualFolder originalParentFolder,
  ) {
    toMove.parentId = target.id;
    originalParentFolder.childrenId.remove(toMove.id);
    target.childrenId.add(toMove.id);
    return true;
  }
}
