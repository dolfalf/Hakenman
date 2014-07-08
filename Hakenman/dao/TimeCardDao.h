//
//  TimeCardDao.h
//  Hakenman
//
//  Created by lee jaeeun on 12/03/14.
//  Copyright (c) 2012年 kj-code. All rights reserved.
//

#import "ModelDao.h"
#import "TimeCard.h"

@interface TimeCardDao : ModelDao

- (void)insertModelWorkSheet:(NSDate *)dt;

- (NSArray *)fetchModelYear:(NSInteger)year month:(NSInteger)month;
- (NSArray *)fetchModelLastWeek;
- (TimeCard *)fetchModelWorkDate:(NSDate *)dt;
@end
