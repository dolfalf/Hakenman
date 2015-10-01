//
//  GlanceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "GlanceController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "TimeCardDao.h"
#import "NSDate+Helper.h"

@interface GlanceController()

@property (nonatomic, weak) IBOutlet WKInterfaceImage *iconImage;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *titleLabel;

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *monthlyWorkTimeTitleLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *monthlyWorkTimeLabel;

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workStartTitleLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *workStartLabel;

@property (nonatomic, weak) IBOutlet WKInterfaceImage *graphImage;
@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    
    //그래프
    [self drawGraphView];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - private methods
- (void)loadScreenData {
    
}

#pragma mark - draw methods
- (void)drawGraphView {
    
    //http://d.hatena.ne.jp/shu223/20150714/1436875676
    
    // Create a graphics context
    //fix size.
    float g_width = 130*2.f;
    float g_height = 50*2.f;
    
    float margin = 4.f;
    
    CGSize size = CGSizeMake(g_width, g_height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //배경칠하기
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, g_width , g_height) cornerRadius:10.f];
    [path fill];
    CGContextFillPath(context);
    
    //배경선 그리기 가로줄 4개
    
    for (int b_line=0; b_line<4; b_line++) {
        
        float line_y = g_height/(4+1)*(b_line+1);
        NSValue *start_pt = [NSValue valueWithCGPoint:CGPointMake(0 + margin, line_y)];
        NSValue *end_pt = [NSValue valueWithCGPoint:CGPointMake(g_width - margin, line_y)];
        
        [self drawline:context lineWidth:1.f
                 color:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]
                points:@[start_pt, end_pt]];
    }

    
    TimeCardDao *dao = [TimeCardDao new];
    NSArray *weekTimeCards = [dao fetchModelGraphDate:[NSDate date]];
    
    //최대값 구함.
    float max_worktime = 8.f;  //default
    for (TimeCard *card in weekTimeCards) {
        NSTimeInterval t = [[NSDate convDate2String:card.end_time]
                            timeIntervalSinceDate:[NSDate convDate2String:card.start_time]];
        
        float duration = (float)t - [card.rest_time floatValue];
        float work_time = (duration / (60*60)) - [card.rest_time floatValue];
        
        if (max_worktime < work_time) {
            max_worktime = work_time;
        }
    }
    
    //데이터 그래프 그리기
    NSMutableArray *data_points = [NSMutableArray new];
    int data_count = 0;
    for (TimeCard *card in weekTimeCards) {
        NSTimeInterval t = [[NSDate convDate2String:card.end_time]
                            timeIntervalSinceDate:[NSDate convDate2String:card.start_time]];
        
        float duration = (float)t - [card.rest_time floatValue];
        float work_time = (duration / (60*60)) - [card.rest_time floatValue];
        
        //좌표로 변환
        float data_x = ((g_width/weekTimeCards.count) * data_count) + margin;
        float data_y = (g_height - (g_height*work_time)/max_worktime) + margin;
        [data_points addObject:[NSValue valueWithCGPoint:CGPointMake(data_x, data_y)]];
        
        data_count++;
    }
    
    [self drawline:context lineWidth:2.f color:[UIColor whiteColor] points:data_points];
    
    //circle
    for (NSValue *val in data_points) {
        
        //drawCircle
        CGPoint pt = [val CGPointValue];
        [self drawCircle:context size:8.f point:pt color:[UIColor whiteColor]];
    }
    
    //text
    NSString *t = @"あいう";
    UIColor *color = [UIColor redColor];
    UIColor *bcolor = [UIColor blueColor];
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                                     NSBackgroundColorAttributeName:bcolor,
                                     NSForegroundColorAttributeName:color};
    
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = 0.5; // Half the font size
    
    [t drawWithRect:CGRectMake(0.0, 0.0, g_width, g_height)
                 options:NSStringDrawingUsesLineFragmentOrigin
              attributes:textAttributes
                 context:drawingContext];

    
    
    
    // Convert to UIImage
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *uiimage = [UIImage imageWithCGImage:cgimage];
    
    // End the graphics context
    UIGraphicsEndImageContext();
    
    [_graphImage setImage:uiimage];
    
}

- (void)drawline:(CGContextRef)ctx lineWidth:(float)lineWidth color:(UIColor *)color points:(NSArray *)points {
    
    CGContextBeginPath(ctx);
    
    for (int i=0;i<points.count;i++) {
        NSValue *val = points[i];
        CGPoint pt = [val CGPointValue];
        
        CGContextSetStrokeColorWithColor(ctx, color.CGColor);
        CGContextSetLineWidth(ctx, lineWidth);
        
        if (i==0) {
            //start point
            CGContextMoveToPoint(ctx, pt.x, pt.y);
            
        }else {
            CGContextAddLineToPoint(ctx, pt.x, pt.y);
        }
    }
    
    CGContextStrokePath(ctx);
}

- (void)drawCircle:(CGContextRef)ctx size:(float)size point:(CGPoint)pt color:(UIColor *)color {
    
    CGContextBeginPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pt.x-size/2.f, pt.y-size/2.f, size, size)];
    [aPath fill];
    
    CGContextFillPath(ctx);
    
}

@end



