//
//  NSError+Common.m
//  Hakenman
//
//  Created by kjcode on 2014/07/11.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "NSError+Common.h"

static NSString* _HKM_CODEDESCRIPTION[] = {
    @"",
    @"HKMError.noExistCsvData"
};

@implementation NSError (Common)

+ (NSError*)errorWithHKMErrorCode:(HKMErrorCode)code localizedDescription:(NSString*)localizedDescription {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [[self class] errorWithDomain:HKMErrorDomain code:code userInfo:userInfo];
    return error;
}

+ (NSError*)errorWithHKMErrorCode:(HKMErrorCode)code {
    
    NSString *description = _HKM_CODEDESCRIPTION[code];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [[self class] errorWithDomain:HKMErrorDomain code:code userInfo:userInfo];
    return error;
}

@end
