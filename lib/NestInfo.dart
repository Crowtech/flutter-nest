import 'dart:io' as io;
import 'package:flutter/foundation.dart' as found;

///An enum storing each platform the application might be running on
enum Platform {
  android,
  ios,
  web,
  unknown
}

/// This class contains methods for getting information about the application, such as platform, and whether or not it is running in debug mode
class NestInfo {

  static Platform getPlatform() {
    
    Platform platform;

    try {
      if (io.Platform.isAndroid) {
        platform = Platform.android;
      } else if (io.Platform.isIOS) {
        platform = Platform.ios;
      } else {
        platform = Platform.unknown;
      }
    } catch (e) {
      platform = Platform.web;
    }

    return platform;
  }

  static bool debugMode = found.kDebugMode;

  static void log(Object object) {
    if (debugMode) print(object);
  }

}