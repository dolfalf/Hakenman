//
//  RightTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
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
}



//TimeCard Coredataの代わりにRightTableViewDataを参照するようにする
- (void)updateCell:(RightTableViewData *)model;
@end
