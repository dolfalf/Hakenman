//
//  StoryboardUtil.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "StoryboardUtil.h"
#import "KJViewController.h"
#import "MonthWorkingTableViewController.h"
#import "MonthWorkingTableEditViewController.h"
#import "MonthWorkingCalendarViewController.h"

@implementation StoryboardUtil

#pragma mark - stroyboard transition
+ (void)gotoMonthWorkingTableViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingTableViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoMonthWorkingCalendarViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingCalendarViewController *controller = (MonthWorkingCalendarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingCalendarViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoMonthWorkingTableEditViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingTableEditViewController *controller = (MonthWorkingTableEditViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingTableEditViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoTutorialViewController:(id)owner animated:(BOOL)animated {
    
    //MARK:pushはできない。popをする際にメモリエラー発生のため
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    UIViewController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    
    [owner presentViewController:controller animated:animated completion:nil];

}

+ (void)gotoAppInformationViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AppInfo" bundle:nil];
    KJViewController *controller = (KJViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AppInformationViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoOpenLicenseViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AppInfo" bundle:nil];
    KJViewController *controller = (KJViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OpenSourceLicenseViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

@end
