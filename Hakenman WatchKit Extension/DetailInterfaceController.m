//
//  DetailInterfaceController.m
//  Hakenman
//
//  Created by lee jaeeun on 2015/09/29.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "DetailInterfaceController.h"
#import "DailyWorkTableRowController.h"

@interface DetailInterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *dailyWorkTable;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *totalWorkTimeLabel;
@end


@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self loadTableData];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - table methods
- (void)loadTableData {
    
    NSArray *fruitNames = @[@"Apple", @"Orange", @"Banana"];
    
    [_dailyWorkTable setNumberOfRows:fruitNames.count withRowType:@"DailyTableRow"];
    
    [fruitNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        
        DailyWorkTableRowController *row = [_dailyWorkTable rowControllerAtIndex:idx];
        
        [row.startTimeLabel setText:name];
        [row.endTimeLabel setText:[NSString stringWithFormat:@"%d", (int)idx]];
        
    }];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSLog(@"pressed...");
    
}

@end



