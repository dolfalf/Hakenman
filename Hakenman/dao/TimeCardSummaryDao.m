//
//  TimeCardSummaryDao.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TimeCardSummaryDao.h"
#import "NSDate+Helper.h"
#import "TimeCardDao.h"
#import "Util.h"

#define ENTITIY_NAME    @"TimeCardSummary"

#define RECOVERY_CODE_ENABLED    1

@implementation TimeCardSummaryDao

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
   
#if RECOVERY_CODE_ENABLED
    //REMARK: 8월데이타만 리커버리 함.
    [self recoveryTimeCardSummaryModel];
#endif
    
    //パラメータに指定された月の情報がなければ新しく生成
    //ただし、今月なら生成する必要はない
    
    //REMARK:8월중 인스톨 -> 데이터 입력 -> 9월로 시간변경 -> 8월이 안나옴(DB확인하니 TIMECARDSUMMARY에 아무것도 없음)
    //이부분이 있으면 데이타가 갱신이 안되므로 코멘트처리 - 악당잰
//    NSDate *today = [NSDate date];
//    if([[today yyyyMMString] isEqualToString:yyyymm] == YES) {
//        DLog(@"更新対象テーブルがない");
//        return;
//    }
    
    //DLog(@"%@",[yyyymm substringWithRange:NSMakeRange(0,4)]);
    //統計を取得
    TimeCardDao *tcDao = [TimeCardDao new];
    NSArray *timecards = [tcDao fetchModelYear:[[yyyymm substringWithRange:NSMakeRange(0,4)] intValue]
                    month:[[yyyymm substringWithRange:NSMakeRange(4,2)] intValue]];
    
    int total_workday = 0;
    float total_workTime = 0.f;
    for (TimeCard *tm in timecards) {
        if([tm.workday_flag isEqual:@1] == YES) {
            total_workday++;
           float duration = [Util getWorkTime:[NSDate convDate2String:tm.start_time]
                                 endTime:[NSDate convDate2String:tm.end_time]];

            duration = duration - [tm.rest_time floatValue];
            
            total_workTime = total_workTime + duration;
        }
    }
    
    DLog(@"TimeCard calc-> totalWorkTime:%f, totalWorkDay:%d",total_workTime,total_workday);
    
    NSArray *models = [self fetchModelMonth:yyyymm];
    if (models == nil || [models count] == 0) {
        //存在しない
        TimeCardSummary *model = [self createModel];
        model.workTime = @(total_workTime);
        model.workdays = @(total_workday);
        model.summary_type = @1; //not used
#if RECOVERY_CODE_ENABLED
        model.t_yyyymm = @([yyyymm intValue]);  //REMARK: これが漏れたため全部０が設定されてしまった。
#endif
        model.remark = @""; //not used
        DLog(@"サマリーデータを生成");
    }else {
        //すでに存在すればパラメータの日付の情報を更新する。
        TimeCardSummary *model =[models objectAtIndex:0];
        model.workTime = @(total_workTime);
        model.workdays = @(total_workday);
        
        DLog(@"サマリーデータを更新");
    }
    
    // insert or update
    [self insertModel];
}

#if RECOVERY_CODE_ENABLED
- (void)recoveryTimeCardSummaryModel {

    //REMARK: t_yyyymmが「0」になっているデータはすべて削除する
    NSArray *models = [self fetchModelMonth:@"0"];
    
    if (models == nil || [models count] == 0) {
        return;
    }
    
    //ゴミデータを削除
    for (TimeCardSummary *model in models) {
        self.model = model;
        [self deleteModel];
        DLog(@"Recoveryのため、ゴミデータを削除");
    }
    
    //もし、8月のデータがTimeCardテーブルに存在する場合、データを作成してあげる
    //なぜかというと不具合のバージョンではt_yyyymmが０で生成されたため
    NSArray *recoveryModels = [self fetchModelMonth:@"201408"];
    if (recoveryModels == nil || [recoveryModels count] == 0) {
        
        int total_workday = 0;
        float total_workTime = 0.f;
        
        TimeCardDao *tcDao = [TimeCardDao new];
        NSArray *timecards = [tcDao fetchModelYear:2014 month:8];
        
        //作成するデータがなければやらない
        //데이터가 없어도 써머리는 무조건 만들어야함. - 악당잰
//        if (timecards == nil || [timecards count] == 0) {
//            DLog(@"Recoveryするデータがなければやらない");
//            return;
//        }
        
        for (TimeCard *tm in timecards) {
            if([tm.workday_flag isEqual:@1] == YES) {
                total_workday++;
                float duration = [Util getWorkTime:[NSDate convDate2String:tm.start_time]
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
        model.t_yyyymm = @(201408);
        model.remark = @""; //not used
        
        [self insertModel];
        
        DLog(@"Recoveryサマリーデータを生成");
    }
}
#endif

@end
