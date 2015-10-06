//
//  InterfaceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "InterfaceController.h"
#import "MonthlyWorkTableRowController.h"
#import "TimeCardSummaryDao.h"
#import "NSDate+Helper.h"
#import "WatchUtil.h"

@interface InterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *monthlyWorkTable;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nodataLabel;

@property (nonatomic, strong) NSArray *dataSource;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self setTitle:LOCALIZE(@"Watch_Top_Title")];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self loadTableData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark - table methods
- (void)loadTableData {
    
    NSMutableArray *items = [NSMutableArray new];
    
    //サマリーからデータを持ってくる
    TimeCardSummaryDao *summaryDao = [[TimeCardSummaryDao alloc] init];
    NSDate *today = [NSDate date];
    NSDate *lastYear = [today addMonth:-1];
    NSDate *oneYearsAgo = (NSDate *)[lastYear dateByAddingTimeInterval:(60*60*24*365 *-1)];
    
    NSLog(@"oneYearsAgo[%@] today[%@]",oneYearsAgo, lastYear);
    
    [items addObjectsFromArray:[summaryDao fetchModelStartMonth:[oneYearsAgo yyyyMMString]
                                                       EndMonth:[lastYear yyyyMMString] ascending:NO]];
    
    [_monthlyWorkTable setNumberOfRows:items.count withRowType:@"MonthlyTableRow"];
    
    if (items == nil || items.count == 0) {
        [_monthlyWorkTable setHidden:YES];
        [_nodataLabel setHidden:NO];
        [_nodataLabel setText:LOCALIZE(@"Watch_Top_Nodata_Message")];
        return;
    }else {
        [_monthlyWorkTable setHidden:NO];
        [_nodataLabel setHidden:YES];
        [_nodataLabel setText:LOCALIZE(@"")];
    }
    
    [items enumerateObjectsUsingBlock:^(TimeCardSummary *model, NSUInteger idx, BOOL *stop) {
        
        MonthlyWorkTableRowController *row = [_monthlyWorkTable rowControllerAtIndex:idx];
        
        NSString *yearString = [[model.t_yyyymm stringValue] substringWithRange:NSMakeRange(0, 4)];
        NSString *monthString = [[model.t_yyyymm stringValue] substringWithRange:NSMakeRange(4, 2)];
        
        [row.yearLabel setText:yearString];
        [row.monthLabel setText:monthString];
        [row.workTimeLabel setText:[NSString stringWithFormat:@"%d Hour.", [model.workTime intValue]]];
        [row.workDayLabel setText:[NSString stringWithFormat:@"%d Days.", [model.workdays intValue]]];
        
    }];
    
    self.dataSource = items;
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"%s", __FUNCTION__);
    
    TimeCardSummary *summaryModel = [_dataSource objectAtIndex:rowIndex];
    
    NSString *selected_date = [NSString stringWithFormat:@"%@", summaryModel.t_yyyymm];
    [self pushControllerWithName:@"DetailInterfaceController" context:selected_date];
}

@end



