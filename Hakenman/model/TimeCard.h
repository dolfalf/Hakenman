//
//  TimeCard.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeCard : NSManagedObject

@property (nonatomic, retain) NSString * bikou;
@property (nonatomic, retain) NSDate * work_end_time;
@property (nonatomic, retain) NSDate * work_start_time;
@property (nonatomic, retain) NSNumber * working_day;

@end
