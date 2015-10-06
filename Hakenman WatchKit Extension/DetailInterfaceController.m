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
#import "TimeCardDao.h"
#import "const.h"
#import "WatchUtil.h"

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
    
    [_totalWorkTimeLabel setText:[NSString stringWithFormat:@"%@%d(%@)",
                                  LOCALIZE(@"Watch_Detail_Day_Title"),
                                  (int)[WatchUtil totalWorkTime],
                                  yyyymm]];
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

#pragma mark - private methods
-(NSArray *)reloadSheetDate {
    
    //본체화면로직에서 가져옴..
    
    NSMutableArray *sheetItems = [NSMutableArray new];
    
    NSNumber *leftDates = nil;
    NSNumber *leftWeeks = nil;
    
    //sheetDateからその月の最後の日を算出（何日で終わるのか）
    int lastDay = [_sheetDate getLastday];
    //sheetDateからその日の曜日を算出
    int weekDay = [_sheetDate getWeekday];
    //休日か否かを取る
    NSNumber *workFlag = [NSNumber numberWithBool:YES];
    //終わる日時にあわせて繰り返す
    
    //right
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *models = [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    
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
        
        dayItems[@"year"] = @([_sheetDate getYear]);
        dayItems[@"month"] = @([_sheetDate getMonth]);
        dayItems[@"day"] = leftDates;
        dayItems[@"week"] = leftWeeks;
        dayItems[@"workFlag"] = workFlag;
        
        
        //取り出した結果のデータ(資料型)  fetchとして取り出した結果
        for (TimeCard *tm in models) {
            //DBに保存されている値を日付単位で検索、表示する日付にあたる値が出るとその値をrightDataModelに入れる
            NSString *compareStringToday = [NSString stringWithFormat:@"%@%.2d%.2d", dayItems[@"yearData"], [_sheetDate getMonth], i];
            NSString *compareStringCore = [NSString stringWithFormat:@"%@", tm.t_yyyymmdd];
            
            if ([compareStringToday isEqualToString:compareStringCore]) {
                
                NSMutableDictionary *workData = [NSMutableDictionary new];
                workData[@"start_time"] = tm.start_time;
                workData[@"end_time"] = tm.end_time;
                workData[@"rest_time"] = tm.rest_time;
                workData[@"workday_flag"] = tm.workday_flag;
                workData[@"remark"] = tm.remarks;
                
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
    
    return (NSArray *)sheetItems;
    
}

#pragma mark - table methods
- (void)loadTableData {
    
    NSArray *dayItems = [self reloadSheetDate];
    
    [_dailyWorkTable setNumberOfRows:dayItems.count withRowType:@"DailyTableRow"];
    
    [dayItems enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        DailyWorkTableRowController *row = [_dailyWorkTable rowControllerAtIndex:idx];
        
        
//        dict[@"year"] = @([_sheetDate getYear]);
//        dict[@"month"] = @([_sheetDate getMonth]);
        
        [row.dateLabel setText:[NSString stringWithFormat:@"%02d",[dict[@"day"] intValue]]];
        [row.weekLabel setText:[WatchUtil weekdayString:[dict[@"week"] intValue]]];
        
        BOOL isWorkData = NO;
        if (dict[@"workData"] != nil) {
            
            if (dict[@"workData"][@"workday_flag"] != nil
                && [dict[@"workData"][@"workday_flag"] boolValue] == YES) {
                
                //営業日のみセット
                NSString *start_time = dict[@"workData"][@"start_time"];
                [row.startTimeLabel setText:(start_time==nil?@"":start_time)];
                
                NSString *end_time = dict[@"workData"][@"end_time"];
                [row.endTimeLabel setText:(end_time==nil?@"":end_time)];
                
                NSString *remark = dict[@"workData"][@"remark"];
                [row.memoLabel setText:(remark==nil?@"":remark)];
                isWorkData = YES;
            }
        }
        
        if (isWorkData == NO) {
            //dlqfur데이타 없음.
            NSString *start_time = dict[@"workData"][@"start_time"];
            [row.startTimeLabel setText:(start_time==nil?@"":start_time)];
            
            NSString *end_time = dict[@"workData"][@"end_time"];
            [row.endTimeLabel setText:(end_time==nil?@"":end_time)];
            
            NSString *remark = dict[@"workData"][@"remark"];
            [row.memoLabel setText:(remark==nil?@"":remark)];
        }
    }];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSLog(@"pressed...");
    
}

@end



