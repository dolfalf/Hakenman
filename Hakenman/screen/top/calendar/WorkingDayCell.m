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
#import "const.h"

@interface WorkingDayCell()

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) UIView *containerView;
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
        
        self.containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        [_containerView setHidden:YES];
        [self.contentView addSubview:_containerView];
        
        self.startLabel = [UILabel new];
        _startLabel.backgroundColor = [[UIColor colorNamed:@"HKMSkyblueColor"] colorWithAlphaComponent:0.1f];
        [_containerView addSubview:_startLabel];
        
        self.endLabel = [UILabel new];
        _endLabel.backgroundColor = [[UIColor  colorNamed:@"HKMSkyblueColor"] colorWithAlphaComponent:0.5f];
        [_containerView addSubview:_endLabel];
        
        if ([Util is3_5inch] == YES) {
            _startLabel.font
            = _endLabel.font
            = [UIFont nanumFontOfSize:8.f];
        }else {
            _startLabel.font
            = _endLabel.font
            = [UIFont nanumFontOfSize:11.f];
        }
        
        
        _startLabel.textColor
        = _endLabel.textColor
        = [UIColor colorNamed:@"calendarWorkLabelColor"];
        
        _startLabel.textAlignment
        = _endLabel.textAlignment
        = NSTextAlignmentCenter;
        
        HKM_INIT_LABLE(self.textLabel, HKMFontTypeNanum, self.textLabel.font.pointSize);
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.frame.size;
    
    [[self notificationView] setFrame:CGRectMake(viewSize.width - 15.f, 5, 10, 10)];
    
    self.notificationView.layer.cornerRadius = 5.f;
    self.notificationView.clipsToBounds = true;
    
    self.selectedBackgroundView.layer.cornerRadius = 25.f;
    self.selectedBackgroundView.clipsToBounds = true;

    self.backgroundView.layer.cornerRadius = 25.f;
    self.backgroundView.clipsToBounds = true;
    
    
    if ([Util is3_5inch] == YES) {
        
        _containerView.frame = CGRectMake(5.f,
                                          viewSize.height -15.f,
                                          self.frame.size.width-10.f,
                                          12.f*2.f);
        
        _startLabel.frame = CGRectMake(0,0,
                                       _containerView.frame.size.width,
                                       12.f);
        
        _endLabel.frame = CGRectMake(0,
                                     _startLabel.frame.origin.y + 12.f,
                                     _containerView.frame.size.width,
                                     12.f);
    }else {
        
        _containerView.frame = CGRectMake(5.f,
                                          viewSize.height -10.f,
                                          self.frame.size.width-10.f,
                                          15.f*2.f);
        
        _startLabel.frame = CGRectMake(0,0,
                                       _containerView.frame.size.width,
                                       15.f);
        
        _endLabel.frame = CGRectMake(0,
                                     _startLabel.frame.origin.y + 15.f,
                                     _containerView.frame.size.width,
                                     15.f);
    }
    
    [_containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_containerView.layer setBorderWidth:1.f];
    //    _containerView.layer.cornerRadius = 5.f;
    //    _containerView.clipsToBounds = true;
    
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

- (void)setWorkday:(BOOL)b {
 
    _containerView.hidden = !b;
    _workday = b;
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
