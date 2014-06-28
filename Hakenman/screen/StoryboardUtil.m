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

@implementation StoryboardUtil

#pragma mark - stroyboard transition
+ (void)gotoMonthWorkingTableViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MonthWorkingTableViewController"];
    
    completion(controller);
    
    [((KJViewController *)owner).navigationController pushViewController:controller animated:YES];
}

@end
