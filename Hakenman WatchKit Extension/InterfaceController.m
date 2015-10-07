//
//  InterfaceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "InterfaceController.h"
#import "MonthlyWorkTableRowController.h"
#import "TimeCardDao.h"
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
    
    //現在月を持ってくる
    TimeCardSummary *curr_summary = [self currentMonthSummary];
    [items addObject:curr_summary];
    
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
        
        //title
        [row.workTimeTitleLabel setText:LOCALIZE(@"Watch_Top_Worktime_Title")];
        [row.workDayTitleLabel setText:LOCALIZE(@"Watch_Top_Workday_Title")];
    }];
    
    self.dataSource = items;
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"%s", __FUNCTION__);
    
    TimeCardSummary *summaryModel = [_dataSource objectAtIndex:rowIndex];
    
    NSString *selected_date = [NSString stringWithFormat:@"%@", summaryModel.t_yyyymm];
    [self pushControllerWithName:@"DetailInterfaceController" context:selected_date];
}

#pragma mark - private methods
- (TimeCardSummary *)currentMonthSummary {
    
    NSDate *today = [NSDate date];
    TimeCardDao *cardDao = [[TimeCardDao alloc] init];
    NSArray *timecards = [cardDao fetchModelYear:[today getYear] month:[today getMonth]];
    TimeCardSummary *current_month = [[[TimeCardSummaryDao alloc] init] createModel];
    
    int total_workday = 0;
    float total_workTime = 0.f;
    for (TimeCard *tm in timecards) {
        if([tm.workday_flag isEqual:@1] == YES) {
            total_workday++;
            float duration = [TimeCardSummaryDao getWorkTime:[NSDate convDate2String:tm.start_time]
                                                     endTime:[NSDate convDate2String:tm.end_time]];
            
            duration = duration - [tm.rest_time floatValue];
            
            total_workTime = total_workTime + duration;
        }
    }
    
    NSLog(@"TimeCard calc-> totalWorkTime:%f, totalWorkDay:%d",total_workTime,total_workday);
    
    NSString *yyyymm = [NSString stringWithFormat:@"%d%2d", [today getYear], [today getMonth]];
    current_month.workTime = @(total_workTime);
    current_month.workdays = @(total_workday);
    current_month.summary_type = @1; //not used
    current_month.t_yyyymm = @([yyyymm intValue]);
    current_month.remark = @""; //not used

    return current_month;
}

@end



