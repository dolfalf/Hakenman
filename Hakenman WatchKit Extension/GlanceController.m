//
//  GlanceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "GlanceController.h"


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
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



