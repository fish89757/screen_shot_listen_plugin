#import "ScreenShotListenPlugin.h"

@interface ScreenShotListenPlugin()<FlutterStreamHandler>
{
    /// 用于主动传值给flutter的桥梁.
    FlutterEventSink _eventSink;
}


@end

@implementation ScreenShotListenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"screen_shot_listen_plugin"
            binaryMessenger:[registrar messenger]];
  ScreenShotListenPlugin* instance = [[ScreenShotListenPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"cece_screen_shot_listen_event_channel" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(userDidTakeScreenshot:)
//            name:UIApplicationUserDidTakeScreenshotNotification object:nil];
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"startListen" isEqualToString:call.method]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(userDidTakeScreenshot:)
            name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    } else if ([@"stopListen" isEqualToString:call.method]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
//    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    if (_eventSink) {
//        _eventSink(imageData);
        _eventSink(@{@"path": @"/path"});
    }
//    NSLog(@"%@", imageData);
    
}


- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return UIImagePNGRepresentation(image);
}


#pragma mark - OC给flutterc传值 获取deviceToken
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    _eventSink = events;
    return nil;
}
- (FlutterError *)onCancelWithArguments:(id)arguments{
    _eventSink = nil;
    return nil;
}

@end
