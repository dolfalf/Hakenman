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

- (void)sendMessageSummaryModelStartMonth:(NSString *)startMonth endMonth:(NSString *)endMonth ascending:(BOOL)assending replyHandler:(void(^)(NSDictionary *))handler;

- (void)sendMessageTimeCardModel:(void(^)(NSDictionary *))handler;

@end
