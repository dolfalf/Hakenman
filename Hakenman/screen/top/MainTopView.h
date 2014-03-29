//
//  MainTopView.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    tableCellTypeCurrentStatus = 0,
    tableCellTypeTodoList,
    tableCellTypeGraphView,
    tableCellTypeWeekStatus,
    tableCellTypeMaxCount
    
} tableCellType;

@interface MainTopView : UIView

+ (id)createView;

- (id)initTableCellView:(tableCellType)cellType;
@end
