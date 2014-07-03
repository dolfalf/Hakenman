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
- (void)updateCell:(TimeCard *)model {
    
    if (model.start_time == nil || model.end_time == nil) {
        startTimeLabel.text = @"";
        endTimeLabel.text = @"";
        workTimeLabel.text = @"";
        worktotalLabel.text = @"";
    }else{
        startTimeLabel.text = model.start_time;
        endTimeLabel.text = model.end_time;
        workTimeLabel.text = @"未実装";
        worktotalLabel.text = @"未実装";
    }
}

@end
