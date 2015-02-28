//
//  AppDelegate.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "TimeCardSummaryDao.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarHidden = NO;

    
    //TODO: Parseへrelease用認定証を登録する必要がある。
    //parseによるNotification登録
    [Parse setApplicationId:@"tXDVIqH5a5N9TPCJsIPmfJdW0HQDwBD46GN9Xdjv"
                  clientKey:@"u4O54cwrZHTIxrL2cn67T3hzXV0lmFHVq6mrqQac"];
    
    
    //ja_JP
    NSLog(@"localeIdentifier: %@", [[NSLocale currentLocale] localeIdentifier]);
    
    //言語別Notificationを通知するため
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setObject:[[NSLocale currentLocale] localeIdentifier] forKey:@"locale"];
    [installation saveInBackground];

    //iOS8 Notification対応
    //参照：
    // http://corinnekrych.blogspot.jp/2014/07/how-to-support-push-notification-for.html
    // http://blog.parse.com/2014/09/15/ready-for-ios-8-so-is-parse-push/
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //iOS8
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    } else {
        //before iOS7
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
#ifdef TEST_FLIGHT_ENABLE
    [TestFlight takeOff:@"f252a090-9e2d-41b4-a4d4-599bb9695f32"];
#endif
    
#ifdef GOOGLE_ANALYTICS_ENABLE
    // initialization: Google Analytics
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.dispatchInterval = 5;
    [[gai logger] setLogLevel:kGAILogLevelError]; // ログレベルを変えることができる
    [gai trackerWithTrackingId:GOOGLE_ANALYTICS_ID];
#endif
    
    //create instance.
    [AdvertisingManager sharedADBannerView];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //MARK: TimeCardSummaryを更新する
    [[TimeCardSummaryDao new] updateTimeCardSummaryTableAll];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
}

@end
