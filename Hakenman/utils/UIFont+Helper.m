//
//  UIFont+Helper.m
//  Hakenman
//
//  Created by kjcode on 2014/12/06.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "UIFont+Helper.h"
#import "Util.h"


@implementation UIFont (Helper)

+ (UIFont *)nanumFontOfSize:(CGFloat)fontSize {

//    if ([Util isJanpaneseLanguage] == NO) {
//        return [UIFont fontWithName:@"NanumBarunGothic" size:fontSize];
//    }else {
        return [UIFont systemFontOfSize:fontSize];
//    }
    
}

+ (UIFont *)boldNanumFontOfSize:(CGFloat)fontSize {

//    if ([Util isJanpaneseLanguage] == NO) {
//        return [UIFont fontWithName:@"NanumBarunGothicBold" size:fontSize];
//    }else {
        return [UIFont boldSystemFontOfSize:fontSize];
//    }

}

@end

@implementation UIFont (Wrapper)

+ (void)setNaviTitleFont:(UIFont *)font {
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:font}];
}
@end
