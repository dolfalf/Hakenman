//
//  LineGraphView.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "LineGraphView.h"

@interface LineGraphView() {
    
    CGPoint _preLinePoint;
}

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

- (void)reloadLineGraphView {
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //背景線を描画
    
    //２４時間の中、6時間ことにラインを引く
    float lineH = self.frame.size.height/24.0f;
    
    for (int i = 0; i< 24; i++) {
        if (i%5 == 0) {
            
            if (lineH * i >= self.frame.size.height
                || lineH * i == 0) {
                continue;
            }
            
        [self drawLine:ctx
             color:[UIColor grayColor]
             width:1.0f
            startPoint:CGPointMake(20, lineH * i)
              endPoint:CGPointMake(self.frame.size.width-20, lineH * i)];
        }
    }
    
    //ライングラフ描画
    int pointCount = [_delegate linePointNumber];
    float x = (self.frame.size.width - (20*2))/7.f;
    
    CGPoint minPoint = CGPointMake(0, self.frame.size.height);
    float minWorkTime = 24.f;
    CGPoint maxPoint = CGPointMake(0, 0);
    float maxWorkTime = 0.f;
    
    //TODO: 描画処理追加
    for (int i = 0; i < pointCount; i++) {
        
        float workTime = [_delegate lineGraphView:self PointIndex:i];
        
        float y = self.frame.size.height - ((self.frame.size.height * workTime) / 24.0f);
        CGPoint linePoint = CGPointMake(x * (i+1), y);
        
        //draw circle
        [self drawCircle:ctx color:[UIColor blackColor] radius:3 CenterPoint:linePoint];
        
        if (i == 0) {
            _preLinePoint = linePoint;
            continue;
        }
        
        //draw line
        [self drawLine:ctx
                 color:[UIColor blackColor]
                 width:2.0f
            startPoint:_preLinePoint
              endPoint:linePoint];
        
        
        if (linePoint.y >= maxPoint.y) {
            maxPoint = linePoint;
            maxWorkTime = workTime;
        }
        
        if (linePoint.y <= minPoint.y) {
            minPoint = linePoint;
            minWorkTime = workTime;
        }
        
        _preLinePoint = CGPointMake(x * (i+1), y);
        
        
        
        DLog(@"startPoint[%@], endPoint[%@], workTime:[%f]",NSStringFromCGPoint(_preLinePoint), NSStringFromCGPoint(linePoint), workTime);
    }

    //Max, Minのテキスト描画
    [self drawText:ctx
              text:[NSString stringWithFormat:@"%2.1f",minWorkTime]
              size:9.0f
             point:CGPointMake(minPoint.x, minPoint.y - 15)];
    
    [self drawText:ctx
              text:[NSString
                    stringWithFormat:@"%2.1f",maxWorkTime]
              size:9.0f
             point:CGPointMake(maxPoint.x, maxPoint.y - 15)];
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
