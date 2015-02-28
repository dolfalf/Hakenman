//
//  HistoryEditViewController.h
//  Hakenman
//
//  Created by kjcode on 2015/02/18.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

typedef NS_ENUM(NSInteger, HistoryEditType) {
    HistoryEditTypeAdd,
    HistoryEditTypeRemove,
};

#import "KJViewController.h"

@interface HistoryEditViewController : KJViewController

@property (nonatomic, assign) HistoryEditType editType;

@property (nonatomic, copy) void(^completionHandler)(id);

@end