//
//  LeftTableViewCell.m
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "LeftTableViewCell.h"
#import "Util.h"
#import "const.h"
#import "UIColor+Helper.h"

@implementation LeftTableViewCell

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
    remarkFlagView.layer.cornerRadius = 5;
    remarkFlagView.layer.masksToBounds = YES;
    [remarkFlagView.layer setBorderColor:[UIColor HKMOrangeColor].CGColor];
    remarkFlagView.backgroundColor = [UIColor HKMOrangeColor];
    [remarkFlagView.layer setBorderWidth:1.f];
    dayLabel.textColor = [UIColor colorNamed:@"normalDayLabelColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSNumber *)day week:(NSNumber *)week isWork:(NSNumber *)work isRemark:(BOOL)remark {
    
    dayLabel.font = [UIFont nanumFontOfSize:dayLabel.font.pointSize];
    weekLabel.font = [UIFont nanumFontOfSize:weekLabel.font.pointSize];
    workDayLabel.font = [UIFont nanumFontOfSize:workDayLabel.font.pointSize];
    
    //remark存在表示
    remarkFlagView.hidden = !remark;

    dayLabel.text = [NSString stringWithFormat:@"%d", [day intValue]];
    weekLabel.text = [Util weekdayString:[week intValue]];
    if ([week intValue] == weekSatDay) {
        weekLabel.textColor = [UIColor colorNamed:@"saturdayLabelColor"];
    }else if ([week intValue] == weekSunday){
        weekLabel.textColor = [UIColor colorNamed:@"sundayLabelColor"];
    }else{
        weekLabel.textColor = [UIColor colorNamed:@"normalDayLabelColor"];
    }
    workDayLabel.text = [work boolValue]?@"○":@"×";
}

@end
