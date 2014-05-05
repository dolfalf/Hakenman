//
//  EditTimeTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "EditTimeTableViewCell.h"
#import "Util.h"

@implementation EditTimeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSString *)title inputTime:(id)time {
    
    titleLabel.text = title;
    [self setTimeText:time];
}

- (void)setTimeText:(id)time {
    
    if ([time isKindOfClass:[NSDate class]] == YES) {
        //
        timeTextField.text = [Util worktimeString:(NSDate *)time];
    }else if([time isKindOfClass:[NSNumber class]] == YES) {
        //
        timeTextField.text = [NSString stringWithFormat:@"%2.2f", [(NSNumber *)time floatValue]];
    }
}

@end
