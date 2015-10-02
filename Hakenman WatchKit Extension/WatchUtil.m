//
//  WatchUtil.m
//  Hakenman
//
//  Created by lee jaeeun on 2015/10/02.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "WatchUtil.h"
#import <WatchKit/WatchKit.h>

@implementation WatchUtil

+ (int)wathcOSVersion {
    return [[UIDevice currentDevice].systemVersion floatValue] * 1000;
}

@end
