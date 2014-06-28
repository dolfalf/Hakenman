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

- (void)insertModelWorkSheet:(NSDate *)dt {

    int w_year =[dt getYear];
    int w_month =[dt getMonth];
    
    NSArray *items = [self fetchModelYear:w_year month:w_month];
    
    //既に存在したらそのまま返す
    if (items != nil && [items count] > 0) {
        return;
    }
    
    //存在しなければ作成
    
    for (int day=1; day <= [dt getLastday]; day++) {
        DLog(@"day:[%d]",day);
        int w_week = [[dt getDayOfMonth:day] getWeekday];
        
        TimeCard *model = [self createModel];
        
        //default setting.
        model.t_year = [NSNumber numberWithInt:w_year];
        model.t_month = [NSNumber numberWithInt:w_month];
        model.t_day = [NSNumber numberWithInt:day];
        model.t_week = [NSNumber numberWithInt:w_week];
        model.t_yyyymmdd = @([[NSString stringWithFormat:@"%d%02d%02d",w_year, w_month, day] intValue]);
        model.rest_time = @(1.f);
        if (w_week == weekSatDay || w_week == weekSunday) {
            model.workday_flag = @(NO);
        }else {
            model.workday_flag = @(YES);
        }
        
//        model.remarks;
//        model.end_time;
//        model.start_time;
//        model.time_card_site_info;
    }
    
    [self insertModel];
    
}

- (NSArray *)fetchModelYear:(NSInteger)year month:(NSInteger)month {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymmdd" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_year = %@ AND t_month = %@", @(year), @(month)];
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}

- (NSArray *)fetchModelLastWeek {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    NSTimeInterval week_day = 60*60*24*7;
    NSDate *current_date = [NSDate date];
    NSString *todayString = [current_date yyyyMMddHHmmssString];
    NSString *weekDateString = [((NSDate *)[current_date dateByAddingTimeInterval:-week_day]) yyyyMMddHHmmssString];
    DLog(@"weekDateString[%@] todayString[%@]",weekDateString, todayString);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"start_time >= %@ AND start_time < %@", weekDateString, todayString];    //条件指定
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}


@end