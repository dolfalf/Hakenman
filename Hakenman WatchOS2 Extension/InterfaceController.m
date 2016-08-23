//
//  InterfaceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "InterfaceController.h"
#import "MonthlyWorkTableRowController.h"
#import "NSDate+Helper.h"
#import "WatchUtil.h"
#import "NSUserDefaults+Setting.h"
#import "HKMConnectivityManager.h"

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
    
    
//    NSString *str = [[[WatchService alloc] init] hoge];
//    NSLog(@"%@", str);
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [[HKMConnectivityManager sharedInstance] sessionConnect];
    
    [self loadTableData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark - table methods
- (void)loadTableData {
    
    self.dataSource = [NSMutableArray new];
    
#if 0
    //現在月を持ってくる
    NSDictionary *current_items = [self currentMonthSummaryItems];
    [_dataSource addObject:current_items];
#endif

    [self loadSheetData:@selector(sheetDataFinished:)];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"%s", __FUNCTION__);
    
    NSDictionary *dict = [_dataSource objectAtIndex:rowIndex];
    
    NSString *selected_date = [NSString stringWithFormat:@"%@", dict[@"t_yyyymm"]];
    [self pushControllerWithName:@"DetailInterfaceController" context:selected_date];
}

#pragma mark - private methods

- (void)loadSheetData:(SEL)handler {
    
    //サマリーからデータを持ってくる
    HKMConnectivityManager *mgr = [HKMConnectivityManager sharedInstance];
    
    NSDate *today = [NSDate date];
    NSDate *lastYear = [today addMonth:0];
    NSDate *oneYearsAgo = (NSDate *)[lastYear dateByAddingTimeInterval:(60*60*24*365 *-1)];
    
    NSLog(@"oneYearsAgo[%@] today[%@]",oneYearsAgo, lastYear);
    
    [mgr sendMessageSummaryModelStartMonth:[oneYearsAgo yyyyMMString]
                                  endMonth:[lastYear yyyyMMString]
                                 ascending:NO
                              replyHandler:^(NSDictionary *results) {
                                  
                                  if (results==nil) {
                                      return;
                                  }
                                  
                                  NSArray *result_item = results[@"data"];
                                  
                                  NSMutableArray *work_items = [NSMutableArray new];
                                  
                                  for (int s=0; s<result_item.count; s++) {
                                      
                                      NSDictionary *summary_dict = result_item[s];
                                      
                                      [work_items addObject:@{@"workTime":summary_dict[@"workTime"],
                                                               @"workdays":summary_dict[@"workdays"],
                                                               @"summary_type":@(1),
                                                               @"t_yyyymm":summary_dict[@"t_yyyymm"],
                                                               @"remark":@""}];
                                  }
                                  
                                  [self performSelectorOnMainThread:handler withObject:work_items waitUntilDone:NO];
                                  
                              }];
}

- (void)sheetDataFinished:(NSArray *)items {
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:items];
    
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

#if 0
- (NSDictionary *)currentMonthSummaryItems {
    
    HKMConnectivityManager *mgr = [HKMConnectivityManager sharedInstance];
    [mgr sendMessageTimeCardModel:^(NSDictionary *results) {
        NSArray *result_item = results[@"data"];
        int total_workday = 0;
        float total_workTime = 0.f;
        NSDate *today = [NSDate date];
        
        for (NSDictionary *time_card in result_item) {
            if([time_card[@"workday_flag"] isEqual:@1] == YES) {
                total_workday++;
                float duration = [WatchUtil getWorkTime:[NSDate convDate2String:time_card[@"start_time"]]
                                                endTime:[NSDate convDate2String:time_card[@"end_time"]]];

                duration = duration - [time_card[@"rest_time"] floatValue];

                total_workTime = total_workTime + duration;
            }
        }
        
        NSLog(@"TimeCard calc-> totalWorkTime:%f, totalWorkDay:%d",total_workTime,total_workday);

        NSString *yyyymm = [NSString stringWithFormat:@"%d%2d", [today getYear], [today getMonth]];
        
//        return @{@"workTime":@(total_workTime),
//                 @"workdays":@(total_workday),
//                 @"summary_type":@(1),
//                 @"t_yyyymm":@([yyyymm intValue]),
//                 @"remark":@""};
                            
    }];
        
    return nil;
}
#endif
     
@end



