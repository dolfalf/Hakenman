//
//  UIFont+Helper.m
//  Hakenman
//
//  Created by kjcode on 2014/12/06.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "UIFont+Helper.h"

@implementation UIFont (Helper)

+ (UIFont *)nanumFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NanumBarunGothic" size:fontSize];
}

+ (UIFont *)boldNanumFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NanumBarunGothicBold" size:fontSize];
}

@end
