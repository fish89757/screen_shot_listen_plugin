package com.quyaxinli.screen_shot_listen_plugin;

import androidx.annotation.NonNull;
import android.app.Activity;
import android.content.Context;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.BinaryMessenger;
import android.util.Log;

/**
 * ScreenShotListenPlugin
 */
public class ScreenShotListenPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {


    public static final String START_LISTEN = "startListen";
    public static final String STOP_LISTEN = "stopListen";
    public static final String CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL = "cece_screen_shot_listen_event_channel";
    public static EventChannel.EventSink screenShotEvent;
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    static private Context mContext;
    private ScreenShotListenManager screenShotListenManager;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "screen_shot_listen_plugin");
        channel.setMethodCallHandler(this);
        BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();
        mContext=flutterPluginBinding.getApplicationContext();
        registerScreenShotEvent(binaryMessenger);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "screen_shot_listen_plugin");
        channel.setMethodCallHandler(new ScreenShotListenPlugin());
        registerScreenShotEvent(registrar.messenger());
        mContext=registrar.context();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d("tag","screen_shot>>>>>>>>>>>>>>onMethodCall");
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals(START_LISTEN)) {
            screenShotListenManager=ScreenShotListenManager.newInstance(mContext);
            screenShotListenManager.startListen();
        } else if (call.method.equals(STOP_LISTEN)) {
            if(screenShotListenManager!=null){
                screenShotListenManager.stopListen();
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
//        Log.d("tag","screen_shot>>>>>>>>>>>>>>onAttachedToActivity");
//        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
//        Log.d("tag","screen_shot>>>>>>>>>>>>>>onReattachedToActivityForConfigChanges");
//        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        mContext = null;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private static void registerScreenShotEvent(BinaryMessenger binaryMessenger) {
        new EventChannel(binaryMessenger, CECE_SCREEN_SHOT_LISTEN_EVENT_CHANNEL).setStreamHandler(
                new EventChannel.StreamHandler() {

                    @Override
                    // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        screenShotEvent=events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                    }
                }
        );
    }

}
