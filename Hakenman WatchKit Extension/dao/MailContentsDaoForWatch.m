//
//  MailContentsDaoForWatch.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MailContentsDaoForWatch.h"

#define ENTITIY_NAME    @"MailContents"

@implementation MailContentsDaoForWatch

- (id)init {
    
    self = [super init];
    
    if (self != nil) {
        //init code
        self.entityName = ENTITIY_NAME;
    }
    
    return self;
}

@end
