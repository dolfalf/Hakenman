//
//  WatchUtil.h
//  Hakenman
//
//  Created by lee jaeeun on 2015/10/02.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCALIZE(s)     NSLocalizedString(s, nil)

typedef enum {
    weekSunday = 1,
    weekMonday,
    weekTueDay,
    weekWedDay,
    weekThuDay,
    weekFriDay,
    weekSatDay
} weekday;

@interface WatchUtil : NSObject

+ (int)wathcOSVersion;
@end
