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

+ (float)totalWorkTime:(NSString *)yyyymm {
    
    float display_total_time = 0.f;
    
    if (yyyymm == nil || yyyymm.length != 6) {
        return display_total_time;
    }
    
    TimeCardDao *dao = [TimeCardDao new];
    NSArray *items = [dao fetchModelYear:[[yyyymm substringWithRange:NSMakeRange(0, 4)] intValue]
                                   month:[[yyyymm substringWithRange:NSMakeRange(4, 2)] intValue]];
    
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

+ (NSString *)monthString:(int)month {
    
    NSString *str = nil;
    
    switch (month) {
        case 1:
            str = LOCALIZE(@"Common_month_1");
            break;
        case 2:
            str = LOCALIZE(@"Common_month_2");
            break;
        case 3:
            str = LOCALIZE(@"Common_month_3");
            break;
        case 4:
            str = LOCALIZE(@"Common_month_4");
            break;
        case 5:
            str = LOCALIZE(@"Common_month_5");
            break;
        case 6:
            str = LOCALIZE(@"Common_month_6");
            break;
        case 7:
            str = LOCALIZE(@"Common_month_7");
            break;
        case 8:
            str = LOCALIZE(@"Common_month_8");
            break;
        case 9:
            str = LOCALIZE(@"Common_month_9");
            break;
        case 10:
            str = LOCALIZE(@"Common_month_10");
            break;
        case 11:
            str = LOCALIZE(@"Common_month_11");
            break;
        case 12:
            str = LOCALIZE(@"Common_month_12");
            break;
    }
    
    return str;
}

+ (NSString *)timeString:(NSString *)str {
    
    //yyyymmddHHmmss
    
    if (str == nil || str.length != 14) {
        return @"--:--";
    }
    
    NSString *hour = [str substringWithRange:NSMakeRange(8, 2)];
    NSString *min = [str substringWithRange:NSMakeRange(10, 2)];
    
    return [NSString stringWithFormat:@"%@:%@", hour, min];
}

@end
