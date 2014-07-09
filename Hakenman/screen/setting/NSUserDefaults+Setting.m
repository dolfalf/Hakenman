//
//  NSUserDefaults+Setting.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/23.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "NSUserDefaults+Setting.h"
#import "const.h"

@implementation NSUserDefaults (Setting)

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
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"WorkStartTimeKey" : @"09:00"}];
    
    return [userDefaults objectForKey:@"WorkStartTimeKey"] ;
}

+ (void)setWorkStartTime:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"WorkStartTimeKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)workEndTime {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"WorkEndTimeKey" : @"17:50"}];
    
    return [userDefaults objectForKey:@"WorkEndTimeKey"];
}

+ (void)setWorkEndTime:(NSString *)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:value forKey:@"WorkEndTimeKey"];
    
    [userDefaults synchronize];
}

+ (NSInteger)displayWorkSheet {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"displayWorkKey" : @"All"}];
    
    NSString *strValue = [userDefaults objectForKey:@"displayWorkKey"];
    NSInteger conValue = 0;
    if ([strValue isEqualToString:@"All"] == YES) {
        conValue = 0;
    }else if ([strValue isEqualToString:@"One Years"] == YES) {
        conValue = 1;
    }else if ([strValue isEqualToString:@"6 Months"] == YES) {
        conValue = 2;
    }
    
    return conValue;
}

+ (void)displayWorkSheet:(NSInteger)value {
    
    NSString *strValue = @"";
    
    switch (value) {
        case 0:
            //all
            strValue = @"All";
            break;
        case 1:
            //One years
            strValue = @"One Years";
            break;
        case 2:
            //6 months
            strValue = @"6 Months";
            break;
    }
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:strValue forKey:@"displayWorkKey"];
    
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
    [userDefaults registerDefaults:@{@"ReportMailTitleKey" : LOCALIZE(@"SettingViewController_work_report_title_defalut")}];
    
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

@end
