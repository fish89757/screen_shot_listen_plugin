import 'dart:async';

import 'package:flutter/services.dart';

class ScreenShotListenPlugin {

  static const String CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL = "cece_screen_shot_listen_event_channel";
  static const String STAR_LISTEN = "starListen";
  static const String STOP_LISTEN = "stopListen";
  static const String PLUGIN_NAME = "screen_shot_listen_plugin";

  static const MethodChannel _channel = const MethodChannel(PLUGIN_NAME);

  EventChannel _screenShotEventChannel = EventChannel(
      CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL);

  Function(String path) screenShotListener;

  static final ScreenShotListenPlugin _client = ScreenShotListenPlugin
      ._internal();

  factory ScreenShotListenPlugin() => _client;

  ScreenShotListenPlugin._internal() {
    _screenShotEventChannel
        .receiveBroadcastStream()
        .listen(onScreenShotEvent);
  }

  //开始监听
  startListen() {
    _channel.invokeMethod(STAR_LISTEN);
  }

  //结束监听
  stopListen() {
    _channel.invokeMethod(STOP_LISTEN);
  }

  //设置回调对象
  addScreenShotListener(Function(String path) listener) {
    screenShotListener = listener;
  }

  onScreenShotEvent(event) {
    print("screen_shot>>>>>>>>>>${event}");
    if (screenShotListener != null && event != null) {
      screenShotListener(event['path']);
    }
  }
}
