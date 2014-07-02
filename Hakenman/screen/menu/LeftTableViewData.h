//
//  LeftTableViewData.h
//  Hakenman
//
//  Created by 俊河 李 on 2014/07/02.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftTableViewData : NSObject


//日付、曜日、休み判定確認
@property(nonatomic, strong) NSNumber *yearData;
@property(nonatomic, strong) NSNumber *monthData;
@property(nonatomic, strong) NSNumber *dayData;
@property(nonatomic, strong) NSNumber *weekData;
@property(nonatomic, strong) NSNumber *workFlag;

@end