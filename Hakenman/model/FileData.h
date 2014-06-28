//
//  FileData.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FileData : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * file_path;
@property (nonatomic, retain) NSString * yyyymmdd;

@end
