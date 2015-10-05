//
//  WatchUtil.m
//  Hakenman
//
//  Created by lee jaeeun on 2015/10/02.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "WatchUtil.h"
#import <WatchKit/WatchKit.h>
#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"
#import "NSDate+Helper.h"

@implementation WatchUtil

+ (int)wathcOSVersion {
    return [[UIDevice currentDevice].systemVersion floatValue] * 1000;
}

+ (float)totalWorkTime {
    
    float display_total_time = 0.f;
    
    TimeCardDao *dao = [TimeCardDao new];
    NSDate *dt = [NSDate date];
    NSArray *items = [dao fetchModelYear:[dt getYear] month:[dt getMonth]];
    for (TimeCard *tm in items) {
        
        NSDate *startTimeFromCore = [NSDate convDate2String:tm.start_time];
        NSDate *endTimeFromCore = [NSDate convDate2String:tm.end_time];
        float workTimeFromCore = [TimeCardSummaryDao getWorkTime:startTimeFromCore endTime:endTimeFromCore] - [tm.rest_time floatValue];
        
        if (tm.start_time == nil || [tm.start_time isEqualToString:@""] == YES
            || tm.end_time == nil || [tm.end_time isEqualToString:@""] == YES) {
            continue;
        }
        
        if ([tm.workday_flag boolValue] == NO) {
            workTimeFromCore = 0.f;
        }
        
        display_total_time = display_total_time + workTimeFromCore;
    }
    
    return display_total_time;
    
}

+ (NSString *)weekdayString:(int)weekday {
    //1 = Sunday, 2 = Monday, etc.
    
    NSString *weekString = nil;
    
    switch (weekday) {
        case weekSunday:
            weekString = LOCALIZE(@"Common_weekday_sunday");
            break;
        case weekMonday:
            weekString = LOCALIZE(@"Common_weekday_monday");
            break;
        case weekTueDay:
            weekString = LOCALIZE(@"Common_weekday_tueday");
            break;
        case weekWedDay:
            weekString = LOCALIZE(@"Common_weekday_wedday");
            break;
        case weekThuDay:
            weekString = LOCALIZE(@"Common_weekday_thuday");
            break;
        case weekFriDay:
            weekString = LOCALIZE(@"Common_weekday_friday");
            break;
        case weekSatDay:
            weekString = LOCALIZE(@"Common_weekday_satday");
            break;
        default:
            break;
    }
    
    return weekString;
}

@end
