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

#import <Appirater/Appirater.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ja_JP
    NSLog(@"localeIdentifier: %@", [[NSLocale currentLocale] localeIdentifier]);
    
    //전제조건 : iphone, applewatch 상호간 세션 활성화가 되어있어야 함
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [DBManager syncDBFileToWatch];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [Appirater appEnteredForeground:YES];
    
    //MARK: TimeCardSummaryを更新する
    [[TimeCardSummaryDao new] updateTimeCardSummaryTableAll];
}

/** Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished. */
- (void)session:(WCSession *)session didFinishFileTransfer:(WCSessionFileTransfer *)fileTransfer error:(nullable NSError *)error{
    //파일 전송 세션 결과 표시
    NSLog(@"%s: session = %@ fileTransfer = %@ error = %@", __func__, session, fileTransfer, error);
    
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

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

#pragma mark - WCSessionDelegate
// Interactive Message
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler
{
    
    NSDictionary *watch_message = message[@"watchapp"];
    
    NSString *command = watch_message[@"command"];
    NSDictionary *params = watch_message[@"param"];
    
    if ([command isEqualToString:@"fetch_summary"]) {
        
        TimeCardSummaryDao *timeCardSummaryDao = [[TimeCardSummaryDao alloc] init];
        NSArray *items = [timeCardSummaryDao fetchModelStartMonth:params[@"startMonth"]
                                                         EndMonth:params[@"endMonth"]
                                                        ascending:[params[@"ascending"] boolValue]];
        
        
        //Dictionaryで変換
        NSMutableArray *result_items = [NSMutableArray new];
        for (TimeCardSummary *summary in items) {
            NSDictionary *dict = [summary dictionary];
            [result_items addObject:dict];
        }
        
        replyHandler(@{@"data":result_items});
        
        return;
    }
    else if ([command isEqualToString:@"fetch_today_timecard"]) {
        
        NSDate *today = [NSDate date];
        TimeCardDao *timeCardDao = [[TimeCardDao alloc] init];
        NSArray *items = [timeCardDao fetchModelYear:[today getYear]
                                               month:[today getMonth]];
        
        //Dictionaryで変換
        NSMutableArray *result_items = [NSMutableArray new];
        for (TimeCard *time_card in items) {
            NSDictionary *dict = [time_card dictionary];
            [result_items addObject:dict];
        }
        
        replyHandler(@{@"data":result_items});
        
        return;
        
    }
    else if ([command isEqualToString:@"fetch_graph_date"]) {
        
        TimeCardDao *dao = [[TimeCardDao alloc] init];
        NSString *dateString = params[@"date"];
        
        NSArray *weekTimeCards = [dao fetchModelGraphDate:[NSDate convDate2String:dateString]];
        
        //Dictionaryで変換
        NSMutableArray *result_items = [NSMutableArray new];
        for (TimeCard *time_card in weekTimeCards) {
            NSDictionary *dict = [time_card dictionary];
            [result_items addObject:dict];
        }
        
        replyHandler(@{@"data":result_items});
        
        return;
    }
    else if ([command isEqualToString:@"fetch_year_month"]) {
        
        TimeCardDao *dao = [TimeCardDao new];
        NSArray *items = [dao fetchModelYear:[params[@"year"] intValue]
                                       month:[params[@"month"] intValue]];
        
        //Dictionaryで変換
        NSMutableArray *result_items = [NSMutableArray new];
        for (TimeCard *time_card in items) {
            NSDictionary *dict = [time_card dictionary];
            [result_items addObject:dict];
        }
        
        replyHandler(@{@"data":result_items});
        
        return;
    }
    else if ([command isEqualToString:@"fetch_work_day"]) {
        
        TimeCardDao *dao = [TimeCardDao new];
        NSInteger workDayCount = [dao fetchModelWorkDayYear:[params[@"year"] intValue]
                                                      month:[params[@"month"] intValue]];
        
        replyHandler(@{@"data":@(workDayCount)});
        
        return;
    }
}
@end
