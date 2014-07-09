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
   
    //パラメータに指定された月の情報がなければ新しく生成
    //ただし、今月なら生成する必要はない
    NSDate *today = [NSDate date];
    if([[today yyyyMMString] isEqualToString:yyyymm] == YES) {
        DLog(@"更新対象テーブルがない");
        return;
    }
    
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
        }
        
        float duration = [Util getWorkTime:[NSDate convDate2String:tm.start_time]
                                   endTime:[NSDate convDate2String:tm.end_time]];

        total_workTime = total_workTime + duration;
        
    }
    
    DLog(@"TimeCard calc-> totalWorkTime:%f, totalWorkDay:%d",total_workTime,total_workday);
    
    NSArray *models = [self fetchModelMonth:yyyymm];
    if (models == nil || [models count] == 0) {
        //存在しない
        TimeCardSummary *model = [self createModel];
        model.workTime = @(total_workTime);
        model.workdays = @(total_workday);
        model.summary_type = @1; //not used
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

@end
