//
//  WorkingDayCell.m
//  Hakenman
//
//  Created by kjcode on 2014/10/25.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "WorkingDayCell.h"
#import "UIColor+Helper.h"
#import "Util.h"

@interface WorkingDayCell()

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

@end

@implementation WorkingDayCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        _notificationView = [[UIView alloc] init];
        [_notificationView setBackgroundColor:[UIColor HKMOrangeColor]];
        [_notificationView setHidden:YES];
        [self.contentView addSubview:_notificationView];
        
        self.startLabel = [UILabel new];
        _startLabel.font = [UIFont systemFontOfSize:12.f];
        _startLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_startLabel];
        
        self.endLabel = [UILabel new];
        _endLabel.font = [UIFont systemFontOfSize:12.f];
        _endLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_endLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.frame.size;
    
    [[self notificationView] setFrame:CGRectMake(viewSize.width - 15.f, 5, 10, 10)];
    
    self.notificationView.layer.cornerRadius = 5.f;
    self.notificationView.clipsToBounds = true;
    
    
    self.backgroundView.layer.cornerRadius = 25.f;
    self.backgroundView.clipsToBounds = true;
    
    _startLabel.frame = CGRectMake(5.f,
                                   viewSize.height -10.f,
                                   self.frame.size.width,
                                   15.f);
    
    _endLabel.frame = CGRectMake(5.f,
                                 _startLabel.frame.origin.y + 15.f,
                                 self.frame.size.width,
                                 15.f);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [[self notificationView] setHidden:YES];
}

#pragma mark - setter
- (void)setMemo:(BOOL)b {
    
    _notificationView.hidden = !b;
    
    _memo = b;
    
}
#pragma mark - private methods
- (void)updateWorkStartTime:(NSString *)st endTime:(NSString *)et {
    
    if (st != nil) {
        _startLabel.text = [NSString stringWithFormat:@"%@:%@",
                            [st substringWithRange:NSMakeRange(8, 2)],
                            [st substringWithRange:NSMakeRange(10, 2)]];
    }
    
    if (et != nil) {
        _endLabel.text = [NSString stringWithFormat:@"%@:%@",
                            [et substringWithRange:NSMakeRange(8, 2)],
                            [et substringWithRange:NSMakeRange(10, 2)]];
    }
    
    
}

@end
