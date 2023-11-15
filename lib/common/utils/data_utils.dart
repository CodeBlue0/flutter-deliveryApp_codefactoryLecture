import 'package:codefactory/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String path) {
    return 'http://$ip/$path';
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((path) => pathToUrl(path)).toList();
  }
}
