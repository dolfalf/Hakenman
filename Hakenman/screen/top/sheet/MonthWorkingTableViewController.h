//
//  MonthWorkingTableViewController.h
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@interface MonthWorkingTableViewController : KJViewController

//外部から値をもらうためのプロパティ
@property (nonatomic, strong) NSString *inputDates;
@property (nonatomic, strong) NSString *fromCurruntInputDates;
@property (nonatomic, assign) BOOL fromCurruntTimeInput;

@end
