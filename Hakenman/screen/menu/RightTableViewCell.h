//
//  RightTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeCard;

@interface RightTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    IBOutlet UILabel *workTimeLabel;
    IBOutlet UILabel *worktotalLabel;
}

- (void)updateCell:(TimeCard *)model;
@end
