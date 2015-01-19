//
//  TimeCardSummaryDao.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "ModelDao.h"
#import "TimeCardSummary.h"

@interface TimeCardSummaryDao : ModelDao

- (NSArray *)fetchModelStartMonth:(NSString *)sm EndMonth:(NSString *)em ascending:(BOOL)b;

//MARK: TimeCardが変更されたらこのメソッドを呼んでください。
- (void)updatedTimeCardSummaryTable:(NSString *)yyyymm;
//MARK: TimeCardSummaryテーブルを更新
- (void)updateTimeCardSummaryTableAll;

#ifdef RECOVERY_CODE_ENABLE
//MARK:リカバリーのため臨時的に使うメソッド
- (void)recoveryTimeCardSummaryTable;
#endif

@end
