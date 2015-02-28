//
//  AdvertisingManager.m
//  Hakenman
//
//  Created by fukuda mami on 2015/02/06.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "AdvertisingManager.h"
#import "GADBannerView.h"

#define GAD_ADD_UNIT_ID     @"ca-app-pub-4480295199662286/6532666450"

static AdvertisingManager *_shardInstance;

@interface AdvertisingManager() <ADBannerViewDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *iadView;
@property (nonatomic, strong) GADBannerView *gadView;

@end

@implementation AdvertisingManager


+ (AdvertisingManager* )sharedADBannerView {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // create the iAdBannerView
        _shardInstance = [AdvertisingManager new];
        _shardInstance.iadView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        _shardInstance.iadView.delegate = _shardInstance;
        
        // create the GAdBannerView
        // 画面上部に標準サイズのビューを作成する
        // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
        _shardInstance.gadView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
        _shardInstance.gadView.delegate = _shardInstance;
        // 広告ユニット ID を指定する
        _shardInstance.gadView.adUnitID = GAD_ADD_UNIT_ID;
        
        // ユーザーに広告を表示した場所に後で復元する UIViewController をランタイムに知らせて
        // ビュー階層に追加する
        _shardInstance.gadView.rootViewController = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [_shardInstance.gadView loadRequest:[GADRequest request]];
        
    });
    
    return _shardInstance;
}

- (id)getADBannerView:(AdViewType)type {
    
    if (AdViewTypeIAd) {
        return _iadView;
    }else if(AdViewTypeGAd) {
        return _gadView;
    }
    
    return nil;
}


#pragma mark - IAD Delegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    DLog(@"apple iAD will Load");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    DLog(@"apple iAD did Load");
    
    if ([_delegate respondsToSelector:@selector(iAdLoadSuccess)]) {
            [_delegate iAdLoadSuccess];
    }

}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    DLog(@"apple iAD receive Failed - %@", [error localizedDescription]);
    
//    [_delegate iAdLoadFail];
}

#pragma mark - GAD Delegate

/// Called when an ad request loaded an ad. This is a good opportunity to add this view to the
/// hierarchy if it has not been added yet. If the ad was received as a part of the server-side auto
/// refreshing, you can examine the hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    DLog(@"google admob received!");
}

/// Called when an ad request failed. Normally this is because no network connection was available
/// or no ads were available (i.e. no fill). If the error was received as a part of the server-side
/// auto refreshing, you can examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    DLog(@"google admob receive Failed - %@", [error localizedDescription]);
}

@end