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
#import "NSUserDefaults+Setting.h"

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

- (TimeCard *)timeCardWithDate:(NSDate *)dt {
    
    int w_year =[dt getYear];
    int w_month =[dt getMonth];
    int w_day = [dt getDay];
    int w_week = [dt getWeekday];
    
    NSArray *items = [self fetchModelYear:w_year month:w_month day:w_day];
    
    //既に存在したら更新
    if (items != nil && [items count] > 0) {
        return (TimeCard*)[items objectAtIndex:0];
    }
    
    //存在しなければ作成
    TimeCard *model = [self createModel];
    
    //default setting.
    model.t_year = [NSNumber numberWithInt:w_year];
    model.t_month = [NSNumber numberWithInt:w_month];
    model.t_day = [NSNumber numberWithInt:w_day];
    model.t_week = [NSNumber numberWithInt:w_week];
    model.t_yyyymmdd = @([[NSString stringWithFormat:@"%d%02d%02d",w_year, w_month, w_day] intValue]);
    model.rest_time = @(1.f);
    if (w_week == weekSatDay || w_week == weekSunday) {
        model.workday_flag = @(NO);
    }else {
        model.workday_flag = @(YES);
    }
    
    return model;

}

- (void)insertModelWorkStart:(NSDate *)dt {

    self.model = [self timeCardWithDate:dt];
    
    ((TimeCard *)self.model).start_time = [dt yyyyMMddHHmmssString];
    ((TimeCard *)self.model).rest_time = @(0);
    ((TimeCard *)self.model).end_time = nil;
    ((TimeCard *)self.model).workday_flag = @(YES);
    [self insertModel];
    
}

- (void)insertModelWorkEnd:(NSDate *)dt {
    
    self.model = [self timeCardWithDate:dt];
    
    ((TimeCard *)self.model).end_time = [dt yyyyMMddHHmmssString];
    ((TimeCard *)self.model).workday_flag = @(YES);
    
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

- (NSArray *)fetchModelForCSVWithYear:(NSInteger)year month:(NSInteger)month {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymmdd" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_year = %@ AND t_month = %@ AND workday_flag = %@", @(year), @(month), [NSNumber numberWithBool:YES]];
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];

}

- (NSArray *)fetchModelYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymmdd" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_year = %@ AND t_month = %@ AND t_day = %@", @(year), @(month), @(day)];
    [self.fetchRequest setPredicate:pred];
    
    return [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
}

- (NSArray *)fetchModelGraphDate:(NSDate *)dt {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"t_yyyymmdd" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"t_year == %@ AND t_month == %@ AND workday_flag == %@"
                         , @([dt getYear]), @([dt getMonth]),@(YES)];    //条件指定
    [self.fetchRequest setPredicate:pred];
    
    NSArray *mArray = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
    NSMutableArray *tmpArrays = [NSMutableArray new];
    
    for (TimeCard *tm in mArray) {
        
        if (tm.start_time == nil || [tm.start_time isEqualToString:@""] == YES
            || tm.end_time == nil || [tm.end_time isEqualToString:@""] == YES) {
            continue;
        }
        
        [tmpArrays addObject:tm];
        
    }
    
    
    int start_idx = 0;
    
    if ([mArray count] > 8) {
        start_idx = [mArray count]-8;
    }
    
    NSMutableArray *retArrays = [NSMutableArray new];
    
    for (int i=start_idx;i<[tmpArrays count];i++) {
        TimeCard *tm = (TimeCard *)[tmpArrays objectAtIndex:i];
        
        [retArrays addObject:tm];
    }
    
    return retArrays;
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

- (TimeCard *)fetchModelWorkDate:(NSDate *)dt {
    
    self.fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    [self.fetchRequest setEntity:entity];
    
    NSString *dayString = [dt yyyyMMddHHmmssString];
    DLog(@"dayString[%@]",dayString);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"t_yyyymmdd == %@", dayString];    //条件指定
    [self.fetchRequest setPredicate:pred];
    
    NSArray *models = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:nil];
    
    if (models == nil || [models count] == 0) {
        return nil;
    }
    return [models objectAtIndex:0];
    
}

- (void)clearTimeCardWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    NSArray *tempArr = [self fetchModelYear:year month:month day:day];
    TimeCard *tm;
    if (tempArr != nil && [tempArr count] > 0) {
        tm = (TimeCard*)[tempArr objectAtIndex:0];
    }
    if (tm == nil) {
        return;
    }
    //時間を初期化
    tm.start_time = nil;
    tm.end_time = nil;
    tm.rest_time = nil;
    tm.remarks = @"";
    tm.workday_flag = nil;

    [self updateModel:tm];

}

@end