//
//  NSUserDefaults+Setting.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/23.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "NSUserDefaults+Setting.h"

@implementation NSUserDefaults (Setting)

+ (NSInteger)timeKubun {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"TimeKubunKey" : @(30)}];
    
    return [[userDefaults objectForKey:@"TimeKubunKey"] integerValue];
    
}

+ (void)setTimeKubun:(NSInteger)value {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults setObject:@(value) forKey:@"TimeKubunKey"];
    
    [userDefaults synchronize];
}

+ (NSString *)workStartTime {
    
    NSUserDefaults *userDefaults = [self standardUserDefaults];
    [userDefaults registerDefaults:@{@"WorkStartTimeKey" : @"09:00"}];
    
    return [userDefaults objectForKey:@"WorkStartTimeKey"];
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

@end
