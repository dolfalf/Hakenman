//
//  MonthTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "const.h"
#import "TimeCardSummary.h"

@interface MonthTableViewCell() {
    
    IBOutlet UIView *calContainerView;
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;

    IBOutlet UILabel *workTimeLabel;
    IBOutlet UILabel *workTimeTitleLabel;
    IBOutlet UILabel *workTimeUnit;
    IBOutlet UILabel *workTimeMinuteLabel;
    
    IBOutlet UILabel *workdayLabel;
    IBOutlet UILabel *workdayTitleLabel;
    IBOutlet UILabel *workdayUnit;
}

@end

@implementation MonthTableViewCell

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
    
    workTimeTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_total_work_time_title");
    workdayTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_total_work_day_title");
    

    HKM_INIT_LABLE(yearLabel, HKMFontTypeBoldNanum, yearLabel.font.pointSize);
    HKM_INIT_LABLE(monthLabel, HKMFontTypeBoldNanum, monthLabel.font.pointSize);
    HKM_INIT_LABLE(workTimeLabel, HKMFontTypeNanum, workTimeLabel.font.pointSize);
    HKM_INIT_LABLE(workTimeTitleLabel, HKMFontTypeNanum, workTimeTitleLabel.font.pointSize);
    HKM_INIT_LABLE(workTimeUnit, HKMFontTypeNanum, workTimeUnit.font.pointSize);
    HKM_INIT_LABLE(workdayLabel, HKMFontTypeNanum, workdayLabel.font.pointSize);
    HKM_INIT_LABLE(workdayTitleLabel, HKMFontTypeNanum, workdayTitleLabel.font.pointSize);
    HKM_INIT_LABLE(workdayUnit, HKMFontTypeNanum, workdayUnit.font.pointSize);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - update cell
- (void)updateCell:(TimeCardSummary *)model {
    
    NSString *yearString = [[model.t_yyyymm stringValue] substringWithRange:NSMakeRange(0, 4)];
    NSString *monthString = [[model.t_yyyymm stringValue] substringWithRange:NSMakeRange(4, 2)];
    
    yearLabel.text = yearString;
    monthLabel.text = monthString;
    workdayLabel.text = [NSString stringWithFormat:@"%d", [model.workdays intValue]];
    workTimeLabel.text = [NSString stringWithFormat:@"%d", [model.workTime intValue]];
    
    workTimeMinuteLabel.text = [NSString stringWithFormat:@"%ld minute.", (long)([model.workTime floatValue] * 60.f)];
}

@end
