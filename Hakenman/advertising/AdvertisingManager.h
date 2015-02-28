//
//  AdvertisingManager.h
//  Hakenman
//
//  Created by fukuda mami on 2015/02/06.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import <iAd/iAd.h>

typedef NS_ENUM(NSInteger, AdViewType) {
    AdViewTypeIAd,
    AdViewTypeGAd,
};

@protocol AdvertisingManagerDelegate;

@interface AdvertisingManager : NSObject 

@property (nonatomic, assign) id<AdvertisingManagerDelegate> delegate;

+ (AdvertisingManager* )sharedADBannerView;

- (id)getADBannerView:(AdViewType)type;

@end


@protocol AdvertisingManagerDelegate <NSObject>

@optional
- (void)iAdLoadSuccess;
//- (void)iAdLoadFail;
@end
