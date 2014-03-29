//
//  LineGraphView.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "LineGraphView.h"

@interface LineGraphView()

- (void)drawLine:(CGContextRef)ctx color:(UIColor *)c width:(float)w startPoint:(CGPoint)sp endPoint:(CGPoint)ep;

- (void)drawCircle:(CGContextRef)ctx fillColor:(UIColor *)fc strokeColor:(UIColor *)sc radius:(float)r CenterPoint:(CGPoint)cp;
- (void)drawCircle:(CGContextRef)ctx color:(UIColor *)c radius:(float)r CenterPoint:(CGPoint)cp;

- (void)drawText:(CGContextRef)ctx text:(NSString *)t size:(float)s point:(CGPoint)p;

@end

@implementation LineGraphView

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
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawLine:ctx
         color:[UIColor grayColor]
         width:1.0f
        startPoint:CGPointMake(10, 20)
          endPoint:CGPointMake(100, 40)];
    
    [self drawCircle:ctx
           fillColor:[UIColor blackColor]
         strokeColor:[UIColor grayColor]
              radius:30.0f
         CenterPoint:CGPointMake(250, 40)];
    
    [self drawText:ctx text:@"Graph TEST!!" size:13.0f point:CGPointMake(100, 100)];
}

- (void)drawLine:(CGContextRef)ctx color:(UIColor *)c width:(float)w startPoint:(CGPoint)sp endPoint:(CGPoint)ep {

    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, sp.x, sp.y);
    CGContextAddLineToPoint(ctx, ep.x, ep.y);
    
    CGContextStrokePath(ctx);

}

- (void)drawCircle:(CGContextRef)ctx fillColor:(UIColor *)fc strokeColor:(UIColor *)sc radius:(float)r CenterPoint:(CGPoint)cp {
    
    // Set the width of the line
    CGContextSetLineWidth(ctx, 2.0);
    
    //Make the circle
    // 150 = x coordinate
    // 150 = y coordinate
    // 100 = radius of circle
    // 0   = starting angle
    // 2*M_PI = end angle
    // YES = draw clockwise
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, cp.x, cp.y, r, 0, 2*M_PI, YES);
    CGContextClosePath(ctx);
    
    //color
    CGContextSetFillColorWithColor(ctx, fc.CGColor);
    CGContextSetStrokeColorWithColor(ctx, sc.CGColor);
    
    // Note: If I wanted to only stroke the path, use:
    // CGContextDrawPath(context, kCGPathStroke);
    // or to only fill it, use:
    // CGContextDrawPath(context, kCGPathFill);
    
    //Fill/Stroke the path
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}

- (void)drawCircle:(CGContextRef)ctx color:(UIColor *)c radius:(float)r CenterPoint:(CGPoint)cp {
    
    [self drawCircle:ctx fillColor:c strokeColor:c radius:r CenterPoint:cp];
}

- (void)drawText:(CGContextRef)ctx text:(NSString *)t size:(float)s point:(CGPoint)p {
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill); // This is the default
    
    [[UIColor redColor] setFill]; // This is the default
    
    [t drawAtPoint:CGPointMake(p.x, p.y)
               withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"
                                                                    size:s]}];
    
}

@end
