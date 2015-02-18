//
//  RightTableViewData.h
//  Hakenman
//
//  Created by Lee Junha on 2014/07/02.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightTableViewData : NSObject

//    startTimeLabel.text = [Util worktimeString:model.start_time];
//    endTimeLabel.text = [Util worktimeString:model.end_time];
//    workTimeLabel.text = [NSString stringWithFormat:@"%2.2f",[Util getWorkTime:model.start_time endTime:model.end_time]];
//    worktotalLabel.text = [NSString stringWithFormat:@"%2.2f",tt];

@property (nonatomic, strong) NSString * end_time;
@property (nonatomic, strong) NSNumber * rest_time;
@property (nonatomic, strong) NSString * start_time;
@property (nonatomic, strong) NSNumber * workday_flag;
@property (nonatomic, assign) float total_time;     //累計時間
@property (nonatomic, strong) NSString *remark;

@end
