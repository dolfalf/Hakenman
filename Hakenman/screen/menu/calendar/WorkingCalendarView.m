//
//  WorkingCalendarView.m
//  Hakenman
//
//  Created by kjcode on 2014/11/08.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "WorkingCalendarView.h"

@interface WorkingCalendarView()

@end

@implementation WorkingCalendarView

@synthesize month = _month;


- (void)showMonth:(NSDateComponents *)comp {
    
    _month = comp;
    [self showCurrentMonth];
}

@end
