import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class TrashBin extends VirtualFolder {
  TrashBin({required super.id}) : super(name: '垃圾桶', parentId: null);

  // TODO: Implement purgeAll method
  Future<void> purgeAll(
    Future<bool> Function(VirtualFileItemId) purgeFunc,
  ) async {
    throw UnimplementedError('purgeAll is not implemented');
  }

  void purge(VirtualFileItemId fileId) {
    throw UnimplementedError('purge is not implemented');
  }

  void restore(VirtualFileItemId fileId) {
    throw UnimplementedError('restore is not implemented');
  }
}

class StarFolder extends VirtualFolder {
  StarFolder({required super.id}) : super(name: '收藏夹', parentId: null);

  void starFile(VirtualFileItemId fileId) {
    throw UnimplementedError('starFile is not implemented');
  }

  void unstarFile(VirtualFileItemId fileId) {
    throw UnimplementedError('unstarFile is not implemented');
  }
}
