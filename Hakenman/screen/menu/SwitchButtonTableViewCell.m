//
//  SwitchButtonTableViewCell.m
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "SwitchButtonTableViewCell.h"

@interface SwitchButtonTableViewCell()

@property (nonatomic, copy) void (^switchHandler)(BOOL) ;
@end

@implementation SwitchButtonTableViewCell

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

- (IBAction)switchChanged:(UISwitch *)sender {
    
    if (_switchHandler != nil) {
        _switchHandler(sender.on);
    }
    
}

- (void)updateCell:(NSString *)title isWorkday:(NSNumber *)on switchHandler:(void (^)(BOOL))handler {
    
    titleLabel.text = title;
    workDaySwitch.on = [on boolValue];
    
    self.switchHandler = handler;
    
}

@end
