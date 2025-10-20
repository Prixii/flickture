import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class VirtualFileSystemException implements Exception {
  final String message;

  VirtualFileSystemException(this.message);

  @override
  String toString() {
    return 'VirtualFileSystemException: $message';
  }
}

// 专门用于父文件夹无效的异常
class ParentFolderNotFoundException extends VirtualFileSystemException {
  ParentFolderNotFoundException(VirtualFileItemId parentId)
    : super('Parent folder with ID $parentId not found.');
}

// 用于表示文件或文件夹不存在的异常
class ItemNotFoundException extends VirtualFileSystemException {
  ItemNotFoundException(VirtualFileItemId itemId)
    : super('Item with ID $itemId not found.');
}

// 用于表示文件已存在的异常
class FileAlreadyExistsException extends VirtualFileSystemException {
  FileAlreadyExistsException(String filename)
    : super('File with name $filename already exists.');
}

// 用于表示文件夹已存在的异常
class FolderAlreadyExistsException extends VirtualFileSystemException {
  FolderAlreadyExistsException(String folderName)
    : super('Folder with name $folderName already exists.');
}

// 用于表示不允许进行特定操作的异常 (例如，删除根目录)
class OperationNotAllowedException extends VirtualFileSystemException {
  OperationNotAllowedException(String reason)
    : super('Operation not allowed: $reason');
}

// 用于表示文件系统初始化失败
class FileSystemInitializationException extends VirtualFileSystemException {
  FileSystemInitializationException(String message)
    : super('File system initialization failed: $message');
}

class InvalidFileItemTypeException extends VirtualFileSystemException {
  InvalidFileItemTypeException(String itemType, String expect)
    : super('Invalid file item type: $itemType, expected $expect');
}

class DuplicateNameException extends VirtualFileSystemException {
  DuplicateNameException(String itemId, String name)
    : super('Item with ID $itemId and name $name already exists.');
}

class InvalidParentIdException extends VirtualFileSystemException {
  InvalidParentIdException(String itemId)
    : super('Invalid parent ID for item with ID $itemId');
}

class UnsupportedMoveException extends VirtualFileSystemException {
  UnsupportedMoveException(VirtualFileItemId id, VirtualFileItemId target)
    : super('Unsupported move operation from $id to $target');
}
