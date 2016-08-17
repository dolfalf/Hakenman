//
//  TimeCardSummaryDaoForWatch.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "ModelDaoForWatch.h"
#import "TimeCardSummary.h"

@interface TimeCardSummaryDaoForWatch : ModelDaoForWatch

- (NSArray *)fetchModelStartMonth:(NSString *)sm EndMonth:(NSString *)em ascending:(BOOL)b;

- (NSArray *)fetchModelMonth:(NSString *)yyyymm;

//MARK: TimeCardが変更されたらこのメソッドを呼んでください。
- (void)updatedTimeCardSummaryTable:(NSString *)yyyymm;
//MARK: TimeCardSummaryテーブルを更新
- (void)updateTimeCardSummaryTableAll;
//MARK: 特定のTimeCardSummaryを削除
- (void)removeTimeCardSummaryTable:(NSString *)yyyymm;

+ (float)getWorkTime:(NSDate *)st endTime:(NSDate *)et;

#ifdef RECOVERY_CODE_ENABLE
//MARK:リカバリーのため臨時的に使うメソッド
- (void)recoveryTimeCardSummaryTable;
#endif

@end
