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

@end
