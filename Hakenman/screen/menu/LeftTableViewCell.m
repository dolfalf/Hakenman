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
    // Initialization code
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    remarkFlagView.layer.cornerRadius = 5;
    remarkFlagView.layer.masksToBounds = YES;
    [remarkFlagView.layer setBorderColor:[UIColor HKMSkyblueColor].CGColor];
    remarkFlagView.backgroundColor = [UIColor HKMSkyblueColor];
    [remarkFlagView.layer setBorderWidth:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSNumber *)day week:(NSNumber *)week isWork:(NSNumber *)work isRemark:(BOOL)remark {
    
    //remark存在表示
    remarkFlagView.hidden = !remark;

    dayLabel.text = [NSString stringWithFormat:@"%d", [day intValue]];
    weekLabel.text = [Util weekdayString:[week intValue]];
    if ([week intValue] == weekSatDay) {
        weekLabel.textColor = [UIColor blueColor];
    }else if ([week intValue] == weekSunday){
        weekLabel.textColor = [UIColor redColor];
    }else{
        weekLabel.textColor = [UIColor blackColor];
    }
    workDayLabel.text = [work boolValue]?@"○":@"×";
}

@end
