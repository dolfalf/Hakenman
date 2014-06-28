//
//  MonthTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeCardSummary;

@interface MonthTableViewCell : UITableViewCell

- (void)updateCell:(TimeCardSummary *)model;

@end
