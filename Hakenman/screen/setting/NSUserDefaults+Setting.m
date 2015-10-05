//
//  NSUserDefaults+Setting.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/23.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "NSUserDefaults+Setting.h"
#import "const.h"

#define SHARED_GRUOP_ID    @"group.com.kjcode.dolfalf.hakemnan"

@implementation NSUserDefaults (Setting)

+ (BOOL)readWelcomePage {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"ReadWelcomePageKey" : @(NO)}];
    
    return [[userDefaults objectForKey:@"ReadWelcomePageKey"] boolValue];
}

+ (void)setReadWelcomePage:(BOOL)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(value) forKey:@"ReadWelcomePageKey"];
    
    [userDefaults synchronize];
}

+ (NSInteger)timeKubun {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"TimeKubunKey" : @(15)}];
    
    NSInteger conValue = 0;
    
    switch ([[userDefaults objectForKey:@"TimeKubunKey"] integerValue]) {
        case 0:
            conValue = 0;
            break;
        case 10:
            conValue = 1;
            break;
        case 15:
            conValue = 2;
            break;
        case 30:
            conValue = 3;
            break;
    }
    
    return conValue;
    
}

+ (void)setTimeKubun:(NSInteger)value {
    
    NSInteger conValue = 0;
    
    switch (value) {
        case 0:
            conValue = 0;
            break;
        case 1:
            conValue = 10;
            break;
        case 2:
            conValue = 15;
            break;
        case 3:
            conValue = 30;
            break;
    }
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(conValue) forKey:@"TimeKubunKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)workStartTime {
    
    NSDictionary *init_value = @{@"WorkStartTimeKey" : @"09:00"};
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:init_value];
    
    return [userDefaults objectForKey:@"WorkStartTimeKey"] ;
}

//AppleWatch対応
+ (NSString *)workStartTimeForWatch {
    
    NSDictionary *init_value = @{@"WorkStartTimeKey" : @"09:00"};
    
    NSUserDefaults *watch_ud = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GRUOP_ID];
    [watch_ud registerDefaults:init_value];
    
    return [watch_ud objectForKey:@"WorkStartTimeKey"] ;
}

+ (void)setWorkStartTime:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"WorkStartTimeKey"];
    
    //AppleWatch対応
    NSUserDefaults *watch_ud = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GRUOP_ID];
    [watch_ud setObject:value forKey:@"WorkStartTimeKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)workEndTime {
    
    NSDictionary *init_value = @{@"WorkEndTimeKey" : @"17:50"};
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:init_value];
    
    //AppleWatch対応
    NSUserDefaults *watch_ud = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GRUOP_ID];
    [watch_ud registerDefaults:init_value];
    
    return [userDefaults objectForKey:@"WorkEndTimeKey"];
    
}

+ (NSString *)workEndTimeForWatch {
    
    NSDictionary *init_value = @{@"WorkEndTimeKey" : @"17:50"};
    
    //AppleWatch対応
    NSUserDefaults *watch_ud = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GRUOP_ID];
    [watch_ud registerDefaults:init_value];
    
    return [watch_ud objectForKey:@"WorkEndTimeKey"];
}

+ (void)setWorkEndTime:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"WorkEndTimeKey"];
    
    //AppleWatch対応
    NSUserDefaults *watch_ud = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GRUOP_ID];
    [watch_ud setObject:value forKey:@"WorkEndTimeKey"];
    
    [userDefaults synchronize];
}

+ (NSInteger)displayWorkSheet {
    
    //0:All, 1:One Years ,2: 6 Months
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"displayWorkKey" : @(0)}];
    
    return [[userDefaults objectForKey:@"displayWorkKey"] intValue];
}

+ (void)setDisplayWorkSheet:(NSInteger)value {
    
    //0:All, 1:One Years ,2: 6 Months
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(value) forKey:@"displayWorkKey"];
    
    [userDefaults synchronize];
    
}

+ (NSInteger)displayModeWorkSheet {
    
    //0:sheet 1:calendar
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"displayModeWorksheetKey" : @(WorksheetDisplayModeSheet)}];
    
    return [[userDefaults objectForKey:@"displayModeWorksheetKey"] intValue];
}

+ (void)setDisplayModeWorkSheet:(NSInteger)value {
    
    //0:sheet 1:calendar
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(value) forKey:@"displayModeWorksheetKey"];
    
    [userDefaults synchronize];
    
}

+ (NSString *)workSitename {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"WorkSiteNameKey" : @""}];
    
    return [userDefaults objectForKey:@"WorkSiteNameKey"];
}

+ (void)setWorkSitename:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"WorkSiteNameKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)reportToMailaddress {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"ReportToMailAddressKey" : @""}];
    
    return [userDefaults objectForKey:@"ReportToMailAddressKey"] ;
}

+ (void)setReportToMailaddress:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"ReportToMailAddressKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)reportMailTitle {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    return [userDefaults objectForKey:@"ReportMailTitleKey"] ;
}

+ (void)setReportMailTitle:(NSString *)value {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"ReportMailTitleKey"];
    
    [userDefaults synchronize];
}

+ (BOOL)reportMailTempleteTimeAdd {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"ReportMailTempleteTimeAddKey" : @(YES)}];
    
    return [[userDefaults objectForKey:@"ReportMailTempleteTimeAddKey"] boolValue];
}

+ (void)setReportMailTempleteTimeAdd:(BOOL)value {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(value) forKey:@"ReportMailTempleteTimeAddKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)reportMailContent {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"ReportMailContentKey" : @""}];
    
    return [userDefaults objectForKey:@"ReportMailContentKey"] ;
}

+ (void)setReportMailContent:(NSString *)value {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"ReportMailContentKey"];
    
    [userDefaults synchronize];
}

+ (BOOL)isWatchMigration {
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"WatchMigrationKey" : @(NO)}];
    
    return [[userDefaults objectForKey:@"WatchMigrationKey"] boolValue];
}

+ (void)watchMigrationFinished {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"WatchMigrationKey"];
    
    [userDefaults synchronize];
}

@end
