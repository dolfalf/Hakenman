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

- (void)drawRectOuterLine:(CGContextRef)ctx color:(UIColor *)c width:(float)w rect:(CGRect)rt;

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
    [self drawRectOuterLine:ctx
                      color:[UIColor grayColor]
                      width:1.0f
                       rect:self.bounds];
    
    
    //marginを設定
    float margin = 10.f;
    
    //marginを引いたサイズから４等分をする
    float lineH = (self.frame.size.height - margin)/24.0f;
    
    for (int i = 0; i< 24; i++) {
        
        if (i%(24/4) > 0) {
            continue;
        }
        
        float sep_line = lineH * i + margin;
        
        [self drawLine:ctx
                 color:[UIColor lightGrayColor]
                 width:1.0f
            startPoint:CGPointMake(margin, sep_line)
              endPoint:CGPointMake(self.frame.size.width - margin, sep_line)];
    }
    
    //ライングラフ描画
    int pointCount = [_delegate linePointNumber];
    float x = (self.frame.size.width - (margin*2))/6.f;
    
    //グラプ描画ポイント取得
    NSMutableArray *linePoints = [NSMutableArray new];
    float tmp_min_time, tmp_max_time = 0.f;
    
    for (int i = 0; i < pointCount; i++) {
        float work_time = [_delegate lineGraphView:self PointIndex:i];
        
        [linePoints addObject:@(work_time)];
        
        //min, max
        if (i==0) {
            tmp_min_time = tmp_max_time = work_time;
        }
        
        if (tmp_min_time > work_time) {
            tmp_min_time = work_time;
        }
        if (tmp_max_time < work_time) {
            tmp_max_time = work_time;
        }
        
    }
    
    
    for (int i = 0; i < [linePoints count]; i++) {
        
        float wt = [[linePoints objectAtIndex:i] floatValue];
        float graph_height = self.frame.size.height - (margin*2);
        float y = (graph_height - ((graph_height * wt) / tmp_max_time))+ margin;
        
        CGPoint linePoint = CGPointMake((i==0)?margin:(x*i), y);
        
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

        _preLinePoint = CGPointMake(x*i, y);
        
        
        //Max, Minのテキスト描画
        if (tmp_max_time == wt) {
            [self drawText:ctx
                      text:[NSString
                            stringWithFormat:@"%2.1f",tmp_max_time]
                      size:9.0f
                     point:CGPointMake(_preLinePoint.x - 5.f,
                                       _preLinePoint.y +5.f)];
        }
        
        if (tmp_min_time == wt) {
            [self drawText:ctx
                      text:[NSString stringWithFormat:@"%2.1f",tmp_min_time]
                      size:9.0f
                     point:CGPointMake(_preLinePoint.x - 5.f,
                                       _preLinePoint.y -15.f)];
        }
        
        DLog(@"startPoint[%@], endPoint[%@], workTime:[%f]",NSStringFromCGPoint(_preLinePoint), NSStringFromCGPoint(linePoint), wt);
    }

    
}

- (void)drawLine:(CGContextRef)ctx color:(UIColor *)c width:(float)w startPoint:(CGPoint)sp endPoint:(CGPoint)ep {

    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, sp.x, sp.y);
    CGContextAddLineToPoint(ctx, ep.x, ep.y);
    
    CGContextStrokePath(ctx);

}

- (void)drawRectOuterLine:(CGContextRef)ctx color:(UIColor *)c width:(float)w rect:(CGRect)rt {
    
    CGContextSetStrokeColorWithColor(ctx, c.CGColor);
    CGContextBeginPath(ctx);
    
    //pt1
    CGContextMoveToPoint(ctx, rt.origin.x, rt.origin.y);
    //pt2
    CGContextAddLineToPoint(ctx, rt.size.width, rt.origin.y);
    //pt3
    CGContextAddLineToPoint(ctx, rt.size.width, rt.size.height);
    //pt4
    CGContextAddLineToPoint(ctx, rt.origin.x, rt.size.height);
    //pt5
    CGContextAddLineToPoint(ctx, rt.origin.x, rt.origin.y);
    
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
