//
//  TodayTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

- (void)updateCell:(double)worktime workday:(NSInteger)workday graphItems:(NSArray *)items;
@end
