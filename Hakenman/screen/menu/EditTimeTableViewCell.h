//
//  EditTimeTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTimeTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextField *timeTextField;
}

- (void)updateCell:(NSString *)title inputTime:(id)time;
- (void)setTimeText:(id)time;
@end
