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

- (NSArray *)fetchModelWorkingDay:(NSNumber *)workingDay;
- (NSArray *)fetchModelWorkStartTime:(NSDate *)startTime;

@end
