import 'package:flutter/services.dart';

class ScreenShotListenPlugin {
  static const String CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL =
      "cece_screen_shot_listen_event_channel";
  static const String START_LISTEN = "startListen";
  static const String STOP_LISTEN = "stopListen";
  static const String PLUGIN_NAME = "screen_shot_listen_plugin";

  static const MethodChannel _channel = const MethodChannel(PLUGIN_NAME);

  EventChannel _screenShotEventChannel =
      const EventChannel(CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL);

  Function(String path) screenShotListener;

  // 工厂模式
  factory ScreenShotListenPlugin() => _getInstance();

  static ScreenShotListenPlugin get instance => _getInstance();
  static ScreenShotListenPlugin _instance;

  ScreenShotListenPlugin._internal() {
    // 初始化
    _screenShotEventChannel.receiveBroadcastStream().listen((data) {
      if (screenShotListener != null) {
        screenShotListener(data['path']);
      }
    });
  }

  static ScreenShotListenPlugin _getInstance() {
    if (_instance == null) {
      _instance = new ScreenShotListenPlugin._internal();
    }
    return _instance;
  }

  //开始监听
  startListen() {
    _channel.invokeMethod(START_LISTEN);
  }

  //结束监听
  stopListen() {
    _channel.invokeMethod(STOP_LISTEN);
  }

  //设置回调对象
  addScreenShotListener(Function(String path) listener) {
    screenShotListener = listener;
  }
}
