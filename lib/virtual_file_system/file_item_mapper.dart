import 'package:flickture/global.dart';
import 'package:flickture/virtual_file_system/bi_map.dart';
import 'package:flickture/virtual_file_system/exception/virtual_file_system_exception.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_utils.dart';
import 'package:photo_manager/photo_manager.dart';

class FileItemMapper {
  late final Set<String> visibleFoldersName;
  late final BiMap<LocalFileId, VirtualFileItemId> fileIdMap;
  late final Map<VirtualFileItemId, VirtualFileItem> virtualFileItemMap;

  FileItemMapper() {
    visibleFoldersName = {};
    fileIdMap = BiMap();
    virtualFileItemMap = {};
  }

  Future<List<VirtualFolder>> init() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) {
      logger.warning("no albums");
    }

    final virtualFolders = <VirtualFolder>[];
    for (final album in albums) {
      if (album.name == 'Recent') continue;
      visibleFoldersName.add(album.name);
      final albumVirtualFolder = await initSingleAlbum(album);
      virtualFolders.add(albumVirtualFolder);
    }
    return virtualFolders;
  }

  Future<List<VirtualFolder>> initFromFile() async {
    throw UnimplementedError();
  }

  Future<VirtualFolder> initSingleAlbum(AssetPathEntity album) async {
    final mediaCount = await album.assetCountAsync;
    final mediaList = await album.getAssetListRange(start: 0, end: mediaCount);

    final albumVirtualFolder = createNewVirtualFolder(name: album.name);
    virtualFileItemMap[albumVirtualFolder.id] = albumVirtualFolder;

    for (final media in mediaList) {
      final originalFile = await media.originFile;
      if (originalFile == null) {
        continue;
      }
      try {
        final mediaVirtualFile = createNewVirtualFile(
          name: extractFileName(originalFile.path),
          parentId: albumVirtualFolder.id,
          localFileId: media.id,
        );
        virtualFileItemMap[mediaVirtualFile.id] = mediaVirtualFile;
        albumVirtualFolder.addChild(mediaVirtualFile);
      } catch (e) {
        logger.warning(
          'duplicate in album: ${album.name}, media: ${originalFile.path}',
        );
      }
    }
    return albumVirtualFolder;
  }

  VirtualFolder createNewVirtualFolder({String name = ''}) {
    final virtualFolderId = generateNewVirtualFileItemId();
    final virtualFolder = VirtualFolder(
      name: name,
      parentId: '',
      id: virtualFolderId,
    );
    virtualFileItemMap[virtualFolderId] = virtualFolder;
    return virtualFolder;
  }

  VirtualFile createNewVirtualFile({
    String name = '',
    VirtualFileItemId parentId = '',
    LocalFileId localFileId = '',
  }) {
    final virtualFileId = generateNewVirtualFileItemId();
    final virtualFile = VirtualFile(
      name: name,
      parentId: parentId,
      id: virtualFileId,
    );
    virtualFileItemMap[virtualFileId] = virtualFile;
    fileIdMap.put(localFileId, virtualFileId);
    return virtualFile;
  }

  LocalFileId? findLocalFileIdByVirtualFileItemId(VirtualFileItemId id) {
    return fileIdMap.getKey(id);
  }

  VirtualFileItemId? findVirtualFileItemIdByLocalFileId(LocalFileId id) {
    return fileIdMap.getValue(id);
  }

  bool addVisibleFolder(String folderName) {
    if (visibleFoldersName.contains(folderName)) {
      return false;
    }

    visibleFoldersName.add(folderName);
    return true;
  }

  bool removeVisibleFolder(String folderName) {
    if (!visibleFoldersName.contains(folderName)) {
      return false;
    }

    visibleFoldersName.remove(folderName);
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

  bool registerVirtualFileItem(VirtualFileItem item) {
    if (virtualFileItemMap.containsKey(item.id)) {
      return false;
    }

    virtualFileItemMap[item.id] = item;
    return true;
  }
}
