//
//  MonthWorkingTableEditViewController.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@class TimeCard;
@class LeftTableViewData;

@interface MonthWorkingTableEditViewController : KJViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>

//TimeCardの代わりにRightTableViewDataの何かで埋める予定
@property (nonatomic, strong) TimeCard *timeCard;
@property (nonatomic, strong) LeftTableViewData *showData;

@end
