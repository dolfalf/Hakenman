//
//  FileData.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FileData : NSManagedObject

@property (nonatomic, retain) NSString * file_path;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSNumber * yyyymmdd;

@end
