//
//  HKMConnectivityManager.h
//  Hakenman
//
//  Created by lee jaeeun on 2016/08/17.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKMConnectivityManager : NSObject

+ (id)sharedInstance;
- (void)sessionConnect;

- (void)sendMessageSummaryModelStartMonth:(NSString *)startMonth endMonth:(NSString *)endMonth ascending:(BOOL)assending replyHandler:(void(^)(NSDictionary *))handler;

- (void)sendMessageTimeCardModel:(void(^)(NSDictionary *))handler;
- (void)sendMessageGraphDate:(NSString *)dateString replyHandler:(void(^)(NSDictionary *))handler;
- (void)sendMessageYear:(NSString *)year month:(NSString *)month replyHandler:(void(^)(NSDictionary *))handler;
- (void)sendMessageWorkDayYear:(NSString *)year month:(NSString *)month replyHandler:(void(^)(NSDictionary *))handler;
@end
