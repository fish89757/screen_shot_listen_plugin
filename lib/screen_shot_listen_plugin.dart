
import 'dart:async';

import 'package:flutter/services.dart';

class ScreenShotListenPlugin {
  static const MethodChannel _channel =
      const MethodChannel('screen_shot_listen_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
