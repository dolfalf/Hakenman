//
//  DailyWorkTableRowController.h
//  Hakenman
//
//  Created by lee jaeeun on 2015/09/29.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@import WatchKit;

@interface DailyWorkTableRowController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *dateLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *weekLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *startTimeLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *memoLabel;
@end
