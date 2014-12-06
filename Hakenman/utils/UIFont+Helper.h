//
//  UIFont+Helper.h
//  Hakenman
//
//  Created by kjcode on 2014/12/06.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HKMFontType) {
    HKMFontTypeNanum,
    HKMFontTypeBoldNanum,
};

#define HKM_INIT_LABLE(l,ft,sz)     if(ft == HKMFontTypeNanum){l.font=[UIFont nanumFontOfSize:sz];}\
                                    else if(ft == HKMFontTypeBoldNanum){l.font=[UIFont boldNanumFontOfSize:sz];}

#define HKM_INIT_NAVI_TITLE(font) [[UINavigationBar appearance] setTitleTextAttributes:\
                                    [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];

#define HKM_INIT_NAVI_BACK_BUTTON(font) [[UIBarButtonItem appearance] setTitleTextAttributes:\
                                    [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil] forState:UIControlStateNormal];


@interface UIFont (Helper)

+ (UIFont *)nanumFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldNanumFontOfSize:(CGFloat)fontSize;

@end
