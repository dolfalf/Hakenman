//
//  TimeCardDao.m
//  Hakenman
//
//  Created by lee jaeeun on 12/03/14.
//  Copyright (c) 2012年 kj-code. All rights reserved.
//

#import "TimeCardDao.h"
#import "NSDate+Helper.h"
#import "const.h"

#define ENTITIY_NAME    @"TimeCard"

@interface TimeCardDao()

- (void)createMonthWorkData:(NSDate *)dt;   //指定された月のデータを生成する
@end

@implementation TimeCardDao


- (id)init {
    
    self = [super init];
    
    if (self != nil) {
        //init code
        self.entityName = ENTITIY_NAME;
    }
    
    return self;
}

- (void)createMonthWorkData:(NSDate *)dt {
    
    int w_year = [dt getYear];
    int w_month = [dt getMonth];
    
    for (int day=1; day <= [dt getLastday]; day++) {
        DLog(@"day:[%d]",day);
        int w_week = [[dt getDayOfMonth:day] getWeekday];
        
        TimeCard *model = [self createModel];
        
        //default setting.
        model.t_year = [NSNumber numberWithInt:w_year];
        model.t_month = [NSNumber numberWithInt:w_month];
        model.t_day = [NSNumber numberWithInt:day];
        model.t_week = [NSNumber numberWithInt:w_week];
        model.t_yyyymmdd = [NSString stringWithFormat:@"%d%02d%02d",w_year, w_month, day];
        model.rest_time = @(1.f);
        if (w_week == weekSatDay || w_week == weekSunday) {
            model.working_day = @(NO);
        }else {
            model.working_day = @(YES);
        }
        
//        model.remarks;
//        model.end_time;
//        model.start_time;
//        model.time_card_site_info;
    }
    
    [self insertModel];
    
}

- (NSArray *)fetchModelWorkMonth:(NSDate *)dt {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymmdd" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    //year, monthを取得
    NSNumber *nYear = [NSNumber numberWithInt:[dt getYear]];
    NSNumber *nMonth = [NSNumber numberWithInt:[dt getMonth]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_year = %@ AND t_month = %@", nYear, nMonth];
    [self.fetchRequest setPredicate:pred];
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
    //既に存在したらそのまま返す
    if (items != nil && [items count] > 0) {
        return items;
    }
    
    //存在しなければ作成
    [self createMonthWorkData:dt];
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}

- (NSArray *)fetchModelWorkStartTime:(NSDate *)startTime {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"start_time = %@", startTime];    //条件指定
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}


@end