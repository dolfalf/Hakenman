//
//  RightTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "RightTableViewCell.h"
#import "Util.h"
#import "TimeCard.h"

@implementation RightTableViewCell

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

- (void)updateCell:(TimeCard *)model {
    
//    startTimeLabel.text = [Util worktimeString:model.start_time];
//    endTimeLabel.text = [Util worktimeString:model.end_time];
//    workTimeLabel.text = [NSString stringWithFormat:@"%2.2f",[Util getWorkTime:model.start_time endTime:model.end_time]];
//    worktotalLabel.text = [NSString stringWithFormat:@"%2.2f",tt];
    
}

@end
