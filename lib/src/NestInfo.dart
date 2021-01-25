import 'dart:io' as io;
import 'package:flutter/foundation.dart' as found;
import 'package:flutter/material.dart';
import 'package:flutter_nest/src/NestPlatform.dart';



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

  /// If true, the application is running in debug mode
  static bool debugMode = found.kDebugMode;

  /// This will log info, only if `NestInfo.debugMode` is `true`. Setting the `debug` flag to `true`
  /// will call `debugPrint` as opposed to just `print`.
  static void log(Object object, {debug = false}) {
    if (debugMode) {
      if (debug) {
        debugPrint(object);
      } else {
        print(object);
      }
    }
  }

}