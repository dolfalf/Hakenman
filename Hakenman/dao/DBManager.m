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

NSString * const kMigrationVersion = @"1.3.0";
NSString * const kGroupIdentifier = @"group.com.kjcode.dolfalf.hakenman";

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
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
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
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    //마이그레이션이 끝나면 로드하는 디비를 바꿔줘야함.
    if ([NSUserDefaults isWatchMigration] == YES) {
        return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupIdentifier];
    }
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Migrating the Store File
- (void)migrateStore {
    
    // migrate current store from one URL to another
    // write out the current store URL before the migration
    NSURL *storeURL = [self.persistentStoreCoordinator.persistentStores.lastObject URL];
    NSLog(@"Current Store URL (before migration): %@", [storeURL description]);
    
    // grab the current store
    NSPersistentStore *currentStore = self.persistentStoreCoordinator.persistentStores.lastObject;
    
    
    // create a new URL
    NSURL *newStoreURL = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupIdentifier]
                          URLByAppendingPathComponent:@"hakenModel.sqlite"];
    
    // setup new options dictionary if necessary
    
    // migrate current store to new URL
    [self.persistentStoreCoordinator migratePersistentStore:currentStore toURL:newStoreURL options:nil withType:NSSQLiteStoreType error:nil];
    
    // and to check we're on the new store, write out tha URL again
    storeURL = [self.persistentStoreCoordinator.persistentStores.lastObject URL];
    NSLog(@"Current Store URL (after migration): %@", [storeURL description]);

}

@end
