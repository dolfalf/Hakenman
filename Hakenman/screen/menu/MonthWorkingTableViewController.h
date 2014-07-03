//
//  MonthWorkingTableViewController.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@interface MonthWorkingTableViewController : KJViewController
//ただのモデル？（だそう）
@property (nonatomic, strong) NSArray *items;
//外部から値をもらうためのプロパティ
@property (nonatomic, strong) NSString *inputDates;



@end
