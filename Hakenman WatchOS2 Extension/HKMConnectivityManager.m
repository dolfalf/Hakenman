//
//  HKMConnectivityManager.m
//  Hakenman
//
//  Created by lee jaeeun on 2016/08/17.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "HKMConnectivityManager.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "DBManager.h"

@interface HKMConnectivityManager () <WCSessionDelegate>

@end

@implementation HKMConnectivityManager

+ (id)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self sessionConnect];
        
    }
    
    return self;
}

- (void)sessionConnect {
    
    //전제조건 : iphone, applewatch 상호간 세션 활성화가 되어있어야 함
    //와치앱이 시작되는 시점을 알수 없기 때문에 화면이 활성화되는 타이밍에서 세션을 체크해줘야함.
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)sendMessageSummaryModelStartMonth:(NSString *)startMonth endMonth:(NSString *)endMonth ascending:(BOOL)ascending replyHandler:(void (^)(NSDictionary *))handler {
    
    NSLog(@"isReachable:[%d]", [[WCSession defaultSession] isReachable]);
    
    if (![[WCSession defaultSession] isReachable]) {
        if (handler) {
            handler(nil);
        }
        return;
    }
    
    //make param
    NSDictionary *paramInfo = @{@"watchapp":@{@"command":@"fetch_summary",
                                              @"param":@{@"startMonth":startMonth,
                                                         @"endMonth":endMonth,
                                                         @"ascending":@(ascending)}}};
    
    
    [[WCSession defaultSession] sendMessage:paramInfo
                               replyHandler:^(NSDictionary *replyHandler) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if (replyHandler) {
                                           NSDictionary *results = replyHandler;
                                           
                                           if (handler) {
                                               handler(results);
                                           }
                                       }
                                   });
                               }
                               errorHandler:^(NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"error:%@",error);
                                   });
                               }
     ];
}

- (void)sendMessageTimeCardModel:(void(^)(NSDictionary *))handler {
    
    NSLog(@"isReachable:[%d]", [[WCSession defaultSession] isReachable]);
    
    if (![[WCSession defaultSession] isReachable]) {
        if (handler) {
            handler(nil);
        }
        return;
    }
    
    //make param
    NSDictionary *paramInfo = @{@"watchapp":@{@"command":@"fetch_today_timecard"}};
    
    [[WCSession defaultSession] sendMessage:paramInfo
                               replyHandler:^(NSDictionary *replyHandler) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if (replyHandler) {
                                           NSDictionary *results = replyHandler;
                                           
                                           if (handler) {
                                               //result(NSDictionary)
                                               handler(results);
                                           }
                                       }
                                   });
                               }
                               errorHandler:^(NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"error:%@",error);
                                   });
                               }
     ];
    
}

- (void)sendMessageGraphDate:(NSString *)dateString replyHandler:(void(^)(NSDictionary *))handler {
    
    NSLog(@"isReachable:[%d]", [[WCSession defaultSession] isReachable]);
    
    if (![[WCSession defaultSession] isReachable]) {
        if (handler) {
            handler(nil);
        }
        return;
    }
    
    //make param
    NSDictionary *paramInfo = @{@"watchapp":@{@"command":@"fetch_graph_date",
                                              @"param":@{@"date":dateString}}};
    
    [[WCSession defaultSession] sendMessage:paramInfo
                               replyHandler:^(NSDictionary *replyHandler) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if (replyHandler) {
                                           NSDictionary *results = replyHandler;
                                           
                                           if (handler) {
                                               handler(results);
                                           }
                                       }
                                   });
                               }
                               errorHandler:^(NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"error:%@",error);
                                   });
                               }
     ];
    
}

- (void)sendMessageYear:(NSString *)year month:(NSString *)month replyHandler:(void(^)(NSDictionary *))handler {
    
    NSLog(@"isReachable:[%d]", [[WCSession defaultSession] isReachable]);
    
    if (![[WCSession defaultSession] isReachable]) {
        if (handler) {
            handler(nil);
        }
        return;
    }

    //make param
    NSDictionary *paramInfo = @{@"watchapp":@{@"command":@"fetch_year_month",
                                              @"param":@{@"year":year,
                                                         @"month":month}}};
    
    [[WCSession defaultSession] sendMessage:paramInfo
                               replyHandler:^(NSDictionary *replyHandler) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if (replyHandler) {
                                           NSDictionary *results = replyHandler;
                                           
                                           if (handler) {
                                               handler(results);
                                           }
                                       }
                                   });
                               }
                               errorHandler:^(NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"error:%@",error);
                                   });
                               }
     ];
    
}

#pragma mark - WCSessionDelegate
- (void)sessionWatchStateDidChange:(WCSession *)session
{
    NSLog(@"%s: session = %@", __func__, session);
}

// Application Context
- (void)session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s: %@", __func__, applicationContext);
    });
}

// User Info Transfer
- (void)session:(nonnull WCSession *)session didReceiveUserInfo:(nonnull NSDictionary<NSString *,id> *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s: %@", __func__, userInfo);
    });
}

// File Transfer
- (void)session:(nonnull WCSession *)session didReceiveFile:(nonnull WCSessionFile *)file
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s: %@", __func__, file);
    });
}

// Interactive Message
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler
{
    //REMARK: test code.
    //本体からメッセージを送信した時にCallbackされるメソッド
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s: %@", __func__, message);
    });
    
//    replyHandler(@{@"reply" : @"OK"});
}

@end
