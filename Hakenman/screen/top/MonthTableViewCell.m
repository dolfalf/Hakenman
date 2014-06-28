//
//  MonthTableViewCell.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthTableViewCell.h"
#import "TimeCardSummary.h"

@interface MonthTableViewCell() {
    
    IBOutlet UILabel *yearLabel;
    IBOutlet UILabel *monthLabel;
    IBOutlet UILabel *workdayLabel;
    IBOutlet UILabel *workTimeLabel;
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
