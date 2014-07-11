//
//  NSError+Common.h
//  Hakenman
//
//  Created by kjcode on 2014/07/11.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HKMErrorDomain @"com.kjcode.HKMError"

typedef enum {
    HKMErrorCodeNone = 0,               ///< エラーなし
    HKMErrorCodeNoDataError = 1000,    ///< データがない
} HKMErrorCode;

@interface NSError (Common)

+ (NSError*)errorWithHKMErrorCode:(HKMErrorCode)code localizedDescription:(NSString* )localizedDescription;
+ (NSError*)errorWithHKMErrorCode:(HKMErrorCode)code;

@end
