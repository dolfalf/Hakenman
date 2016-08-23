//
//  WatchUtil.h
//  Hakenman
//
//  Created by lee jaeeun on 2015/10/02.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "const.h"

@interface WatchUtil : NSObject

+ (int)wathcOSVersion;
+ (NSString *)weekdayString:(int)weekday;
+ (NSString *)monthString:(int)month;
+ (NSString *)timeString:(NSString *)str;
+ (float)getWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime;
@end
