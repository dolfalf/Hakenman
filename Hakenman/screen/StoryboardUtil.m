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

@implementation StoryboardUtil

#pragma mark - stroyboard transition
+ (void)gotoMonthWorkingTableViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingTableViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoMonthWorkingTableEditViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingTableEditViewController *controller = (MonthWorkingTableEditViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingTableEditViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

+ (void)gotoTutorialViewController:(id)owner pushController:(BOOL)on {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    UINavigationController *naviController = (UINavigationController *)[storyboard instantiateInitialViewController];
    
    UIViewController *controller = [naviController.childViewControllers objectAtIndex:0];
    if (on == YES) {
        [((UIViewController *)owner).navigationController pushViewController:controller animated:YES];
    }else {
        //modal
        [owner presentViewController:naviController animated:YES completion:nil];
    }

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
