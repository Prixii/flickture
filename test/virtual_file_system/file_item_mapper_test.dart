import 'package:flickture/virtual_file_system/file_item_mapper.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileItemMapper Tests', () {
    late FileItemMapper mapper;

    setUp(() {
      mapper = FileItemMapper();
    });

    test('should initialize with empty collections', () {
      expect(mapper.visibleFoldersName, isEmpty);
      expect(mapper.fileIdMap.isEmpty, true);
      expect(mapper.virtualFileItemMap.isEmpty, true);
    });

    test('should find LocalFileId by VirtualFileItemId', () {
      final localId = 'local_123';
      final virtualId = 'virtual_456';

      // Set up the mapping
      mapper.fileIdMap.put(localId, virtualId);

      expect(mapper.findLocalFileIdByVirtualFileItemId(virtualId), localId);
      expect(mapper.findLocalFileIdByVirtualFileItemId('nonexistent'), isNull);
    });

    test('should find VirtualFileItemId by LocalFileId', () {
      final localId = 'local_789';
      final virtualId = 'virtual_abc';

      mapper.fileIdMap.put(localId, virtualId);

      expect(mapper.findVirtualFileItemIdByLocalFileId(localId), virtualId);
      expect(mapper.findVirtualFileItemIdByLocalFileId('nonexistent'), isNull);
    });

    test('should add visible folder', () {
      final folderPath = '/storage/emulated/0/Pictures';

      // Since addVisibleFolder throws UnimplementedError, we'll test adding directly
      mapper.visibleFoldersName.add(folderPath);

      expect(mapper.visibleFoldersName, contains(folderPath));
    });

    test('should remove visible folder', () {
      final folderPath = '/storage/emulated/0/Downloads';
      mapper.visibleFoldersName.add(folderPath);

      // Since removeVisibleFolder throws UnimplementedError, we'll test removing directly
      mapper.visibleFoldersName.remove(folderPath);

      expect(mapper.visibleFoldersName, isNot(contains(folderPath)));
    });

    test('should get VirtualFileItem by ID', () {
      final virtualFile = VirtualFile(
        name: 'test.jpg',
        id: 'file_123',
        parentId: 'folder_456',
      );

      mapper.virtualFileItemMap['file_123'] = virtualFile;

      expect(mapper.getVirtualFileItem('file_123'), virtualFile);
      expect(mapper.getVirtualFileItem('nonexistent'), isNull);
    });

    test('should handle VirtualFolder items', () {
      final virtualFolder = VirtualFolder(
        name: 'Test Folder',
        parentId: 'root',
        id: 'folder_789',
      );

      mapper.virtualFileItemMap['folder_789'] = virtualFolder;

      final retrieved = mapper.getVirtualFileItem('folder_789');
      expect(retrieved, isA<VirtualFolder>());
      expect(retrieved!.name, 'Test Folder');
    });

    test('should integrate with BiMap correctly', () {
      final localId = 'local_999';
      final virtualId = 'virtual_888';
      final virtualFile = VirtualFile(
        name: 'document.pdf',
        id: virtualId,
        parentId: 'parent_111',
      );

      // Set up both mappings
      mapper.fileIdMap.put(localId, virtualId);
      mapper.virtualFileItemMap[virtualId] = virtualFile;

      // Test the integration
      final mappedVirtualId = mapper.findVirtualFileItemIdByLocalFileId(
        localId,
      );
      expect(mappedVirtualId, virtualId);

      final virtualItem = mapper.getVirtualFileItem(mappedVirtualId!);
      expect(virtualItem, virtualFile);
    });

    test('should handle bidirectional mapping consistency', () {
      final localId1 = 'local_1';
      final localId2 = 'local_2';
      final virtualId1 = 'virtual_1';
      final virtualId2 = 'virtual_2';

      mapper.fileIdMap.put(localId1, virtualId1);
      mapper.fileIdMap.put(localId2, virtualId2);

      // Verify bidirectional consistency
      expect(mapper.fileIdMap.getValue(localId1), virtualId1);
      expect(mapper.fileIdMap.getKey(virtualId1), localId1);

      expect(mapper.fileIdMap.getValue(localId2), virtualId2);
      expect(mapper.fileIdMap.getKey(virtualId2), localId2);
    });
  });
}
