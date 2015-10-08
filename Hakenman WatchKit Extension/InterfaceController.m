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

@property (nonatomic, strong) NSMutableArray *dataSource;
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
    
    self.dataSource = [NSMutableArray new];
    
    //現在月を持ってくる
#if 1
    NSDictionary *current_items = [self currentMonthSummaryItems];
    [_dataSource addObject:current_items];
#endif
    //サマリーからデータを持ってくる
    TimeCardSummaryDao *summaryDao = [[TimeCardSummaryDao alloc] init];
    
    NSDate *today = [NSDate date];
    NSDate *lastYear = [today addMonth:0];
    NSDate *oneYearsAgo = (NSDate *)[lastYear dateByAddingTimeInterval:(60*60*24*365 *-1)];
    
    NSLog(@"oneYearsAgo[%@] today[%@]",oneYearsAgo, lastYear);
    
    NSArray *summary_items = [summaryDao fetchModelStartMonth:[oneYearsAgo yyyyMMString]
                                                     EndMonth:[lastYear yyyyMMString] ascending:NO];
    
    for (int s=0; s<summary_items.count; s++) {
        TimeCardSummary *ts = summary_items[s];
        
        [_dataSource addObject:@{@"workTime":ts.workTime,
                                 @"workdays":ts.workdays,
                                 @"summary_type":@(1),
                                 @"t_yyyymm":ts.t_yyyymm,
                                 @"remark":@""}];
    }
    
    [_monthlyWorkTable setNumberOfRows:_dataSource.count withRowType:@"MonthlyTableRow"];
    
    if (_dataSource == nil || _dataSource.count == 0) {
        [_monthlyWorkTable setHidden:YES];
        [_nodataLabel setHidden:NO];
        [_nodataLabel setText:LOCALIZE(@"Watch_Top_Nodata_Message")];
        return;
    }else {
        [_monthlyWorkTable setHidden:NO];
        [_nodataLabel setHidden:YES];
        [_nodataLabel setText:LOCALIZE(@"")];
    }
    
    for (int idx=0;idx<_dataSource.count;idx++) {
        
        NSDictionary *dict = _dataSource[idx];
        
        MonthlyWorkTableRowController *row = [_monthlyWorkTable rowControllerAtIndex:idx];
        
        NSString *yearString = [[dict[@"t_yyyymm"] stringValue] substringWithRange:NSMakeRange(0, 4)];
        NSString *monthString = [[dict[@"t_yyyymm"] stringValue] substringWithRange:NSMakeRange(4, 2)];
        
        [row.yearLabel setText:yearString];
        [row.monthLabel setText:monthString];
        [row.workTimeLabel setText:[NSString stringWithFormat:@"%d Hour.", [dict[@"workTime"] intValue]]];
        [row.workDayLabel setText:[NSString stringWithFormat:@"%d Days.", [dict[@"workdays"] intValue]]];
        
        //title
        [row.workTimeTitleLabel setText:LOCALIZE(@"Watch_Top_Worktime_Title")];
        [row.workDayTitleLabel setText:LOCALIZE(@"Watch_Top_Workday_Title")];
    }
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"%s", __FUNCTION__);
    
    NSDictionary *dict = [_dataSource objectAtIndex:rowIndex];
    
    NSString *selected_date = [NSString stringWithFormat:@"%@", dict[@"t_yyyymm"]];
    [self pushControllerWithName:@"DetailInterfaceController" context:selected_date];
}

#pragma mark - private methods
- (NSDictionary *)currentMonthSummaryItems {
    
    NSDate *today = [NSDate date];
    TimeCardDao *cardDao = [[TimeCardDao alloc] init];
    NSArray *timecards = [cardDao fetchModelYear:[today getYear] month:[today getMonth]];
    
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

    return @{@"workTime":@(total_workTime),
             @"workdays":@(total_workday),
             @"summary_type":@(1),
             @"t_yyyymm":@([yyyymm intValue]),
             @"remark":@""};
}

@end



