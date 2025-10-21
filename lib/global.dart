import 'package:logging/logging.dart';

final logger = _initLogger();

Logger _initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  return Logger('flickture');
}
