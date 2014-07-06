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
#import "UIColor+Helper.h"

@interface MonthTableViewCell() {
    
    IBOutlet UIView *calContainerView;
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;

    IBOutlet UILabel *workTimeLabel;
    IBOutlet UILabel *workTimeTitleLabel;
    IBOutlet UILabel *workTimeUnit;
    
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
    // Initialization code
    calContainerView.layer.cornerRadius = 5;
    calContainerView.layer.masksToBounds = YES;
    [calContainerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [calContainerView.layer setBorderWidth:1.f];
    
    yearLabel.backgroundColor = [UIColor HKMOrangeColor];
    monthLabel.backgroundColor = [UIColor whiteColor];
    
    workTimeTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_total_work_time_title");
    workdayTitleLabel.text = LOCALIZE(@"TopViewController_tablecell_total_work_day_title");
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
    
}

@end
