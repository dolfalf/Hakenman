//
//  BorderLabel.m
//  Hakenman
//
//  Created by kjcode on 2014/07/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "BorderLabel.h"

@implementation BorderLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, self.bounds.size.width, self.bounds.origin.y);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.origin.x, self.bounds.size.height);

    
    
    CGContextStrokePath(ctx);

}


@end
