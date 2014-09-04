//
//  Util.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KJViewController;

@interface Util : NSObject

//language
+ (BOOL)isJanpaneseLanguage;

//document
+ (NSString *)getDocumentPath;

//convert String
+ (NSString *)weekdayString:(int)weekday;
+ (NSString *)weekdayString2:(int)weekday;
+ (NSString *)worktimeString:(NSDate *)dt;
+ (NSString *)weekStatusDayString:(NSDate *)dt;
+ (NSString *)weekStatusTimeString:(NSDate *)dt;
+ (NSString *)eventTimeString:(NSDate *)dt;
+ (float)getWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime;
+ (NSString *)correctWorktime:(NSString *)yyyymmddHHmmss;

+ (NSArray *)worktimePickList;
+ (NSInteger)worktimeKubun:(NSString *)pickString;
+ (NSArray *)displayWorkSheetList;
+ (NSInteger)displayWorkSheetIndex:(NSString *)optionString;
+ (NSArray *)reportTitleList;

//+ (void)sendMailWorkSheet:(id)owner append:(NSArray *)worksheets;
+ (void)sendReportMailWorkSheet:(id)owner subject:(NSString *)subject toRecipient:(NSString *)toRecipient messageBody:(NSString *)body;

+ (void)sendWorkSheetCsvfile:(KJViewController *)owner data:(NSArray *)worksheets;

+ (BOOL)olderThanVersion:(NSString *)ver;
@end
