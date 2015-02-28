//
//  AdvertisingManager.m
//  Hakenman
//
//  Created by fukuda mami on 2015/02/06.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "AdvertisingManager.h"

@implementation AdvertisingManager
static ADBannerView *iadView;
static GADBannerView *gadView;
+ (ADBannerView*)sharedIADBannerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // create the iAdBannerView
        iadView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        iadView.frame = CGRectZero;
    });
    return iadView;
}

+ (GADBannerView*)sharedGADBannerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // create the GAdBannerView
        // 画面上部に標準サイズのビューを作成する
        // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
        gadView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
        
        // 広告ユニット ID を指定する
        gadView.adUnitID = @"ca-app-pub-4480295199662286/6532666450";
        
        // ユーザーに広告を表示した場所に後で復元する UIViewController をランタイムに知らせて
        // ビュー階層に追加する
        gadView.rootViewController = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [gadView loadRequest:[GADRequest request]];
    });
    return gadView;
}

+ (void)resetBannerViews{
    if (gadView) {
        gadView = nil;
//        [self sharedGADBannerView];
    }
    if (iadView) {
        iadView = nil;
//        [self sharedIADBannerView];
    }
}
@end