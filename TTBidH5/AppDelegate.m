//
//  AppDelegate.m
//  TTBidH5
//
//  Created by ysx on 2018/3/22.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <Foundation/NSValue.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AlipaySDK/AlipaySDK.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "AppDelegate.h"
#import "WKWebViewController.h"
#import "NetworkManager.h"
#import "WeiXinAction.h"
#import "TencentAction.h"
#import "WeiBoAction.h"
#import "ViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property BOOL isResumed;
@end

@implementation AppDelegate

#pragma mark - 注册push
- (void)registerAPNS {
    UIApplication *application = [UIApplication sharedApplication];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"用户点击允许");
            }else{
                NSLog(@"用户点击不允许");
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
        }];
    } else {
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
}

#pragma mark - 修改push的DeviceToken
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (UIUserNotificationTypeNone == notificationSettings.types) {
        [[NetworkManager instance] writeDeviceToken:@""];
    }
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == notificationSettings.types) {
        [[NetworkManager instance] writeDeviceToken:@""];
    } else {
        NSString *_deviceToken = @"";
        if (deviceToken && deviceToken.length > 0) {
            _deviceToken = [[[[deviceToken description]
                    stringByReplacingOccurrencesOfString: @"<" withString: @""]
                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                    stringByReplacingOccurrencesOfString: @" " withString: @""];
        }
        [[NetworkManager instance] writeDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == notificationSettings.types) {
        [[NetworkManager instance] writeDeviceToken:@""];
    }
}

#pragma mark - 处理push回掉
-(void)processPushData:(NSDictionary *)userInfo isBackground:(BOOL)isBackground {
    if (userInfo == nil) {
        return;
    }
    
    NSDictionary *actionDict = [userInfo objectForKey:@"action"];
    NSLog(@"push data: %@", actionDict);
    
#if DEBUG
//    NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:nil];
//    NSString *_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送消息" message:_data delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
#endif
    
    if (isBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_DATA" object:nil userInfo:actionDict];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:actionDict forKey:@"PUSH_DATA"];
        [userDefaults synchronize];
    }
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(application.applicationState != UIApplicationStateActive){
        [self processPushData:userInfo isBackground:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        if(application.applicationState != UIApplicationStateActive){
            [self processPushData:userInfo isBackground:YES];
        }
    }else{
        if(application.applicationState == UIApplicationStateBackground){
            [self processPushData:userInfo isBackground:YES];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        [self processPushData:userInfo isBackground:YES];
    }
}

#pragma mark - URL回掉
-(void)processURLData:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    // 内部协议头
    NSString *urlStr = [url absoluteString];
    if (![urlStr hasPrefix:@"ttbid://"]) {
        return;
    }
    
    // 空协议
    if(![urlStr containsString:@"?"]) {
        return;
    }
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSRange range = [urlStr rangeOfString:@"?"];
    NSString *propertys = [urlStr substringFromIndex:(int)(range.location + 1)];
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
    for (int i = 0 ; i < subArray.count; i++) {
        NSArray *dictArray = [subArray[i] componentsSeparatedByString:@"="];
        
        NSString *value = dictArray[1];
        value = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)value, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [actionDict setObject:value forKey:dictArray[0]];
    }
 
#if DEBUG
//    NSData *data = [NSJSONSerialization dataWithJSONObject:actionDict options:kNilOptions error:nil];
//    NSString *_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"URL消息" message:_data delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
#endif
    
    if (self.isResumed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"URL_DATA" object:nil userInfo:actionDict];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:actionDict forKey:@"URL_DATA"];
        [userDefaults synchronize];
    }
}

- (void) thirdpartyOpenURL:(NSURL *)url {
    // 手Q
    [TencentAction processURL:url];
    // 微信
    [WeiXinAction processURL:url];
    // 微博
    [WeiBoAction processURL:url];
    // 支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CompletionBlock alipayCompletionBlock = [NetworkManager instance].alipayCompletionBlock;
                if (alipayCompletionBlock != nil) {
                    alipayCompletionBlock(resultDict);
                }
            });
        }];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [self processURLData:url];
    [self thirdpartyOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self processURLData:url];
    [self thirdpartyOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [self processURLData:url];
    [self thirdpartyOpenURL:url];
    return YES;
}

#pragma mark - 几个生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isResumed = NO;
    
    // push
    [application setApplicationIconBadgeNumber:0];
    [self registerAPNS];
    
    // push数据
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self processPushData:userInfo isBackground:NO];
    
    // umeng
    [UMConfigure initWithAppkey:@UMENG_KEY channel:@CHANNEL_NAME];
#if DEBUG
    [MobClick setCrashReportEnabled:NO];
#else
    [MobClick setCrashReportEnabled:YES];
#endif
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:windowRect];
    
#if DEBUG
    WKWebViewController *viewController = [[WKWebViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
#else
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:@"reviewing"];
    if (obj != nil) {
        WKWebViewController *viewController = [[WKWebViewController alloc] init];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    } else {
        // 创建tabBarVc
        ViewController *tabBarVc = [[ViewController alloc] init];
        // 设置窗口的根控制器
        self.window.rootViewController = tabBarVc;
        // 显示窗口
        [self.window makeKeyAndVisible];
    }
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PAUSE" object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.isResumed = YES;
    [self registerAPNS];
    [application setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESUME" object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
