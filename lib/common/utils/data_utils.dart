import 'dart:convert';

import 'package:codefactory/common/const/data.dart';

class DataUtils {
  static DateTime stringToDateTime(String value) {
    if (value is DateTime) {
      return DateTime.parse(value);
    } else {
      print("지금 시간으로 반환");
      return DateTime.now();
    }
  }

  static String pathToUrl(String path) {
    return 'http://$ip/$path';
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((path) => pathToUrl(path)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(plain);
  }
}
