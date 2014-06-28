//
//  TimeCard.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeCard : NSManagedObject

@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * remarks;
@property (nonatomic, retain) NSNumber * rest_time;
@property (nonatomic, retain) NSString * start_time;
@property (nonatomic, retain) NSNumber * t_day;
@property (nonatomic, retain) NSNumber * t_month;
@property (nonatomic, retain) NSNumber * t_week;
@property (nonatomic, retain) NSNumber * t_year;
@property (nonatomic, retain) NSNumber * t_yyyymmdd;
@property (nonatomic, retain) NSNumber * workday_flag;

@end
