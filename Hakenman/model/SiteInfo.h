//
//  SiteInfo.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SiteInfo : NSManagedObject

@property (nonatomic, retain) NSString * site_name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
