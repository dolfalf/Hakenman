//
//  TodayTableViewCell.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/06/07.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, cellMessageType) {
    cellMessageTypeWorkStart,
    cellMessageTypeWorkEnd,
};

@interface TodayTableViewCell : UITableViewCell

- (void)updateCell:(cellMessageType)messageType graphItems:(NSArray *)items;

@end
