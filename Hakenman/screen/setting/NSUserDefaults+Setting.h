//
//  NSUserDefaults+Setting.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/23.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Setting)

+ (BOOL)readWelcomePage;
+ (void)setReadWelcomePage:(BOOL)value;

+ (NSInteger)timeKubun;
+ (void)setTimeKubun:(NSInteger)value;

+ (NSString *)workStartTime;
+ (NSString *)workStartTimeForWatch;
+ (void)setWorkStartTime:(NSString *)value;

+ (NSString *)workEndTime;
+ (NSString *)workEndTimeForWatch;
+ (void)setWorkEndTime:(NSString *)value;

+ (NSInteger)displayWorkSheet;
+ (void)setDisplayWorkSheet:(NSInteger)value;

+ (NSInteger)displayModeWorkSheet;
+ (void)setDisplayModeWorkSheet:(NSInteger)value;

+ (NSString *)workSitename;
+ (void)setWorkSitename:(NSString *)value;

+ (NSString *)reportToMailaddress;
+ (void)setReportToMailaddress:(NSString *)value;

+ (NSString *)reportMailTitle;
+ (void)setReportMailTitle:(NSString *)value;

+ (BOOL)reportMailTempleteTimeAdd;
+ (void)setReportMailTempleteTimeAdd:(BOOL)value;

+ (NSString *)reportMailContent;
+ (void)setReportMailContent:(NSString *)value;


//AppleWatch Migration flag
+ (BOOL)isWatchMigration;
+ (void)watchMigrationFinished;

+ (void)watchStoreURLFinished;
+ (BOOL)isFinishedStoreURL;

@end
