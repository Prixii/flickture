import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hepler = AlbumHelper();
    hepler.getFirstImagePath().then((value) => print("wowowowowo$value"));
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

class AlbumHelper {
  /// 获取所有相册里的第一张图片路径
  Future<String?> getFirstImagePath() async {
    // 请求权限
    final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: false,
        ),
      ),
    );
    if (!ps.isAuth) {
      print('没有权限');
      return null; // 没有权限
    }

    // 获取相册列表
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) return null;

    // 获取第一个相册的资源
    final List<AssetEntity> photos = await albums[0].getAssetListRange(
      start: 0,
      end: 1, // 只取第一张
    );

    if (photos.isEmpty) return null;

    // 获取文件路径
    final file = await photos.first.file;
    return file?.path;
  }
}
