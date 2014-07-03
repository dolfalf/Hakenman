//
//  MonthWorkingTableViewController.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@class TimeCard;
@interface MonthWorkingTableViewController : KJViewController
//ただのモデル？（だそう）
@property (nonatomic, strong) NSArray *items;
//テーブルビューに表示させるためデーター
@property (nonatomic, weak) NSArray *leftDayItems;
//外部から値をもらうためのプロパティ
@property (nonatomic, strong) NSString *inputDates;

@property (nonatomic, strong) TimeCard *model;



@end
