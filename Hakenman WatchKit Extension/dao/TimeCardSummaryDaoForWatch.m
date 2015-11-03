//
//  TimeCardSummaryDaoForWatch.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TimeCardSummaryDaoForWatch.h"
#import "NSDate+Helper.h"
#import "TimeCardDaoForWatch.h"

#define ENTITIY_NAME    @"TimeCardSummary"

@implementation TimeCardSummaryDaoForWatch

- (id)init {
    
    self = [super init];
    
    if (self != nil) {
        //init code
        self.entityName = ENTITIY_NAME;
    }
    
    return self;
}

- (NSArray *)fetchModelStartMonth:(NSString *)sm EndMonth:(NSString *)em ascending:(BOOL)b {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymm" ascending:b];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    //year, monthを変換
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_yyyymm >= %@ AND t_yyyymm <= %@", @([sm intValue]), @([em intValue])];
    [self.fetchRequest setPredicate:pred];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
    //既に存在したらそのまま返す
    if (items != nil && [items count] > 0) {
        return items;
    }
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}

- (NSArray *)fetchModelMonth:(NSString *)yyyymm {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymm" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_yyyymm == %@", @([yyyymm intValue])];
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
}

- (void)updatedTimeCardSummaryTable:(NSString *)yyyymm {
    
    //パラメータに指定された月の情報がなければ新しく生成
    //ただし、今月なら生成する必要はない
    
    //REMARK:8월중 인스톨 -> 데이터 입력 -> 9월로 시간변경 -> 8월이 안나옴(DB확인하니 TIMECARDSUMMARY에 아무것도 없음)
    //이부분이 있으면 데이타가 갱신이 안되므로 코멘트처리 - 악당잰
//    NSDate *today = [NSDate date];
//    if([[today yyyyMMString] isEqualToString:yyyymm] == YES) {
//        DLog(@"更新対象テーブルがない");
//        return;
//    }
    
    //NSLog(@"%@",[yyyymm substringWithRange:NSMakeRange(0,4)]);
    //統計を取得
    TimeCardDaoForWatch *tcDao = [TimeCardDaoForWatch new];
    NSArray *timecards = [tcDao fetchModelYear:[[yyyymm substringWithRange:NSMakeRange(0,4)] intValue]
                    month:[[yyyymm substringWithRange:NSMakeRange(4,2)] intValue]];
    
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
    
    NSArray *models = [self fetchModelMonth:yyyymm];
    if (models == nil || [models count] == 0) {
        //存在しない
        TimeCardSummary *model = [self createModel];
        model.workTime = @(total_workTime);
        model.workdays = @(total_workday);
        model.summary_type = @1; //not used
        model.t_yyyymm = @([yyyymm intValue]);  //REMARK: これが漏れたため全部０が設定されてしまった。
        model.remark = @""; //not used
        self.model = model; //これがなくてサマリーが更新しなかった。
//        NSLog(@"サマリーデータを生成");
    }else {
        //すでに存在すればパラメータの日付の情報を更新する。
        TimeCardSummary *model =[models objectAtIndex:0];
        model.workTime = @(total_workTime);
        model.workdays = @(total_workday);
        self.model = model; //これがなくてサマリーが更新しなかった。
        NSLog(@"サマリーデータを更新");
    }
    
    
    // insert or update
    [self insertModel];
}

- (void)removeTimeCardSummaryTable:(NSString *)yyyymm{
    
    NSArray *models = [self fetchModelMonth:yyyymm];
    if (models == nil || [models count] == 0) {
        //何もしない
    }else {
        //データを削除
        for (TimeCardSummary *model in models) {
            self.model = model;
            [self deleteModel];
        }
    }
}

- (void)updateTimeCardSummaryTableAll {
    
    NSDate *today = [NSDate date];
    
    NSArray *gTimeCards = [[TimeCardDaoForWatch new] timeSummaryTableData];
    
    for (NSDictionary *dic in gTimeCards) {
        
        int sYear = [[dic objectForKey:@"t_year"] intValue];
        int sMonth = [[dic objectForKey:@"t_month"] intValue];
        
        //現在の月はサマリーを作成しない
        if (sYear == [today getYear] && sMonth == [today getMonth]) {
            continue;
        }
        
        //サマリーが存在しない場合のみ生成
        NSString *yyyymmString = [NSString stringWithFormat:@"%d%02d",sYear,sMonth];
        NSArray *sModels = [self fetchModelMonth:yyyymmString];
        if (sModels == nil || [sModels count] == 0) {
            
            int total_workday = 0;
            float total_workTime = 0.f;
            
            TimeCardDaoForWatch *tcDao = [TimeCardDaoForWatch new];
            NSArray *timecards = [tcDao fetchModelYear:sYear month:sMonth];
            
            for (TimeCard *tm in timecards) {
                if([tm.workday_flag isEqual:@1] == YES) {
                    total_workday++;
                    float duration = [TimeCardSummaryDaoForWatch getWorkTime:[NSDate convDate2String:tm.start_time]
                                                             endTime:[NSDate convDate2String:tm.end_time]];
                    
                    duration = duration - [tm.rest_time floatValue];
                    total_workTime = total_workTime + duration;
                }
                
            }
            
            //存在しないため作成
            TimeCardSummary *model = [self createModel];
            model.workTime = @(total_workTime);
            model.workdays = @(total_workday);
            model.summary_type = @1; //not used
            model.t_yyyymm = [NSNumber numberWithInt:[yyyymmString intValue]];
            model.remark = @""; //not used
         
            [self insertModel];
            NSLog(@"%@ サマリー作成",yyyymmString);
        }
    }
    
}

+ (float)getWorkTime:(NSDate *)st endTime:(NSDate *)et {
    
    //start_time & end_time 語尾の桁数を００に変換
    
    //合計時間の計算のため秒単位の語尾を「00」に固定
    NSString *startStr = [st yyyyMMddHHmmssString];
    startStr = [startStr stringByReplacingCharactersInRange:(NSMakeRange(12, 2)) withString:@"00"];
    NSDate *convertStart = [NSDate convDate2String:startStr];
    
    NSString *endStr = [et yyyyMMddHHmmssString];
    endStr = [endStr stringByReplacingCharactersInRange:(NSMakeRange(12, 2)) withString:@"00"];
    NSDate *convertEnd = [NSDate convDate2String:endStr];
    
    NSTimeInterval since = [convertEnd timeIntervalSinceDate:convertStart];
    
    float resultSince1 = since/(60.f*60.f);
    float resultSince2 = resultSince1 * 100.f;
    float resultSince3 = ceilf(resultSince2);
    float resultSince4 = resultSince3/100.f;
    return resultSince4;
    
}

#ifdef RECOVERY_CODE_ENABLE
- (void)recoveryTimeCardSummaryTable {
    
    //REMARK: t_yyyymmが「0」になっているデータはすべて削除する
    NSArray *models = [self fetchModelMonth:@"0"];
    
    if (models == nil || [models count] == 0) {
        return;
    }
    
    //ゴミデータを削除
    for (TimeCardSummary *model in models) {
        self.model = model;
        [self deleteModel];
    }
    
    NSLog(@"Recoveryのため、ゴミデータを削除しました。");
}
#endif

@end
