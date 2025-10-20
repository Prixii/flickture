import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';

class TrashBin extends VirtualFolder {
  TrashBin({
    required super.id,
    required this.purgeFunc,
    required this.restoreFunc,
  }) : super(name: '垃圾桶', parentId: null);

  late final Future<bool> Function(VirtualFileItemId) purgeFunc;
  late final Future<bool> Function(VirtualFileItemId) restoreFunc;

  Future<void> purgeAll() async {
    final futureTask = Future.wait([
      for (final item in childrenId) purgeFunc(item),
    ]);
    await futureTask;
  }

  Future<void> purge(VirtualFileItemId fileId) async {
    await purgeFunc(fileId);
  }

  Future<void> restore(VirtualFileItemId fileId) async {
    await restoreFunc(fileId);
  }

  @override
  @Deprecated('TrashBin does not support adding children')
  bool addChild(VirtualFileItem child) {
    return false;
  }

  @override
  @Deprecated('TrashBin does not support adding children')
  bool addChildren(List<VirtualFileItem> children) {
    return false;
  }

  void deleteItem(VirtualFileItemId itemId) {
    childrenId.add(itemId);
  }
}

class StarFolder extends VirtualFolder {
  StarFolder({required super.id}) : super(name: '收藏夹', parentId: null);

  final List<VirtualFileItemId> starredFiles = [];

  void starFile(VirtualFileItemId fileId) {
    starredFiles.add(fileId);
  }

  void unstarFile(VirtualFileItemId fileId) {
    starredFiles.remove(fileId);
  }

  @override
  @Deprecated('StarFolder does not support adding children')
  bool addChild(VirtualFileItem child) {
    return false;
  }

  @override
  @Deprecated('StarFolder does not support adding children')
  bool addChildren(List<VirtualFileItem> children) {
    return false;
  }
}

class RootFolder extends VirtualFolder {
  RootFolder({required super.id}) : super(name: '根目录', parentId: null);

  Future<void> init() async {}
}
