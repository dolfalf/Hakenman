//
//  RightTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "RightTableViewCell.h"
#import "Util.h"
#import "RightTableViewData.h"

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

//表示めちゃくちゃ。。。早くかえないと。。。
- (void)updateCell:(RightTableViewData *)model {
    
    startTimeLabel.text = [NSString stringWithFormat:@"%@", model.start_time];
    endTimeLabel.text = [NSString stringWithFormat:@"%@", model.end_time];
//    NSNumber *durationWorkTime = [model.end_time integerValue] - [model.start_time integerValue];
//    workTimeLabel.text = [NSString stringWithFormat:@"%2.2f",[Util getWorkTime:model.start_time endTime:model.end_time]];
    workTimeLabel.text = @"0.0";
//    worktotalLabel.text = [NSString stringWithFormat:@"%2.2f",tt];
    worktotalLabel.text = @"8.0";
    
}

@end
