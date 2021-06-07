# screen_shot_listen_plugin

Flutter监听手机截图的插件

加入依赖： git: url:https://github.com/fish89757/screen_shot_listen_plugin

开始监听： ScreenShotListenPlugin.instance.startListen()；

添加截屏事件回调,其中path为图片路径（path只在android中有效）： ScreenShotListenPlugin.instance.addScreenShotListener((path){});

添加android截屏时没有权限的回调，可在此回调中申请外部存储权限： ScreenShotListenPlugin.instance.addNoPermissionListener((){});

结束监听： ScreenShotListenPlugin.instance.stopListen()；

