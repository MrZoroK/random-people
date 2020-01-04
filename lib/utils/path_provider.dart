import 'package:path_provider/path_provider.dart';

class PathProvider {
  static String saveDir;
  static Future<void> init() async {
    saveDir = (await getApplicationDocumentsDirectory()).path;
  }
}