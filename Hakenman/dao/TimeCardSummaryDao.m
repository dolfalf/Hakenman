//
//  TimeCardSummaryDao.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TimeCardSummaryDao.h"

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

@end
