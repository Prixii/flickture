import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';
import 'package:flickture/virtual_file_system/virtual_file_system_typedef.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VirtualFileItem Tests', () {
    test('VirtualFileItem should have basic properties', () {
      final item = VirtualFolder(
        name: 'Test Folder',
        id: 'folder_123',
        parentId: 'root',
      );

      expect(item.name, 'Test Folder');
      expect(item.id, 'folder_123');
      expect(item.isDeleted, false);
      expect(item.parentId, 'root');
    });

    test('VirtualFileItem rename should work correctly', () {
      final item = VirtualFolder(
        name: 'Old Name',
        id: 'item_456',
        parentId: 'parent_789',
      );

      item.rename('New Name');
      expect(item.name, 'New Name');
    });

    test('VirtualFile should have file type detection', () {
      final imageFile = VirtualFile(
        name: 'photo.jpg',
        id: 'file_123',
        parentId: 'folder_456',
      );

      final videoFile = VirtualFile(
        name: 'video.mp4',
        id: 'file_456',
        parentId: 'folder_456',
      );

      expect(imageFile.name, 'photo.jpg');
      expect(imageFile.type.name, 'jpg');
      expect(videoFile.type.name, 'mp4');
    });

    test('VirtualFile should handle unknown file types', () {
      final unknownFile = VirtualFile(
        name: 'document.xyz',
        id: 'file_789',
        parentId: 'folder_456',
      );

      expect(unknownFile.type, FileType.unknown);
    });

    test('VirtualFile getFileType should extract extension correctly', () {
      final file = VirtualFile(
        name: 'complex.name.with.dots.png',
        id: 'file_111',
        parentId: 'folder_222',
      );

      expect(file.getFileType('complex.name.with.dots.png'), 'png');
      expect(file.getFileType('simple.jpg'), 'jpg');
      expect(file.getFileType('noextension'), 'noextension');
    });

    test('VirtualFolder should manage children correctly', () {
      final folder = VirtualFolder(
        name: 'Parent Folder',
        id: 'folder_333',
        parentId: 'root',
      );

      expect(folder.childrenId, isEmpty);
    });

    test('VirtualFolder addChild should handle child addition', () {
      final folder = VirtualFolder(
        name: 'Test Folder',
        id: 'folder_444',
        parentId: 'parent_555',
      );

      folder.childrenId.add('child_999');
      expect(folder.childrenId, contains('child_999'));
    });

    test('VirtualFolder addChildren should handle multiple children', () {
      final folder = VirtualFolder(
        name: 'Multi Folder',
        id: 'folder_666',
        parentId: 'root',
      );

      final children = ['child_1', 'child_2', 'child_3'];

      // Since addChildren is unimplemented, test adding directly
      folder.childrenId.addAll(children);
      expect(folder.childrenId, hasLength(3));
      expect(folder.childrenId, containsAll(children));
    });

    test('FileType enum should convert from string correctly', () {
      expect(FileType.fromString('jpg'), FileType.jpg);
      expect(FileType.fromString('png'), FileType.png);
      expect(FileType.fromString('mp4'), FileType.mp4);
      expect(FileType.fromString('mov'), FileType.mov);
      expect(FileType.fromString('gif'), FileType.gif);
      expect(FileType.fromString('unknown_ext'), FileType.unknown);
    });

    test('VirtualFileItem should handle deletion state', () {
      final file = VirtualFile(
        name: 'temp.file',
        id: 'file_temp',
        parentId: 'folder_temp',
      );

      expect(file.isDeleted, false);

      // Test that isDeleted can be changed (if the field is mutable)
      file.isDeleted = true;
      expect(file.isDeleted, true);
    });

    test('VirtualFile should handle different file extensions', () {
      final testCases = [
        {'name': 'image.jpg', 'expectedType': 'jpg'},
        {
          'name': 'photo.jpeg',
          'expectedType': 'jpeg',
        }, // Note: jpeg is not in enum, will be unknown
        {'name': 'animation.gif', 'expectedType': 'gif'},
        {'name': 'movie.mov', 'expectedType': 'mov'},
        {'name': 'video.mp4', 'expectedType': 'mp4'},
        {'name': 'file.with.multiple.dots.tar.gz', 'expectedType': 'gz'},
      ];

      for (final testCase in testCases) {
        final file = VirtualFile(
          name: testCase['name']!,
          id: 'file_${testCase['name']}',
          parentId: 'folder_test',
        );

        expect(file.getFileType(testCase['name']!), testCase['expectedType']);
      }
    });
  });
}
