//
//  KJViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "KJViewController.h"
#import "UIColor+Helper.h"

@interface KJViewController ()

@end

@implementation KJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initControls];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // ApplicationViewController を継承する全ViewController は Google Analytics の計測対象とする
    // スクリーン名はこちらで一元管理する
    // デフォルトで ViewController名をスクリーン名にセットしている
    NSDictionary *controllerScreenNameMappings = [self getControllerScreenNameMappings];
    NSString *className = NSStringFromClass(self.class);
    NSString *screenName = controllerScreenNameMappings[className];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:(screenName ? screenName : className)];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

/**
 * @brief overrideしてください。
 * ViewDidLoadの時に呼ばれます。
 */
- (void)initControls {
    
    //Navigationbar, statusbar initialize
    if([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]){ //iOS7
        self.navigationController.navigationBar.barTintColor = [UIColor HKMBlueColor];
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
    
}

#pragma mark - google Analytics methods
- (NSDictionary *)getControllerScreenNameMappings {
//    NSDictionary *mappings = @{
//                               NSStringFromClass([MPTopViewController class]): @"トップ",
//                               NSStringFromClass([MPSettingsViewController class]): @"設定",
//                               };
    //MARK: 画面名はとりあえずコントローラー名にする
    NSDictionary *mappings = @{NSStringFromClass([self class]):NSStringFromClass([self class])};
    
    return mappings;
}


- (void)doAction
{
    //MARK: 未使用メソッド。将来のため
    // イベントを計測
    //
    // 以下は各パラメタのメモ:
    // - Category: 分類しやすいように適宜指定（例: リソース名として"コメント"・"メッセージ" など）
    // - Action: ユーザが起こした行動（例: CRUDとして"作成"・"読込"など）
    // - Label: アクションの起こされた対象やパラメタなどの付加情報やサブカテゴリ等に使うとよさそう。必要なければ nil を指定
    // - Value: 管理画面から合計と平均を見られるので、そのような分析をしたい数値。たとえば課金額。必要なければ nil を指定
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"課金" action:@"広告非表示" label:@"クーポンコード使用" value:@100] build]];
}

@end
