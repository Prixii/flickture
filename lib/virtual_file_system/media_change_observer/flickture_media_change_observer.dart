import 'package:flickture/global.dart';
import 'package:flickture/virtual_file_system/media_change_observer/media_change_observer.dart';

class FlicktureMediaChangeObserver implements MediaChangeObserver {
  @override
  void localFileCreated(String filePath) {
    logger.info('Local file created: $filePath');
  }

  @override
  void localFileDeleted(String filePath) {
    logger.info('Local file deleted: $filePath');
  }

  @override
  bool registerObserver() {
    // TODO: implement registerObserver
    return true;
  }

  @override
  bool unregisterObserver() {
    // TODO: implement unregisterObserver
    return true;
  }
}
