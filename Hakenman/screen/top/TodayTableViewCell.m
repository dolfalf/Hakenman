//
//  TodayTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TodayTableViewCell.h"
#import "LineGraphView.h"
#import "NSUserDefaults+Setting.h"
#import "NSDate+Helper.h"
#import "UIColor+Helper.h"
#import "TimeCard.h"

@interface TodayTableViewCell() <LineGraphViewDelegate>

@property (nonatomic, strong) NSArray *graphItems;
@end

@implementation TodayTableViewCell {
    
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet LineGraphView *lineGraphView;
}

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

#pragma mark - class method
- (void)updateCell:(cellMessageType)messageType graphItems:(NSArray *)items {
    
    NSDate *today = [NSDate date];
    yearLabel.text = [NSString stringWithFormat:@"%d",[today getYear]];
    monthLabel.text = [NSString stringWithFormat:@"%d",[today getMonth]];
    dayLabel.text = [NSString stringWithFormat:@"%d",[today getDay]];
    messageLabel.text = [[NSDate date] convHHmmString];
//    messageLabel.text = [self p_displayMessage:messageType displayDate:today];
    
    self.graphItems = items;
    
}

- (void)updateWorkTime {
    //基準時間より残った時間を計算する
    
    //計算する時間から色の値を求める
    
    messageLabel.textColor = [UIColor colorWithRed:0.502 green:0.0 blue:0.502 alpha:1.f];
    //messageLabel.textColor = [UIColor colorWithHexString:@"" alpha:1.f];
    messageLabel.text = [[NSDate date] convHHmmString];
}

#pragma private methods
- (NSString *)p_displayMessage:(cellMessageType)type displayDate:(NSDate *)dt {
    
    //今日の日付から
    NSDate *current_time = dt;
    NSString *message_format = @"";
    NSInteger calc_minute = 0;
    
    switch (type) {
        case cellMessageTypeWorkStart:
        {
            //出勤時間までの時間を計算
            NSArray *timeArray = [[NSUserDefaults workStartTime] componentsSeparatedByString:@":"];
            NSDate *workStartTime = [current_time getTimeOfMonth:[timeArray[0] intValue]
                                                                 mimute:[timeArray[1] intValue]];
            
            NSTimeInterval t = [current_time timeIntervalSinceDate:workStartTime];
            
            calc_minute = (int)(t / 60);
            message_format = @"出勤時間まで%d分です。";
            DLog(@"%d",calc_minute);
        }
            break;
        case cellMessageTypeWorkEnd:
        {
            //退勤時間までの時間を計算
            NSArray *timeArray = [[NSUserDefaults workEndTime] componentsSeparatedByString:@":"];
            NSDate *workEndTime = [current_time getTimeOfMonth:[timeArray[0] intValue]
                                                  mimute:[timeArray[1] intValue]];
            
            NSTimeInterval t = [workEndTime timeIntervalSinceDate:current_time];
            
            calc_minute = (int)(t / (60 * 60));
            message_format = @"退勤時間まで%d分です。";

            DLog(@"%d",calc_minute);
        }
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:message_format,calc_minute];
    
}


#pragma mark - LineGraphViewDelegate
- (NSInteger)linePointNumber {
    
    return [_graphItems count];
}

- (float)lineGraphView:(LineGraphView *)gview PointIndex:(NSInteger)index {
    
    TimeCard *card = [_graphItems objectAtIndex:index];
    
    NSTimeInterval t = [[NSDate convDate2String:card.end_time]
                        timeIntervalSinceDate:[NSDate convDate2String:card.start_time]];
    
    float duration = (float)t - [card.rest_time floatValue];
    DLog(@"%f", duration);
    
    return duration / (60*60);
}

@end
