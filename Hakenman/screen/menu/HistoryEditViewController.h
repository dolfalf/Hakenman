//
//  HistoryEditViewController.h
//  Hakenman
//
//  Created by kjcode on 2015/02/18.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "KJViewController.h"

@interface HistoryEditViewController : KJViewController

@property (nonatomic, copy) void(^completionHandler)(id);

@end