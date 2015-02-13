//
//  AppDelegate.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisingManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate, GADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
