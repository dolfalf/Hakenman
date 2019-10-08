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
#import "TimeCardDao.h"
#import "NSDate+Helper.h"
#import "TimeCardSummary+NSDictionary.h"
#import "TimeCard+NSDictionary.h"

#import <StoreKit/StoreKit.h>

static NSInteger const kAppLaunchCount = 10;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //ja_JP
    NSLog(@"localeIdentifier: %@", [[NSLocale currentLocale] localeIdentifier]);
    
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
    
    if (![self isAlreadyDisplayed]) {
        [self requestReview];
    }
    
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

}

#pragma mark - migration helper methods
- (BOOL)isEqualAndOlderVersion:(NSString *)ver {
    
    //version1.0.2->102にして比較
    NSArray *v_arrays = [ver componentsSeparatedByString:@"."];
    if ([v_arrays count] == 3) {
        int num_ver = [v_arrays[0] intValue] * 100
        + [v_arrays[1] intValue] * 10
        + [v_arrays[2] intValue] * 1;
        
        NSArray *c_arrays = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]componentsSeparatedByString:@"."];
        
        int curr_num_ver = [c_arrays[0] intValue] * 100
        + [c_arrays[1] intValue] * 10
        + [c_arrays[2] intValue] * 1;
        
        NSLog(@"check version:[%d], current version[%d]", num_ver, curr_num_ver);
        if (num_ver <= curr_num_ver) {
            return YES;
        }
    }
    
    return NO;
}

- (void)requestReview {
    
    NSInteger count = [self applicationLaunchCounting];
    
    if (count != kAppLaunchCount) {
        return;
    }
    
    [self showReviewAlert];
}

- (void)showReviewAlert
{
    [SKStoreReviewController requestReview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[AppDelegate userdefaultKeyisAlreadyDisplayed]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[AppDelegate userdefaultKeyisRequestReview]];
}

- (NSInteger)applicationLaunchCounting
{
    NSString *key  = [AppDelegate userdefaultKeyisRequestReview];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    [[NSUserDefaults standardUserDefaults] setInteger:count +=1 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return count;
}

- (BOOL)isAlreadyDisplayed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[AppDelegate userdefaultKeyisAlreadyDisplayed]];
}

+ (NSString *)userdefaultKeyisRequestReview {
    return @"requestReview";
}


+ (NSString *)userdefaultKeyisAlreadyDisplayed {
    return @"alreadyDisplayed";
}

- (NSString *)sampletest {
    return @"sampletest";
}
@end
