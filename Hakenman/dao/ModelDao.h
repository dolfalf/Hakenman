//
//  ModelDao.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface ModelDao : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong)  NSManagedObject *model;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

- (id)createModel;
- (id)createWithDictionary:(NSDictionary *)item;

- (void)insertModel;
- (void)updateModel:(id)model;
- (void)deleteModel;
- (NSArray *)fetchModel;

- (void)deleteAllModel;
@end
