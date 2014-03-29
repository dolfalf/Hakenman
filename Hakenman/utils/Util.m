//
//  Util.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "Util.h"

@implementation Util

- (NSString *)getDocumentPath {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories lastObject];
    DLog(@"%@", documentDirectory);
    
    return documentDirectory;
}

@end
