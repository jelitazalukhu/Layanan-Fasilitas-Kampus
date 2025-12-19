import 'package:flutter/foundation.dart';

class AppConfig {
  static String get serverUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.31.61.92:3000'; // IP Address: 10.31.61.92
    } else {
      return 'http://localhost:3000';
    }
  }

  static String get baseUrl => '$serverUrl/api';
}
