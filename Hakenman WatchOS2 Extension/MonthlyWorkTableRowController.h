//
//  MonthlyWorkTableRowController.h
//  Hakenman
//
//  Created by lee jaeeun on 2015/09/29.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@import WatchKit;

@interface MonthlyWorkTableRowController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *yearLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *monthLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workTimeTitleLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workTimeLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workDayTitleLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workDayLabel;

@end
