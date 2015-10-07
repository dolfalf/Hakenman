//
//  DBManager.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "DBManager.h"
#import <UIKit/UIKit.h>
#import "NSUserDefaults+Setting.h"
//#import "Util.h"

@implementation DBManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedDBManager
{
    static dispatch_once_t once;
    static id sharedDBManager;
    dispatch_once(&once, ^{
        sharedDBManager = [[self alloc] init];
    });
    return sharedDBManager;
}

#pragma mark - saveContext
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"hakenModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"hakenModel.sqlite"];
    NSError *error = nil;
    NSDictionary *storeOptions = @{ NSSQLitePragmasOption : @{ @"journal_mode" : @"WAL" } };
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }else {

#if 1
        //한번 실행되면 다시 실행안되게 처리할 필요가 있음.
        //iOS8.2이상 체크.
        if ([NSUserDefaults isWatchMigration] == NO
            && [self isEqualAndOlderVersion:@"1.3.0"] == YES) {

            //migration처리
            NSPersistentStore   *sourceStore        = nil;
            NSPersistentStore   *destinationStore   = nil;
            
            NSURL *storeURL = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.kjcode.dolfalf.hakenman"]
                               URLByAppendingPathComponent:@"hakenModel.sqlite"];
            
            //migration
            NSURL *oldStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"hakenModel.sqlite"];
            
            sourceStore = [_persistentStoreCoordinator persistentStoreForURL:oldStoreURL];
            if (sourceStore != nil){
                // Perform the migration
                destinationStore = [_persistentStoreCoordinator migratePersistentStore:sourceStore toURL:storeURL options:storeOptions withType:NSSQLiteStoreType error:&error];
                if (destinationStore == nil){
                    // Handle the migration error
                } else {
                    // You can now remove the old data at oldStoreURL
                    // Note that you should do this using the NSFileCoordinator/NSFilePresenter APIs, and you should remove the other files
                    // described in QA1809 as well.
                    NSError *error = nil;
                    
                    //remove
//                    [[NSFileManager defaultManager] removeItemAtURL:oldStoreURL error:&error];
                    if (error) {
                        NSLog(@"older coredata remove error.   %@, %@", error, [error userInfo]);
                        abort();
                    }
                    
                    //migration success. set flag.
                    [NSUserDefaults watchMigrationFinished];
                }
            }
        }
#endif
        
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
#if 1
    //마이그레이션이 끝나면 로드하는 디비를 바꿔줘야함.
    if ([NSUserDefaults isWatchMigration] == YES
        && [self isEqualAndOlderVersion:@"1.3.0"] == YES) {
        
        return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.kjcode.dolfalf.hakenman"];
    }
#endif
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

- (BOOL)isEqualAndOlderVersion:(NSString *)ver {
    
    //version1.0.2->102にして比較
    NSArray *v_arrays = [ver componentsSeparatedByString:@"."];
    if ([v_arrays count] == 3) {
        int num_ver = [v_arrays[0] intValue] * 100
        + [v_arrays[1] intValue] * 10
        + [v_arrays[2] intValue] * 1;
        
        NSArray *c_arrays = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]componentsSeparatedByString:@"."];
        
        int curr_num_ver = [c_arrays[0] intValue] * 100
        + [c_arrays[1] intValue] * 10
        + [c_arrays[2] intValue] * 1;
        
        NSLog(@"check version:[%d], current version[%d]", num_ver, curr_num_ver);
        if (num_ver <= curr_num_ver) {
            return YES;
        }
    }
    
    return NO;
}

@end
