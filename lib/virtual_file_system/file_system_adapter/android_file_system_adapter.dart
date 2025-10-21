import 'package:flickture/global.dart';
import 'package:flickture/virtual_file_system/file_system_adapter/file_system_adapter.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';

class FlicktureFileSystemAdapter implements FileSystemAdapter {
  @override
  Future<bool> deleteFile(String path) {
    logger.info('Deleting file: $path');
    return Future.value(true);
  }

  @override
  Future<List<VirtualFile>> parseChildrenToVirtualFiles(String path) {
    logger.info('Parsing children to virtual files for path: $path');
    return Future.value([]);
  }

  @override
  Future<VirtualFile> parseFileToVirtualFile(String path) {
    logger.info('Parsing file to virtual file for path: $path');
    return Future.value(VirtualFile(id: 'id', name: 'name', parentId: ''));
  }
}
