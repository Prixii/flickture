import 'package:flickture/global.dart';
import 'package:flickture/virtual_file_system/file_item_mapper.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_file_item.dart';
import 'package:flutter/material.dart';
import 'package:flickture/virtual_file_system/virtual_file_item/virtual_folder.dart';

class VirtualFileSystemViewerScreen extends StatefulWidget {
  const VirtualFileSystemViewerScreen({super.key});

  @override
  State<VirtualFileSystemViewerScreen> createState() =>
      _VirtualFileSystemViewerScreenState();
}

class _VirtualFileSystemViewerScreenState
    extends State<VirtualFileSystemViewerScreen> {
  VirtualFolder? _rootFolder;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeFileManager();
  }

  Future<void> _initializeFileManager() async {
    try {
      setState(() {
        _rootFolder = vfm.root;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize VirtualFileManager: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual File System')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _rootFolder == null
          ? const Center(child: Text('No root folder found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: VirtualFolderViewer(
                folder: _rootFolder!,
                fileItemMapper: vfm.fileItemMapper,
              ),
            ),
    );
  }
}

/// 一个用于展示 VirtualFolder 及其子内容的树状列表 Widget。
/// 它接收一个 VirtualFolder 和一个 FileItemMapper 来获取子项的详细信息。
class VirtualFolderViewer extends StatelessWidget {
  final VirtualFolder folder;
  final FileItemMapper fileItemMapper;
  final int _indentationLevel; // 用于控制缩进

  const VirtualFolderViewer({
    super.key,
    required this.folder,
    required this.fileItemMapper,
    int indentationLevel = 0,
  }) : _indentationLevel = indentationLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 显示当前文件夹
        _buildItemRow(folder),
        // 递归显示子内容
        ...folder.childrenId.map((childId) {
          final childItem = fileItemMapper.getVirtualFileItemAny(childId);
          if (childItem == null) {
            return _buildNotFoundItem(childId);
          } else if (childItem is VirtualFolder) {
            return VirtualFolderViewer(
              folder: childItem,
              fileItemMapper: fileItemMapper,
              indentationLevel: _indentationLevel + 1,
            );
          } else if (childItem is VirtualFile) {
            return _buildItemRow(
              childItem,
              indentationLevel: _indentationLevel + 1,
            );
          }
          return Container(); // 未知类型不显示
        }),
      ],
    );
  }

  Widget _buildItemRow(VirtualFileItem item, {int? indentationLevel}) {
    final currentIndentation = indentationLevel ?? _indentationLevel;
    return Padding(
      padding: EdgeInsets.only(left: currentIndentation * 16.0), // 缩进
      child: Row(
        children: [
          Icon(item is VirtualFolder ? Icons.folder : Icons.insert_drive_file),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Name: ${item.name}${item is VirtualFolder ? 'count: ${item.childrenId.length}' : ''}',
              style: TextStyle(
                fontWeight: item is VirtualFolder
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundItem(String id) {
    return Padding(
      padding: EdgeInsets.only(left: (_indentationLevel + 1) * 16.0),
      child: Text(
        'Error: Item with ID "$id" not found.',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
