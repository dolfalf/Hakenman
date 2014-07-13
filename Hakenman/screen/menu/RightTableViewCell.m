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
#import "TimeCard.h"
#import "NSDate+Helper.h"

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

- (void)updateCell:(RightTableViewData *)model {
    if (model.start_time == nil && model.end_time == nil) {
        startTimeLabel.text = @"";
        endTimeLabel.text = @"";
        workTimeLabel.text = @"";
        worktotalLabel.text = @"";
    }else{
        NSDate *startTimeFromCore = [NSDate convDate2String:model.start_time];
        NSDate *endTimeFromCore = [NSDate convDate2String:model.end_time];
        float workTimeFromCore = [Util getWorkTime:startTimeFromCore endTime:endTimeFromCore];
        startTimeLabel.text = [Util weekStatusTimeString:startTimeFromCore];
        endTimeLabel.text = [Util weekStatusTimeString:endTimeFromCore];
        workTimeLabel.text = [NSString stringWithFormat:@"%2.2f",workTimeFromCore];
        worktotalLabel.text = @"未実装";
    }
}

@end
