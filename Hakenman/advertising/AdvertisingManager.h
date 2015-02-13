//
//  AdvertisingManager.h
//  Hakenman
//
//  Created by fukuda mami on 2015/02/06.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface AdvertisingManager : NSObject <ADBannerViewDelegate, GADBannerViewDelegate>

+ (ADBannerView*)sharedIADBannerView;
+ (GADBannerView*)sharedGADBannerView;
+ (void)resetBannerViews;

@end
