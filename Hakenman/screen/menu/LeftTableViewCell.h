//
//  LeftTableViewCell.h
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderLabel.h"

@interface LeftTableViewCell : UITableViewCell {
    
    //REMARK: Font対応してください。
    IBOutlet UIView *remarkFlagView;
    IBOutlet BorderLabel *dayLabel;
    IBOutlet BorderLabel *weekLabel;
    IBOutlet BorderLabel *workDayLabel;
}

- (void)updateCell:(NSNumber *)day week:(NSNumber *)week isWork:(NSNumber *)work isRemark:(BOOL)remark;

@end
