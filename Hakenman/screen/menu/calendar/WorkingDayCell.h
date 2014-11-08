//
//  WorkingDayCell.h
//  Hakenman
//
//  Created by kjcode on 2014/10/25.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "RDVCalendarDayCell.h"

@interface WorkingDayCell : RDVCalendarDayCell

@property (nonatomic, assign, getter=isMemo) BOOL memo;
@property (nonatomic, assign, getter=isworkday) BOOL workday;

- (void)updateWorkStartTime:(NSString *)st endTime:(NSString *)et;
@end
