//
//  NSDate+Helper.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

- (int)getYear;
- (int)getMonth;
- (int)getDay;
- (int)getWeekday;
- (int)getLastday;
- (int)getHour;
- (int)getMinuite;
- (NSDate *)getBeginOfMonth;
- (NSDate *)getEndOfMonth;
- (NSDate *)getDayOfMonth:(NSInteger)day;
- (NSDate *)getTimeOfMonth:(NSInteger)hour mimute:(NSInteger)min;

+ (NSDate *)convDate2ShortString:(NSString *)yyyyMMdd;
+ (NSDate *)convDate2String:(NSString *)yyyyMMddHHmmss;

- (NSString *)yyyyMMString;
- (NSString *)yyyyMMddString;
- (NSString *)yyyyMMddHHmmssString;
- (NSString *)convHHmmString;
@end
