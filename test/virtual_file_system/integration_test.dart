import 'package:flickture/virtual_file_system/bi_map.dart';
import 'package:flickture/virtual_file_system/file_item_mapper.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Virtual File System Integration Tests', () {
    late FileItemMapper mapper;
    late BiMap<LocalFileId, VirtualFileItemId> biMap;

    setUp(() {
      mapper = FileItemMapper();
      biMap = mapper.fileIdMap;
    });

    test('should integrate file creation with mapping system', () {
      // Create a virtual file
      final virtualFile = VirtualFile(
        name: 'photo.jpg',
        id: 'virtual_123',
        parentId: 'folder_456',
      );

      // Create mapping
      biMap.put('local_789', 'virtual_123');

      // Register virtual item
      mapper.virtualFileItemMap['virtual_123'] = virtualFile;

      // Test bidirectional lookup
      final foundVirtualId = mapper.findVirtualFileItemIdByLocalFileId(
        'local_789',
      );
      expect(foundVirtualId, 'virtual_123');

      final foundLocalId = mapper.findLocalFileIdByVirtualFileItemId(
        'virtual_123',
      );
      expect(foundLocalId, 'local_789');

      final retrievedFile = mapper.getVirtualFileItem('virtual_123');
      expect(retrievedFile, virtualFile);
      expect(retrievedFile!.name, 'photo.jpg');
    });

    test('should handle folder hierarchy integration', () {
      // Create folder structure
      final rootFolder = VirtualFolder(
        name: 'Root',
        id: 'root_folder',
        parentId: null,
      );

      final childFolder = VirtualFolder(
        name: 'Pictures',
        id: 'pictures_folder',
        parentId: 'root_folder',
      );

      final photoFile = VirtualFile(
        name: 'vacation.jpg',
        id: 'photo_1',
        parentId: 'pictures_folder',
      );

      // Setup mappings and registrations
      mapper.virtualFileItemMap['root_folder'] = rootFolder;
      mapper.virtualFileItemMap['pictures_folder'] = childFolder;
      mapper.virtualFileItemMap['photo_1'] = photoFile;

      // Add children to folders (since unimplemented, add directly)
      rootFolder.childrenId.add('pictures_folder');
      childFolder.childrenId.add('photo_1');

      // Test the hierarchy
      final root = mapper.getVirtualFileItem('root_folder') as VirtualFolder;
      final pictures =
          mapper.getVirtualFileItem('pictures_folder') as VirtualFolder;
      final photo = mapper.getVirtualFileItem('photo_1');

      expect(root.childrenId, contains('pictures_folder'));
      expect(pictures.childrenId, contains('photo_1'));
      expect(photo!.parentId, 'pictures_folder');
      expect(pictures.parentId, 'root_folder');
    });

    test(
      'should manage multiple file types with proper extension detection',
      () {
        const testFiles = [
          {'name': 'image.jpg', 'expectedExtension': 'jpg'},
          {'name': 'video.mp4', 'expectedExtension': 'mp4'},
          {'name': 'animation.gif', 'expectedExtension': 'gif'},
          {'name': 'complex.name.with.dots.png', 'expectedExtension': 'png'},
        ];

        for (var i = 0; i < testFiles.length; i++) {
          final testFile = testFiles[i];
          final virtualFile = VirtualFile(
            name: testFile['name']!,
            id: 'file_$i',
            parentId: 'folder_$i',
          );

          mapper.virtualFileItemMap['file_$i'] = virtualFile;
          biMap.put('local_$i', 'file_$i');

          // Test extension detection
          expect(
            virtualFile.getFileType(testFile['name']!),
            testFile['expectedExtension'],
          );

          // Test full integration
          final virtualId = mapper.findVirtualFileItemIdByLocalFileId(
            'local_$i',
          );
          expect(virtualId, 'file_$i');

          final retrievedFile =
              mapper.getVirtualFileItem(virtualId!) as VirtualFile;
          expect(retrievedFile.name, testFile['name']!);
          expect(
            retrievedFile.getFileType(testFile['name']!),
            testFile['expectedExtension'],
          );
        }
      },
    );

    test('should handle renaming operations consistently', () {
      final originalFile = VirtualFile(
        name: 'old_name.jpg',
        id: 'file_rename_test',
        parentId: 'folder_rename',
      );

      mapper.virtualFileItemMap['file_rename_test'] = originalFile;
      biMap.put('local_rename', 'file_rename_test');

      // Rename the file
      originalFile.rename('new_name.jpg');

      // Test that the mapping remains consistent
      final virtualId = mapper.findVirtualFileItemIdByLocalFileId(
        'local_rename',
      );
      final retrievedFile = mapper.getVirtualFileItem(virtualId!);

      expect(retrievedFile!.name, 'new_name.jpg');
      // Extension should still be correctly detected
      expect((retrievedFile as VirtualFile).getFileType('new_name.jpg'), 'jpg');
    });

    test('should handle complex mapping scenarios', () {
      // Setup multiple files and folders
      final folder1 = VirtualFolder(
        name: 'Folder 1',
        id: 'f1',
        parentId: 'root',
      );
      final folder2 = VirtualFolder(
        name: 'Folder 2',
        id: 'f2',
        parentId: 'root',
      );

      final files = [
        VirtualFile(name: 'file1.jpg', id: 'file1', parentId: 'f1'),
        VirtualFile(name: 'file2.mp4', id: 'file2', parentId: 'f1'),
        VirtualFile(name: 'file3.png', id: 'file3', parentId: 'f2'),
      ];

      // Register all items
      mapper.virtualFileItemMap['f1'] = folder1;
      mapper.virtualFileItemMap['f2'] = folder2;
      mapper.virtualFileItemMap['file1'] = files[0];
      mapper.virtualFileItemMap['file2'] = files[1];
      mapper.virtualFileItemMap['file3'] = files[2];

      // Setup bidirectional mappings
      final mappings = {
        'local_f1': 'f1',
        'local_f2': 'f2',
        'local_file1': 'file1',
        'local_file2': 'file2',
        'local_file3': 'file3',
      };

      mappings.forEach((localId, virtualId) {
        biMap.put(localId, virtualId);
      });

      // Test comprehensive lookup
      mappings.forEach((localId, virtualId) {
        expect(mapper.findVirtualFileItemIdByLocalFileId(localId), virtualId);
        expect(mapper.findLocalFileIdByVirtualFileItemId(virtualId), localId);

        final item = mapper.getVirtualFileItem(virtualId);
        expect(item, isNotNull);
      });

      // Test that BiMap maintains uniqueness
      expect(() => biMap.put('local_f1', 'duplicate'), throwsArgumentError);
      expect(() => biMap.put('duplicate', 'f1'), throwsArgumentError);
    });

    test('should handle empty and edge cases', () {
      // Test with empty mapper
      expect(mapper.fileIdMap.isEmpty, true);
      expect(mapper.virtualFileItemMap.isEmpty, true);

      // Test non-existent lookups
      expect(mapper.findVirtualFileItemIdByLocalFileId('nonexistent'), isNull);
      expect(mapper.findLocalFileIdByVirtualFileItemId('nonexistent'), isNull);
      expect(mapper.getVirtualFileItem('nonexistent'), isNull);

      // Test that adding items works correctly
      final testFolder = VirtualFolder(
        name: 'Test',
        id: 'test_id',
        parentId: null,
      );

      mapper.virtualFileItemMap['test_id'] = testFolder;
      biMap.put('local_test', 'test_id');

      expect(mapper.fileIdMap.isNotEmpty, true);
      expect(mapper.virtualFileItemMap.isNotEmpty, true);
    });
  });
}
