//
//  EventManager.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventManager : NSObject

+ (EventManager *)sharedInstance;

- (NSArray *)fetchEvent;
- (NSArray *)fetchEventStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
- (void)eventEditController:(id)owner event:(EKEvent *)event;

@end

