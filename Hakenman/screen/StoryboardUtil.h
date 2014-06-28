//
//  StoryboardUtil.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardUtil : NSObject

+ (void)gotoMonthWorkingTableViewController:(id)owner completion:(void(^)(id))completion;
+ (void)gotoMonthWorkingTableEditViewController:(id)owner completion:(void(^)(id))completion;

@end
