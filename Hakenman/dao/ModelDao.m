//
//  ModelDao.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "ModelDao.h"

@interface ModelDao()

@end

@implementation ModelDao

- (id)init {
    
    self = [super init];
    
    if (self) {
        DBManager *mgr = [DBManager sharedDBManager];
        _managedObjectContext = mgr.managedObjectContext;
        _managedObjectModel = mgr.managedObjectModel;
    }
    
    return self;
}

- (id)createModel {
    
    if (_entityName == nil) {
        return nil;
    }
    
    self.model = [NSEntityDescription insertNewObjectForEntityForName:_entityName inManagedObjectContext:_managedObjectContext];
    
    return _model;
}

- (id)createWithDictionary:(NSDictionary *)item {
    
    [self createModel];
    
    for (id key in [item allKeys]) {
        [_model setValue:[item objectForKey:key] forKey:key];
    }
    
    return _model;
}

- (void)insertModel {
    
    if (_model == nil) {
        return;
    }
    
    // Save the context.
    NSError *error = nil;
    if (![_model.managedObjectContext save:&error]) {
        //error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
}

- (void)deleteModel {
    
    if (_model == nil) {
        return;
    }
    
    [_managedObjectContext deleteObject:_model];
    [_managedObjectContext processPendingChanges];
    
    NSError *error = nil;
    if (![_model.managedObjectContext save:&error]) {
        //error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

- (NSArray *)fetchModel {
    
    if (_entityName == nil) {
        return nil;
    }
    
    //条件付きでデータ取得
    self.fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_managedObjectContext];
    [_fetchRequest setEntity:entity];
    
    return [_managedObjectContext executeFetchRequest:_fetchRequest error:nil];
    
}

@end
