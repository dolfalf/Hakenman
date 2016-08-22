//
//  TimeCard+NSDictionary.m
//  Hakenman
//
//  Created by lee jaeeun on 2016/08/22.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "TimeCard+NSDictionary.h"

@implementation TimeCard (NSDictionary)

- (NSDictionary *)dictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.end_time) {
        dict[@"end_time"] = self.end_time;
    }
    if (self.remarks) {
        dict[@"remarks"] = self.remarks;
    }
    if (self.rest_time) {
        dict[@"rest_time"] = self.rest_time;
    }
    if (self.start_time) {
        dict[@"start_time"] = self.start_time;
    }
    if (self.t_day) {
        dict[@"t_day"] = self.t_day;
    }
    if (self.t_month) {
        dict[@"t_month"] = self.t_month;
    }
    if (self.t_week) {
        dict[@"t_week"] = self.t_week;
    }
    if (self.t_year) {
        dict[@"t_year"] = self.t_year;
    }
    if (self.t_yyyymmdd) {
        dict[@"t_yyyymmdd"] = self.t_yyyymmdd;
    }
    if (self.workday_flag) {
        dict[@"workday_flag"] = self.workday_flag;
    }
    
    return dict;
}

@end
