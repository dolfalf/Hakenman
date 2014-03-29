//
//  TimeCard.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteInfo;

@interface TimeCard : NSManagedObject

@property (nonatomic, retain) NSString * remarks;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * working_day;
@property (nonatomic, retain) NSNumber * t_yyyymmdd;
@property (nonatomic, retain) NSNumber * t_year;
@property (nonatomic, retain) NSNumber * t_month;
@property (nonatomic, retain) NSNumber * t_day;
@property (nonatomic, retain) NSNumber * t_week;
@property (nonatomic, retain) SiteInfo *time_card_site_info;

@end
