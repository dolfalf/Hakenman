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
@end
