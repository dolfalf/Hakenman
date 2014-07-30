//
//  SwitchButtonTableViewCell.h
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchButtonTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UISwitch *workDaySwitch;
}

- (void)updateCell:(NSString *)title isWorkday:(NSNumber *)on switchHandler:(void (^)(BOOL))handler;

@end
