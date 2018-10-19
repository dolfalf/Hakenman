//
//  RightTableViewCell.h
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderLabel.h"

@class RightTableViewData;
@class TimeCard;

@interface RightTableViewCell : UITableViewCell {
    
    IBOutlet BorderLabel *startTimeLabel;
    IBOutlet BorderLabel *endTimeLabel;
    IBOutlet BorderLabel *workTimeLabel;
    IBOutlet BorderLabel *worktotalLabel;
    IBOutlet BorderLabel *workTimeMinuteLabel;
    IBOutlet BorderLabel *worktotalMinuteLabel;
}



//TimeCard Coredataの代わりにRightTableViewDataを参照するようにする
- (void)updateCell:(RightTableViewData *)model;
@end
