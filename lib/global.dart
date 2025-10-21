import 'package:flickture/virtual_file_system/virtual_file_manager.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final vfm = VirtualFileManager();

final logger = _initLogger();
final uuid = Uuid();

Logger _initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  return Logger('flickture');
}
