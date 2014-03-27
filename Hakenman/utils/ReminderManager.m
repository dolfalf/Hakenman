//
//  ReminderManager.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/25.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//
//

/**
 * 参考サイト
 * http://qiita.com/takayama/items/0fbf8d367844a6f2c944
 */
#import "ReminderManager.h"
#import <EventKit/EventKit.h>

@implementation ReminderManager


+ (id)sharedManager {

    static ReminderManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ReminderManager alloc] init];
        
        //Reminderへアクセス
        [sharedInstance initEventStore];
    });
    return sharedInstance;
}

- (void)initEventStore {
    
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized) {
        // リマインダーにアクセスできる場合
    } else {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                   completion:^(BOOL granted, NSError *error) {
                                       if(granted) {
                                           // はじめてリマインダーにアクセスする場合にアラートが表示されて、OKした場合にここにくるよ
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               // アクセス権がありません。
                                               // "プライバシー設定"でアクセスを有効にできます。
                                               UIAlertView *alert = [[UIAlertView alloc]
                                                                     initWithTitle:NSLocalizedString(@"This app does not have access to you reminders.", nil)
                                                                     message:NSLocalizedString(@"To display your reminder, enable [YOUR APP] in the \"Privacy\" → \"Reminders\" in the Settings.app.", nil)
                                                                     delegate:nil
                                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                     otherButtonTitles:nil];
                                               [alert show];
                                           });
                                       }
                                   }
         ];
    }
    
}


- (void)bbb {

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
    reminder.title = @"サンプルリマインダー";
    reminder.calendar = [eventStore defaultCalendarForNewReminders];
    
    // 期限が必要な場合
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:2013];
    [dateComponents setMonth:12];
    [dateComponents setDay:18];
    [dateComponents setHour:20];
    reminder.dueDateComponents = dateComponents;
    
    // 通知を追加
    [reminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]]];
    
    NSError *error;
    if(![eventStore saveReminder:reminder commit:YES error:&error]) NSLog(@"%@", error);

    
}

@end
