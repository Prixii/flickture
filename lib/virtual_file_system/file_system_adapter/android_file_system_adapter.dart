import 'package:flickture/virtual_file_system/file_system_adapter/file_system_adapter.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';

class AndroidFileSystemAdapter implements FileSystemAdapter {
  @override
  Future<bool> deleteFile(String path) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Future<List<VirtualFile>> parseChildrenToVirtualFiles(String path) {
    // TODO: implement parseChildrenToVirtualFiles
    throw UnimplementedError();
  }

  @override
  Future<VirtualFile> parseFileToVirtualFile(String path) {
    // TODO: implement parseFileToVirtualFile
    throw UnimplementedError();
  }
}
