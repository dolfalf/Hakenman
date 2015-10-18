//
//  InterfaceController.m
//  Hakenman WatchKit Extension
//
//  Created by lee jaeeun on 2015/09/15.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "InterfaceController.h"
#import "MonthlyWorkTableRowController.h"
#import "TimeCardDaoForWatch.h"
#import "TimeCardSummaryDaoForWatch.h"
#import "NSDate+Helper.h"
#import "WatchUtil.h"
#import "DBManagerForWatch.h"
#import "NSUserDefaults+Setting.h"

#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController() <WCSessionDelegate>

@property (nonatomic, weak) IBOutlet WKInterfaceTable *monthlyWorkTable;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nodataLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    //전제조건 : iphone, applewatch 상호간 세션 활성화가 되어있어야 함
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    // Configure interface objects here.
    [self setTitle:LOCALIZE(@"Watch_Top_Title")];
    
    
//    NSString *str = [[[WatchService alloc] init] hoge];
//    NSLog(@"%@", str);
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
#if 0
    NSDictionary *current_items = [self currentMonthSummaryItems];
    [_dataSource addObject:current_items];
#endif
    //サマリーからデータを持ってくる
    TimeCardSummaryDaoForWatch *summaryDao = [[TimeCardSummaryDaoForWatch alloc] init];
    
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
    TimeCardDaoForWatch *cardDao = [[TimeCardDaoForWatch alloc] init];
    NSArray *timecards = [cardDao fetchModelYear:[today getYear] month:[today getMonth]];
    
    int total_workday = 0;
    float total_workTime = 0.f;
    for (TimeCard *tm in timecards) {
        if([tm.workday_flag isEqual:@1] == YES) {
            total_workday++;
            float duration = [TimeCardSummaryDaoForWatch getWorkTime:[NSDate convDate2String:tm.start_time]
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

#pragma mark - WCSessionDelegate

- (void)sessionWatchStateDidChange:(WCSession *)session
{
    NSLog(@"%s: session = %@", __func__, session);
}

// Application Context
- (void)session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s: session = %@", __func__, session);
    });
}

// File Transfer
- (void)session:(nonnull WCSession *)session didReceiveFile:(nonnull WCSessionFile *)file
{
    dispatch_async(dispatch_get_main_queue(),^{

        NSURL *storeURL;
        NSString *fileURLStr = [[file fileURL] relativeString];
        //3파일이 다 있지 않으면 코어데이터가 텅 빈 채로 저장됨
        if ([fileURLStr hasSuffix:@".sqlite-wal"]) {
            storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject]URLByAppendingPathComponent:@"hakenModel.sqlite-wal"];
        }else if ([fileURLStr hasSuffix:@".sqlite-shm"]) {
            storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject]URLByAppendingPathComponent:@"hakenModel.sqlite-shm"];
        }else{
            storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject]URLByAppendingPathComponent:@"hakenModel.sqlite"];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[file fileURL]];
        
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:[storeURL path] contents:data attributes:nil];
        if (result) {
            NSLog(@"create file success >> %@", storeURL);
            if ([[storeURL relativeString] hasSuffix:@"hakenModel.sqlite"]) {
                [NSUserDefaults watchStoreURLFinished];
                [self loadTableData];
            }else{
                
            }
        } else {
            NSLog(@"create file error");
        }
    });
}


/** Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished. */
- (void)session:(WCSession *)session didFinishFileTransfer:(WCSessionFileTransfer *)fileTransfer error:(nullable NSError *)error{
    
    NSLog(@"%s: session = %@ fileTransfer = %@ error = %@", __func__, session, fileTransfer, error);
    
}

@end



