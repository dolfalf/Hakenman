//
//  MailContent.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MailContent : NSManagedObject

@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSString * mail_to;
@property (nonatomic, retain) NSString * title;

@end
