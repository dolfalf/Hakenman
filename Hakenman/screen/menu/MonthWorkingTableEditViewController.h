//
//  MonthWorkingTableEditViewController.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"
@class TimeCard;

@interface MonthWorkingTableEditViewController : KJViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) TimeCard *timeCard;

@end
