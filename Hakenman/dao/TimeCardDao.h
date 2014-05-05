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

- (NSArray *)fetchModelWorkMonth:(NSDate *)dt;

- (NSArray *)fetchModelWorkStartTime:(NSDate *)startTime;

@end
