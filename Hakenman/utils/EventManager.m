//
//  EventManager.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "EventManager.h"

@interface EventManager() <EKEventEditViewDelegate>

@property (nonatomic, strong) EKEventStore *store;

@end

@implementation EventManager

static EventManager *_sharedInstance;

#pragma mark - singleton
+ (EventManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
    
}

+ (id)allocWithZone:(NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    
    return _sharedInstance;
    
}

- (id)init {
    self = [super init];
    if (self) {
        _store = [[EKEventStore alloc] init];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Event fetch
- (NSArray *)fetchEvent {
    
    //デフォルトは１週間のカレンダーを表示
    
    // 適切なカレンダーを取得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 開始日コンポーネントの作成
    NSDateComponents *oneWeekAgoComponents = [[NSDateComponents alloc] init]; oneWeekAgoComponents.day = -7;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneWeekAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    // 終了日コンポーネントの作成
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init]; oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    return [self fetchEventStartDate:oneDayAgo EndDate:oneYearFromNow];
    
}

- (NSArray *)fetchEventStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate {
    
    // イベントストアのインスタンスメソッドで述語を生成
    NSPredicate *predicate = [_store predicateForEventsWithStartDate:startDate
                                                             endDate:startDate
                                                           calendars:nil];
    // 述語に合致するすべてのイベントをフェッチ
    return [_store eventsMatchingPredicate:predicate];
    
}

#pragma mark - Event editing controller
- (void)eventEditController:(id)owner event:(EKEvent *)event {
    
    //eventがnilの場合は自動で新規になる
    
    //        event.title = @"This is title.";
    //        event.location = @"Tokyo, Japan.";
    //        event.startDate = [NSDate date];
    //        event.endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    //        event.notes = @"This is notes.";
    
    EKEventEditViewController *eventEditViewController = [EKEventEditViewController new];
    eventEditViewController.editViewDelegate = self;
    eventEditViewController.event = event;
    eventEditViewController.eventStore = _store;
    
    [owner presentViewController:eventEditViewController animated:YES completion:nil];
}

#pragma mark - EKEventEditViewDelegate
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
	
	NSError *error = nil;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			break;
			
		case EKEventEditViewActionSaved:
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		case EKEventEditViewActionDeleted:
			[controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		default:
			break;
	}
    
	[controller dismissViewControllerAnimated:YES completion:nil];
}


@end

