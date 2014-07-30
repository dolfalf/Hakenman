//
//  MonthWorkingTableEditViewController.h
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@class LeftTableViewData;

@interface MonthWorkingTableEditViewController : KJViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) LeftTableViewData *showData;

@end
