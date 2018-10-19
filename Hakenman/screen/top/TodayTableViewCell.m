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
    
    IBOutlet UILabel *monthWorkTitleLabel;
    IBOutlet UILabel *monthWorkTimeLabel;
    IBOutlet UILabel *monthWorkTimeUnitLabel;
    IBOutlet UILabel *monthWorkTimeMinuteLabel;
    IBOutlet UILabel *monthWorkDayLabel;
    IBOutlet UILabel *monthWorkDayUnitLabel;
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
    [super awakeFromNib];
    // Initialization code
    calContainerView.layer.cornerRadius = 5;
    calContainerView.layer.masksToBounds = YES;
    [calContainerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [calContainerView.layer setBorderWidth:1.f];
    
    yearLabel.backgroundColor = [UIColor HKMOrangeColor];
    monthLabel.backgroundColor = [UIColor whiteColor];
    dayLabel.backgroundColor = [UIColor whiteColor];
    
    monthWorkTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_work_tile");
    monthWorkDayUnitLabel.text = LOCALIZE(@"TopViewController_tablecell_workday_unit");
    monthWorkTimeUnitLabel.text  = LOCALIZE(@"TopViewController_tablecell_worktime_unit");
    
    HKM_INIT_LABLE(yearLabel, HKMFontTypeBoldNanum, yearLabel.font.pointSize);
    HKM_INIT_LABLE(monthLabel, HKMFontTypeBoldNanum, monthLabel.font.pointSize);
    HKM_INIT_LABLE(dayLabel, HKMFontTypeBoldNanum, dayLabel.font.pointSize);
    HKM_INIT_LABLE(weekLabel, HKMFontTypeNanum, weekLabel.font.pointSize);
    HKM_INIT_LABLE(monthWorkTitleLabel, HKMFontTypeNanum, monthWorkTitleLabel.font.pointSize);
    HKM_INIT_LABLE(monthWorkTimeLabel, HKMFontTypeNanum, monthWorkTimeLabel.font.pointSize);
    HKM_INIT_LABLE(monthWorkDayLabel, HKMFontTypeNanum, monthWorkDayLabel.font.pointSize);
    HKM_INIT_LABLE(monthWorkTimeUnitLabel, HKMFontTypeNanum, monthWorkTimeUnitLabel.font.pointSize);
    HKM_INIT_LABLE(monthWorkDayUnitLabel, HKMFontTypeNanum, monthWorkDayUnitLabel.font.pointSize);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - class method
- (void)updateCell:(double)worktime workday:(NSInteger)workday graphItems:(NSArray *)items {
    
    [lineGraphView setNeedsDisplay];
    
    NSDate *today = [NSDate date];
    
    yearLabel.text = [NSString stringWithFormat:@"%d",[today getYear]];
    monthLabel.text = [NSString stringWithFormat:@"%02d",[today getMonth]];
    dayLabel.text = [NSString stringWithFormat:@"%02d",[today getDay]];
    weekLabel.text = [Util weekdayString:[today getWeekday]];

    switch ([today getWeekday]) {
        case weekSatDay:
            weekLabel.textColor = [UIColor HKMBlueColor];
            break;
        case weekSunday:
            weekLabel.textColor = [UIColor redColor];
            break;
        default:
            weekLabel.textColor = [UIColor grayColor];
            break;
    }
    
    monthWorkTimeLabel.text = [NSString stringWithFormat:@"%.1f", worktime];
    monthWorkDayLabel.text = [NSString stringWithFormat:@"%ld", (long)workday];

    monthWorkTimeMinuteLabel.text = [NSString stringWithFormat:@"%ld minute.", (long)(worktime*60.f)];
    
    self.graphItems = items;
    
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
