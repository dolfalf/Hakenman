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

@interface RightTableViewCell()

@end

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
        
        if (model.start_time == nil) {
            startTimeLabel.text = @"";
            endTimeLabel.text = [Util weekStatusTimeString:endTimeFromCore];
            workTimeLabel.text = @"";
            worktotalLabel.text = @"";
        }else if (model.end_time == nil) {
            startTimeLabel.text = [Util weekStatusTimeString:startTimeFromCore];
            endTimeLabel.text = @"";
            workTimeLabel.text = @"";
            worktotalLabel.text = @"";
        }else{
            float workTimeFromCore = [Util getWorkTime:startTimeFromCore endTime:endTimeFromCore] - [model.rest_time floatValue];
            startTimeLabel.text = [Util weekStatusTimeString:startTimeFromCore];
            endTimeLabel.text = [Util weekStatusTimeString:endTimeFromCore];
            
            if ([model.workday_flag boolValue] == NO) {
                worktotalLabel.text = @"-";
            }else {
                worktotalLabel.text = [NSString stringWithFormat:@"%2.2f", model.total_time];
            }
            
            //合計１２時間以上は赤字で表示する
            if (workTimeFromCore >= 12.00f) {
                workTimeLabel.textColor = [UIColor redColor];
            }else {
                workTimeLabel.textColor = [UIColor blackColor];
            }
            
            workTimeLabel.text = [NSString stringWithFormat:@"%2.2f",workTimeFromCore];
        }
    }
}

@end
