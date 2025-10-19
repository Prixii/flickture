import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';

abstract interface class FileSystemAdapter {
  Future<List<VirtualFile>> parseChildrenToVirtualFiles(String path);
  Future<VirtualFile> parseFileToVirtualFile(String path);
  Future<bool> deleteFile(String path);
}
