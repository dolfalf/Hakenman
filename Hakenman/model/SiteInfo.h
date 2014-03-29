//
//  SiteInfo.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TimeCard;

@interface SiteInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * site_name;
@property (nonatomic, retain) NSString * start_work;
@property (nonatomic, retain) NSString * end_work;
@property (nonatomic, retain) NSSet *site_info_time_card;
@end

@interface SiteInfo (CoreDataGeneratedAccessors)

- (void)addSite_info_time_cardObject:(TimeCard *)value;
- (void)removeSite_info_time_cardObject:(TimeCard *)value;
- (void)addSite_info_time_card:(NSSet *)values;
- (void)removeSite_info_time_card:(NSSet *)values;

@end
