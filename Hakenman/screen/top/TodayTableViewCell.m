//
//  TodayTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TodayTableViewCell.h"
#import "const.h"
#import "LineGraphView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSUserDefaults+Setting.h"
#import "NSDate+Helper.h"
#import "UIColor+Helper.h"
#import "Util.h"
#import "TimeCardDao.h"

@interface TodayTableViewCell() <LineGraphViewDelegate>

@property (nonatomic, strong) NSArray *graphItems;
@end

@implementation TodayTableViewCell {
    
    IBOutlet UIView *calContainerView;
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *weekLabel;
    IBOutlet LineGraphView *lineGraphView;
    
    IBOutlet UIView *labelGroupView;
    IBOutlet UILabel *messageTitleLabel;
    IBOutlet UILabel *countdownLabel;
    IBOutlet UILabel *countdownUnitLabel;
    
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
    calContainerView.layer.cornerRadius = 5;
    calContainerView.layer.masksToBounds = YES;
    [calContainerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [calContainerView.layer setBorderWidth:1.f];
    
    yearLabel.backgroundColor = [UIColor HKMOrangeColor];
    monthLabel.backgroundColor = [UIColor whiteColor];
    dayLabel.backgroundColor = [UIColor whiteColor];
    
    messageTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_message_title");
    countdownUnitLabel.text = LOCALIZE(@"TopViewController_tablecell_countdown_unit");
    
    HKM_INIT_LABLE(yearLabel, HKMFontTypeBoldNanum, yearLabel.font.pointSize);
    HKM_INIT_LABLE(monthLabel, HKMFontTypeBoldNanum, monthLabel.font.pointSize);
    HKM_INIT_LABLE(dayLabel, HKMFontTypeBoldNanum, dayLabel.font.pointSize);
    HKM_INIT_LABLE(weekLabel, HKMFontTypeNanum, weekLabel.font.pointSize);
    HKM_INIT_LABLE(messageTitleLabel, HKMFontTypeNanum, messageTitleLabel.font.pointSize);
    HKM_INIT_LABLE(countdownLabel, HKMFontTypeNanum, countdownLabel.font.pointSize);
    HKM_INIT_LABLE(countdownUnitLabel, HKMFontTypeNanum, countdownUnitLabel.font.pointSize);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - class method
- (void)updateCell:(cellMessageType)messageType graphItems:(NSArray *)items {
    
    
//    messageLabel.text = [[NSDate date] convHHmmString];
//    messageLabel.text = [self p_displayMessage:messageType displayDate:today];
    
    [lineGraphView setNeedsDisplay];
    
    [self updateWorkTime];
    
    self.graphItems = items;
    
}

- (void)updateWorkTime {
    
    NSDate *today = [NSDate date];
    
    yearLabel.text = [NSString stringWithFormat:@"%d",[today getYear]];
    monthLabel.text = [NSString stringWithFormat:@"%02d",[today getMonth]];
    dayLabel.text = [NSString stringWithFormat:@"%02d",[today getDay]];
    weekLabel.text = [Util weekdayString:[today getWeekday]];
    
    switch ([today getWeekday]) {
        case weekSatDay:
            weekLabel.textColor = [UIColor HKMBlueColor];
//            labelGroupView.hidden = YES;
            break;
        case weekSunday:
//            weekLabel.textColor = [UIColor redColor];
            labelGroupView.hidden = YES;
            break;
        default:
            weekLabel.textColor = [UIColor grayColor];
//            labelGroupView.hidden = NO;
            break;
    }
    
    [self p_displayMessage:cellMessageTypeWorkStart displayDate:today];
}

#pragma private methods
- (void)p_displayMessage:(cellMessageType)type displayDate:(NSDate *)dt {
    
    //今日の日付から
    NSDate *current_time = dt;
    NSString *message_format = @"%ld";
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
        }
            break;
            
        default:
            break;
    }
    
    DLog(@"calc_minute:%ld",(long)calc_minute);
    
    //表示対象外
    if (calc_minute < -120 || calc_minute > 0) {
        countdownLabel.textColor = [UIColor lightGrayColor];
        countdownLabel.text = @"- ";
        return;
    }
    
    //休日の場合
    if ([dt getWeekday] == weekSatDay || [dt getWeekday] == weekSunday) {
        countdownLabel.textColor = [UIColor lightGrayColor];
        countdownLabel.text = @"- ";
        return;
    }
    
    //すでに出勤したときの場合
    
    
    NSString *displayTime = [NSString stringWithFormat:message_format,calc_minute * -1];
    
    countdownLabel.textColor = [UIColor blackColor];
    
    //Animation
    if ([displayTime isEqualToString:countdownLabel.text] == NO) {
        countdownLabel.alpha = 0.f;
        [UIView animateWithDuration:0.3f animations:^{
            countdownLabel.alpha = 1.f;
        } completion:nil];
    }

    countdownLabel.text = displayTime;

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
    
    return (duration / (60*60)) - [card.rest_time floatValue];
}

@end
