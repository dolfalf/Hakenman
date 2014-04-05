//
//  LineGraphView.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineGraphViewDelegate;

@interface LineGraphView : UIView

@property (nonatomic, assign) id <LineGraphViewDelegate>delegate;

@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) NSString *minLabel;

@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign) NSString *maxLabel;


- (void)reloadLineGraphView;

@end

@protocol LineGraphViewDelegate <NSObject>

@required
- (NSInteger)linePointNumber;
- (void)lineGraphView:(LineGraphView *)gview pointValue:(float)value;

@optional

@end
