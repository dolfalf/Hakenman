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
    
<<<<<<< HEAD
    if ([Util isJanpaneseLanguage] == NO) {
        return [UIFont fontWithName:@"NanumBarunGothic" size:fontSize];
    }else {
        return [UIFont systemFontOfSize:fontSize];
    }
=======
//    if ([Util isJanpaneseLanguage] == NO) {
//        return [UIFont fontWithName:@"NanumBarunGothic" size:fontSize];
//    }else {
        return [UIFont systemFontOfSize:fontSize];
//    }
>>>>>>> 1.x
    
}

+ (UIFont *)boldNanumFontOfSize:(CGFloat)fontSize {
<<<<<<< HEAD
    if ([Util isJanpaneseLanguage] == NO) {
        return [UIFont fontWithName:@"NanumBarunGothicBold" size:fontSize];
    }else {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
=======
//    if ([Util isJanpaneseLanguage] == NO) {
//        return [UIFont fontWithName:@"NanumBarunGothicBold" size:fontSize];
//    }else {
        return [UIFont boldSystemFontOfSize:fontSize];
//    }
>>>>>>> 1.x
}

@end
