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
#import "TimeCardDaoForWatch.h"
#import "const.h"
#import "WatchUtil.h"

#import "NSUserDefaults+Setting.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface DetailInterfaceController() <WCSessionDelegate>

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
    
    [_totalWorkTimeLabel setText:[NSString stringWithFormat:@"%@ %d%@",
                                  LOCALIZE(@"Watch_Detail_Day_Title"),
                                  (int)[WatchUtil totalWorkTime:yyyymm],
                                  LOCALIZE(@"Watch_Glance_Time_Unit")]];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    //전제조건 : iphone, applewatch 상호간 세션 활성화가 되어있어야 함
    //와치앱이 시작되는 시점을 알수 없기 때문에 화면이 활성화되는 타이밍에서 세션을 체크해줘야함.
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [self loadTableData];
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
    TimeCardDaoForWatch *dao = [TimeCardDaoForWatch new];
    
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
            NSString *compareStringToday = [NSString stringWithFormat:@"%@%.2d%.2d", dayItems[@"year"], [_sheetDate getMonth], i];
            NSString *compareStringCore = [NSString stringWithFormat:@"%@", tm.t_yyyymmdd];
            
            if ([compareStringToday isEqualToString:compareStringCore]) {
                
                NSMutableDictionary *workData = [NSMutableDictionary new];
                workData[@"start_time"] = tm.start_time==nil?@"":tm.start_time;
                workData[@"end_time"] = tm.end_time==nil?@"":tm.end_time;
                workData[@"rest_time"] = tm.rest_time==nil?@"":tm.rest_time;
                workData[@"workday_flag"] = tm.workday_flag==nil?@"0":tm.workday_flag;
                workData[@"remark"] = tm.remarks==nil?@"":tm.remarks;
                
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

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSLog(@"pressed...");
    
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

@end



