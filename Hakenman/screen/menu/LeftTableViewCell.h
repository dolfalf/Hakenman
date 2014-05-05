//
//  LeftTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *weekLabel;
    IBOutlet UILabel *workDayLabel;
}

- (void)updateCell:(NSNumber *)day week:(NSNumber *)week isWork:(NSNumber *)work;

@end
