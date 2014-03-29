//
//  MailContents.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MailContents : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * contents;

@end
