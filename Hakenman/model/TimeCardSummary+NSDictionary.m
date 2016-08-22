//
//  TimeCardSummary+NSDictionary.m
//  Hakenman
//
//  Created by lee jaeeun on 2016/08/22.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "TimeCardSummary+NSDictionary.h"

@implementation TimeCardSummary (NSDictionary)

- (NSDictionary *)dictionary {

    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (self.remark) {
        dict[@"remark"] = self.remark;
    }
    if (self.summary_type) {
        dict[@"summary_type"] = self.summary_type;
    }
    if (self.t_yyyymm) {
        dict[@"t_yyyymm"] = self.t_yyyymm;
    }
    if (self.workdays) {
        dict[@"workdays"] = self.workdays;
    }
    if (self.workTime) {
        dict[@"workTime"] = self.workTime;
    }
    
    return dict;
}
@end
