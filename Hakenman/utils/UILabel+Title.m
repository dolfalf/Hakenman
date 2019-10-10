//
//  UILabel+Title.m
//  Hakenman
//
//  Created by P1506 on 2019/10/08.
//  Copyright © 2019 kjcode. All rights reserved.
//

#import "UILabel+Title.h"

@implementation UILabel (Title)

+ (UILabel *)createNaviTitleLabel:(NSString *)str {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17.f];
    label.textColor = [UIColor whiteColor];
    return label;
}
@end
