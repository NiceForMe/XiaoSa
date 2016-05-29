//
//  AppDelegate.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "AppDelegate.h"
#import "LXTabBarController.h"
#import "LXLeftViewController.h"
#import <RESideMenu.h>
#import <BPush.h>
#import "LXDataManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
@interface AppDelegate ()<RESideMenuDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置启动时间
//    [NSThread sleepForTimeInterval:3.0];
    //创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //设置根控制器
    LXTabBarController *tabVC = [[LXTabBarController alloc]init];
    LXLeftViewController *leftVC = [[LXLeftViewController alloc]init];
    RESideMenu *menu = [[RESideMenu alloc]initWithContentViewController:tabVC leftMenuViewController:leftVC rightMenuViewController:nil];
    menu.backgroundImage = [UIImage imageNamed:@"MenuBackgroundImage"];
    menu.menuPreferredStatusBarStyle = 1;
    menu.delegate = self;
    menu.contentViewShadowColor = [UIColor blackColor];
    menu.contentViewShadowOffset = CGSizeMake(0, 0);
    menu.contentViewShadowOpacity = 0.6;
    menu.contentViewShadowRadius = 12;
    menu.contentViewShadowEnabled = YES;
    self.window.rootViewController = menu;
    [self.window makeKeyAndVisible];
    //推送
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:myTypes];
    }
    //app启动时注册百度云推送服务，需要提供apikey
    [BPush registerChannel:launchOptions apiKey:@"jRHszavDykgIEMy2h2wmo5TC" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:nil isDebug:YES];
    //用户点击推送消息启动jRHszavDykgIEMy2h2wmo5TC
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    [self share];
    return YES;
}
#pragma mark - share
- (void)share
{
    [ShareSDK registerApp:@"1013fe04935dc" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"4135760488" appSecret:@"e21dcc010f03c7512dc0af5c75a0dd5e" redirectUri:@"www.baidu.com" authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}
//用户点击通知，应该在前台或者后台调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    //应用在前台或者后台状态下，是否跳转页面，让用户选择
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
    }];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //app收到推送的通知
    [BPush handleNotification:userInfo];
    //应用在前台，或者后台开启状态下，不跳转页面，让用户选择
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}
+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)shareVideoData
{
    [[LXDataManager shareManager]getSidArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html" success:^(NSArray *sidArray, NSArray *videoArray) {
        self.sidArray = [NSArray arrayWithArray:sidArray];
        self.videoArray = [NSArray arrayWithArray:videoArray];
    } failed:^(NSError *error) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
