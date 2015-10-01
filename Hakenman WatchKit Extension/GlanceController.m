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
- (void)drawGraphView {
    
    //http://d.hatena.ne.jp/shu223/20150714/1436875676
    
    
    //main screen
    TimeCardDao *dao = [TimeCardDao new];
//    NSArray *weekTimeCards = [dao fetchModelGraphDate:[NSDate date]];
//    
//    NSTimeInterval t = [[NSDate convDate2String:card.end_time]
//                        timeIntervalSinceDate:[NSDate convDate2String:card.start_time]];
//    
//    float duration = (float)t - [card.rest_time floatValue];
//    
//    float work_time = (duration / (60*60)) - [card.rest_time floatValue];
    
    // Create a graphics context
    //fix size.
    float g_width = 130*2.f;
    float g_height = 50*2.f;
    
    CGSize size = CGSizeMake(g_width, g_height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Setup for the path appearance
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.f);
    
    // Draw lines
    CGContextBeginPath (context);

    ////////////////////////////////////////////////////////
    for (int i=0; i<7; i++) {
        
        if (i==0) {
            //start point
            CGContextMoveToPoint(context, (g_width/7)*i, 0);
            
        }else {
            
            float height = (arc4random()%(int)g_height);
            CGContextAddLineToPoint(context, (g_width/7)*i, height);
        }
    }
    ////////////////////////////////////////////////////////
    
    CGContextStrokePath(context);
    
    //circle
    CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 1.0, 1.0);
//    CGContextSetLineWidth(context, 1.f);
    
    for (int i=0; i<7; i++) {
        float height = (arc4random()%(int)g_height);
        CGRect r1 = CGRectMake((g_width/7)*i , height, 10.0, 10.0);
        CGContextAddEllipseInRect(context,r1);
        CGContextFillPath(context);
    }
    
    
    
    // Convert to UIImage
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *uiimage = [UIImage imageWithCGImage:cgimage];
    
    // End the graphics context
    UIGraphicsEndImageContext();
    
    [_graphImage setImage:uiimage];
    
}

@end



