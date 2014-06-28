//
//  TimeCardSummary.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeCardSummary : NSManagedObject

@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * summary_type;
@property (nonatomic, retain) NSNumber * t_yyyymm;
@property (nonatomic, retain) NSNumber * workdays;
@property (nonatomic, retain) NSNumber * workTime;

@end
