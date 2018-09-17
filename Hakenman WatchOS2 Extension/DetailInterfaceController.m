//
//  DetailInterfaceController.m
//  Hakenman
//
//  Created by lee jaeeun on 2015/09/29.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "DetailInterfaceController.h"
#import "DailyWorkTableRowController.h"
#import "NSDate+Helper.h"
#import "const.h"
#import "WatchUtil.h"
#import "NSUserDefaults+Setting.h"
#import "HKMConnectivityManager.h"

@interface DetailInterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *dailyWorkTable;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *totalWorkTimeLabel;

@property (nonatomic, strong) NSDate *sheetDate;
@end


@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    //set param.
    NSString *yyyymm = [NSString stringWithFormat:@"%@",context];
    NSString *yyyymmdd = [NSString stringWithFormat:@"%@01",context];
    self.sheetDate = [NSDate convDate2ShortString:yyyymmdd];
    
    // Configure interface objects here.
    if (yyyymm !=nil && yyyymm.length==6) {
        int month = [[yyyymm substringWithRange:NSMakeRange(4, 2)] intValue];
        [self setTitle:[WatchUtil monthString:month]];
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [[HKMConnectivityManager sharedInstance] sessionConnect];
    
    [self loadTitleData:@selector(loadTitleDataFinished:)];
    
    [self loadTableData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - private methods
-(void)reloadSheetDate:(SEL)handler {

    HKMConnectivityManager *mgr = [HKMConnectivityManager sharedInstance];

    //終わる日時にあわせて繰り返す
    NSString *yyyymm = [NSString stringWithFormat:@"%d%02d", [_sheetDate getYear], [_sheetDate getMonth]];
    
    __typeof (self) __weak weakSelf = self;
    
    [mgr sendMessageYear:[yyyymm substringWithRange:NSMakeRange(0, 4)]
                   month:[yyyymm substringWithRange:NSMakeRange(4, 2)]
            replyHandler:^(NSDictionary *results) {
        
                if (results==nil) {
                    return;
                }
                
                NSMutableArray *sheetItems = [NSMutableArray new];
                
                NSArray *result_item = results[@"data"];
                
                //sheetDateからその月の最後の日を算出（何日で終わるのか）
                int lastDay = [weakSelf.sheetDate getLastday];
                //sheetDateからその日の曜日を算出
                int weekDay = [weakSelf.sheetDate getWeekday];
                //休日か否かを取る
                NSNumber *workFlag = [NSNumber numberWithBool:YES];
                
                NSNumber *leftDates = nil;
                NSNumber *leftWeeks = nil;
                
                for (int i = 1; i<=lastDay; i++) {
                    
                    NSMutableDictionary *dayItems = [NSMutableDictionary new];
                    
                    leftDates = [NSNumber numberWithInt:i];
                    leftWeeks = [NSNumber numberWithInt:weekDay];
                    
                    //土日は基本的に休み
                    if (weekDay == weekSatDay || weekDay == weekSunday) {
                        workFlag = [NSNumber numberWithBool:NO];
                    }else{
                        workFlag = [NSNumber numberWithBool:YES];
                    }
                    
                    dayItems[@"year"] = @([weakSelf.sheetDate getYear]);
                    dayItems[@"month"] = @([weakSelf.sheetDate getMonth]);
                    dayItems[@"day"] = leftDates;
                    dayItems[@"week"] = leftWeeks;
                    dayItems[@"workFlag"] = workFlag;
                    
                    
                    //取り出した結果のデータ(資料型)  fetchとして取り出した結果
                    for (NSDictionary *tm in result_item) {
                        //DBに保存されている値を日付単位で検索、表示する日付にあたる値が出るとその値をrightDataModelに入れる
                        NSString *compareStringToday = [NSString stringWithFormat:@"%@%.2d%.2d", dayItems[@"year"], [weakSelf.sheetDate getMonth], i];
                        NSString *compareStringCore = [NSString stringWithFormat:@"%@", tm[@"t_yyyymmdd"]];
                        
                        if ([compareStringToday isEqualToString:compareStringCore]) {
                            
                            NSMutableDictionary *workData = [NSMutableDictionary new];
                            workData[@"start_time"]     = tm[@"start_time"]?:@"";
                            workData[@"end_time"]       = tm[@"end_time"]?:@"";
                            workData[@"rest_time"]      = tm[@"rest_time"]?:@"";
                            workData[@"workday_flag"]   = tm[@"workday_flag"]?:@"0";
                            workData[@"remark"]         = tm[@"remarks"]?:@"";
                            
                            dayItems[@"workData"] = workData;
                        }
                    }
                    //土曜日になったら、曜日表示を日曜日からやり直す
                    if (weekDay == 7) {
                        weekDay = 1;
                    }else{
                        weekDay++;
                    }
                    
                    [sheetItems addObject:dayItems];
                }
                
                [self performSelectorOnMainThread:handler withObject:(NSArray *)sheetItems waitUntilDone:NO];
    }];
    
}

- (void)reloadSheetDataFinished:(NSArray *)dayItems {
    
    [_dailyWorkTable setNumberOfRows:dayItems.count withRowType:@"DailyTableRow"];
    
    __typeof (self) __weak weakSelf = self;
    
    [dayItems enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        DailyWorkTableRowController *row = [weakSelf.dailyWorkTable rowControllerAtIndex:idx];
        
        [row.dateLabel setText:[NSString stringWithFormat:@"%02d",[dict[@"day"] intValue]]];
        [row.weekLabel setText:[WatchUtil weekdayString:[dict[@"week"] intValue]]];
        
        BOOL isWorkData = NO;
        if (dict[@"workData"] != nil) {
            
            if (dict[@"workData"][@"workday_flag"] != nil
                && [dict[@"workData"][@"workday_flag"] boolValue] == YES) {
                
                //営業日のみセット
                NSString *start_time = dict[@"workData"][@"start_time"];
                [row.startTimeLabel setText:[WatchUtil timeString:start_time]];
                
                NSString *end_time = dict[@"workData"][@"end_time"];
                [row.endTimeLabel setText:[WatchUtil timeString:end_time]];
                
                NSString *remark = dict[@"workData"][@"remark"];
                [row.memoLabel setText:(remark==nil?@"":remark)];
                isWorkData = YES;
            }
            
            
        }
        
        if (isWorkData == NO) {
            //데이타 없음.
            [row.startTimeLabel setText:@"--:--"];
            [row.endTimeLabel setText:@"--:--"];
            [row.memoLabel setText:@""];
        }
        
        int weekday = [dict[@"week"] intValue];
        if (weekday == weekSatDay) {
            [row.weekLabel setTextColor:[UIColor HKMBlueColor]];
            [row.dateLabel setTextColor:[UIColor HKMBlueColor]];
        }else if(weekday == weekSunday) {
            [row.weekLabel setTextColor:[UIColor redColor]];
            [row.dateLabel setTextColor:[UIColor redColor]];
        }
    }];
    
}

- (void)loadTitleData:(SEL)handler {
    
    NSString *yyyymm = [NSString stringWithFormat:@"%d%02d", [_sheetDate getYear], [_sheetDate getMonth]];
    
    HKMConnectivityManager *mgr = [HKMConnectivityManager sharedInstance];
    
    [mgr sendMessageYear:[yyyymm substringWithRange:NSMakeRange(0, 4)]
                   month:[yyyymm substringWithRange:NSMakeRange(4, 2)]
            replyHandler:^(NSDictionary *results) {
                
                float display_total_time = 0;
                
                NSArray *items = results[@"data"];
                
                for (NSDictionary *tm in items) {
                    
                    NSDate *startTimeFromCore = [NSDate convDate2String:tm[@"start_time"]];
                    NSDate *endTimeFromCore = [NSDate convDate2String:tm[@"end_time"]];
                    
                    float workTimeFromCore = [WatchUtil getWorkTime:startTimeFromCore endTime:endTimeFromCore] - [tm[@"rest_time"] floatValue];
                    
                    if (tm[@"start_time"] == nil || [tm[@"start_time"] isEqualToString:@""] == YES
                        || tm[@"end_time"] == nil || [tm[@"end_time"] isEqualToString:@""] == YES) {
                        continue;
                    }
                    
                    if ([tm[@"workday_flag"] boolValue] == NO) {
                        workTimeFromCore = 0.f;
                    }
                    
                    display_total_time = display_total_time + workTimeFromCore;
                }
                
                
                [self performSelectorOnMainThread:handler withObject:@(display_total_time) waitUntilDone:NO];
            }];
}

- (void)loadTitleDataFinished:(NSNumber *)workTime {
    
    [_totalWorkTimeLabel setText:[NSString stringWithFormat:@"%@ %d",
                                  LOCALIZE(@"Watch_Detail_Day_Title"),
                                  [workTime intValue],
                                  LOCALIZE(@"Watch_Glance_Time_Unit")]];
}

#pragma mark - table methods
- (void)loadTableData {
    
    [self reloadSheetDate:@selector(reloadSheetDataFinished:)];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSLog(@"pressed...");
    
}

@end
