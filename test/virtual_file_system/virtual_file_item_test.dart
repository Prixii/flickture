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

    test('VirtualFolder should manage childrenId list initially', () {
      final folder = VirtualFolder(
        name: 'Parent Folder',
        id: 'folder_333',
        parentId: 'root',
      );

      expect(folder.childrenId, isEmpty);
    });

    test('VirtualFolder addChild should add child and set parentId', () {
      final folder = VirtualFolder(
        name: 'Test Folder',
        id: 'folder_444',
        parentId: 'parent_555',
      );
      final childFile = VirtualFile(
        name: 'Child File',
        id: 'child_999',
        parentId: null, // Initially null
      );

      expect(folder.addChild(childFile), isTrue);
      expect(folder.childrenId, contains('child_999'));
      expect(childFile.parentId, 'folder_444');
    });

    test(
      'VirtualFolder addChildren should add multiple children and set parentId',
      () {
        final folder = VirtualFolder(
          name: 'Multi Folder',
          id: 'folder_666',
          parentId: 'root',
        );

        final child1 = VirtualFile(
          name: 'Child 1',
          id: 'child_1',
          parentId: null,
        );
        final child2 = VirtualFolder(
          name: 'Child 2',
          id: 'child_2',
          parentId: null,
        );
        final children = [child1, child2];

        expect(folder.addChildren(children), isTrue);
        expect(folder.childrenId, hasLength(2));
        expect(folder.childrenId, containsAll(['child_1', 'child_2']));
        expect(child1.parentId, 'folder_666');
        expect(child2.parentId, 'folder_666');
      },
    );

    test('FileType enum should convert from string correctly', () {
      expect(FileType.fromString('jpg'), FileType.jpg);
      expect(FileType.fromString('png'), FileType.png);
      expect(FileType.fromString('mp4'), FileType.mp4);
      expect(FileType.fromString('mov'), FileType.mov);
      expect(FileType.fromString('gif'), FileType.gif);
      expect(
        FileType.fromString('other'),
        FileType.other,
      ); // Added 'other' type
      expect(FileType.fromString('unknown_ext'), FileType.unknown);
      expect(
        FileType.fromString(''),
        FileType.unknown,
      ); // Added test for empty string
    });

    test('VirtualFileItem should handle deletion state', () {
      final file = VirtualFile(
        name: 'temp.file',
        id: 'file_temp',
        parentId: 'folder_temp',
      );

      expect(file.isDeleted, false);
      file.isDeleted = true;
      expect(file.isDeleted, true);
    });

    test(
      'VirtualFileItem hasParent should return true if parentId is not null',
      () {
        final itemWithParent = VirtualFile(
          name: 'child.file',
          id: 'child_id',
          parentId: 'parent_id',
        );
        expect(itemWithParent.hasParent, isTrue);
      },
    );

    test(
      'VirtualFileItem hasParent should return false if parentId is null',
      () {
        final itemWithoutParent = VirtualFile(
          name: 'root.file',
          id: 'root_id',
          parentId: null,
        );
        expect(itemWithoutParent.hasParent, isFalse);
      },
    );

    test('VirtualFile generateThumbnail should throw UnimplementedError', () {
      final file = VirtualFile(
        name: 'test.mp4',
        id: 'file_thumb',
        parentId: 'folder_thumb',
      );
      expect(() => file.generateThumbnail(), throwsUnimplementedError);
    });
  });
}
