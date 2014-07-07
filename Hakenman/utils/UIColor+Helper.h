//
//  UIColor+Helper.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/28.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface UIColor (Helper)

+ (id)colorWithHexString:(NSString *)hex alpha:(CGFloat)a;

#pragma mark - Hakenman Theme color
+ (UIColor *)HKMBlueColor;
+ (UIColor *)HKMSkyblueColor;
+ (UIColor *)HKMSkyblueColor:(float)alpha;
+ (UIColor *)HKMDarkblueColor;
+ (UIColor *)HKMDarkOrangeColor;
+ (UIColor *)HKMOrangeColor;
@end
