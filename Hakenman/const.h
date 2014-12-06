//
//  const.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/23.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#ifndef Hakenman_const_h
#define Hakenman_const_h

#import "UIFont+Helper.h"
#import "UIColor+Helper.h"

//Localize
#define LOCALIZE(s)     NSLocalizedString(s, nil)

//座標指定
#define CGRectSetPosition(r, p)             CGRectMake(p.x, p.y, r.size.width, r.size.height)
#define CGRectSetXY(r, x, y)                CGRectMake(x, y, r.size.width, r.size.height)
#define CGRectSetX(r, x)                    CGRectMake(x, r.origin.y, r.size.width, r.size.height)
#define CGRectSetY(r, y)                    CGRectMake(r.origin.x, y, r.size.width, r.size.height)
#define CGRectSetSize(r, s)                 CGRectMake(r.origin.x, r.origin.y, s.width, s.height)
#define CGRectSetWidthAndHeight(r, w, h)    CGRectMake(r.origin.x, r.origin.y, w, h)
#define CGRectSetWidth(r, w)                CGRectMake(r.origin.x, r.origin.y, w, r.size.height)
#define CGRectSetHeight(r, h)               CGRectMake(r.origin.x, r.origin.y, r.size.width, h)

typedef enum {
    weekSunday = 1,
    weekMonday,
    weekTueDay,
    weekWedDay,
    weekThuDay,
    weekFriDay,
    weekSatDay
} weekday;

typedef NS_ENUM(NSInteger, WorksheetDisplayMode) {
    
    WorksheetDisplayModeSheet = 0,
    WorksheetDisplayModeCalendar,
};

#endif
