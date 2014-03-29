//
//  MainViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TopViewController.h"
#import "MainTopView.h"

#import "TimeCardDao.h"

#import "SettingViewController.h"
#import "MenuViewController.h"

typedef enum {
    screenTypeShukin = 0,
    screenTypeTaikin,
    
}screenType;

const int kPageSize = 2;




@interface TopViewController () {
    
    IBOutlet UIScrollView *scView;
    IBOutlet UIPageControl *pgControl;
    
    MainTopView *_shukinTopView;
    MainTopView *_taikinTopView;
    
}

@property (nonatomic, assign) screenType screen;

- (IBAction)gotoMenuButtonTouched:(id)sender;
- (IBAction)gotoSettingButtonTouched:(id)sender;

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    TimeCardDao *timeCardDao = [[TimeCardDao alloc] init];
#if 0
    for (int i=0; i < 10; i++) {
        
        TimeCard *model = [timeCardDao createModel];
        
        model.work_start_time = [NSDate date];
        model.work_end_time = [NSDate date];
        model.working_day = @(i);
        model.bikou = @"あいうえお";
        
        [timeCardDao insertModel];
    }
#endif
    
    DLog(@"%@",[timeCardDao fetchModelWorkingDay:@(3)]);
//    DLog(@"%@",[timeCardDao fetchModel]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // スクロールの範囲を設定
    [scView setContentSize:CGSizeMake((_shukinTopView.frame.size.width + _taikinTopView.frame.size.width),
                                      [UIScreen mainScreen].bounds.size.height)];
    
    //page control
    pgControl.frame = CGRectMake(pgControl.frame.origin.x ,
                                 pgControl.frame.origin.y,
                                 pgControl.frame.size.width,
                                 20);
    
    [self.view layoutSubviews]; // <- これが重要！
}

//オーバーライドしてスタイル指定
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

//オーバーライドして非表示かどうかを選択
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - setter
- (void)setScreen:(screenType)screen {

    if (screen == screenTypeShukin) {
        self.title = LOCALIZE(@"TopViewController_goWork_title");
    }else if (screen == screenTypeTaikin) {
        self.title = LOCALIZE(@"TopViewController_leaveWork_title");
    }
    
    _screen = screen;
}

#pragma mark - override method
- (void)initControl {
    
    //Navigationbar, statusbar initialize
    if([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]){ //iOS7
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //viewControllerで制御することを伝える。iOS7 からできたメソッド
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    //MainView initialize
    _shukinTopView = [MainTopView createView];
    [scView addSubview:_shukinTopView];

    _taikinTopView = [MainTopView createView];
    _taikinTopView.frame = CGRectSetX(_taikinTopView.frame, _shukinTopView.frame.size.width);
    
    [scView addSubview:_taikinTopView];
    
    
    //scrollView & pageControl initialize
    
    // 横スクロールのインジケータを非表示にする
    scView.showsHorizontalScrollIndicator = NO;
    
    // ページングを有効にする
    scView.pagingEnabled = YES;
    
    // ページコントロールのインスタンス化
    // 背景色を設定
    pgControl.backgroundColor = [UIColor clearColor];
    
    // ページ数を設定
    pgControl.numberOfPages = kPageSize;
    
    // 現在のページを設定
    pgControl.currentPage = 0;
    
    // ページコントロールをタップされたときに呼ばれるメソッドを設定
    [pgControl addTarget:self
                    action:@selector(_pageControlTapped:)
          forControlEvents:UIControlEventValueChanged];
 
    self.title = LOCALIZE(@"TopViewController_goWork_title");
}

#pragma mark - IBAction
- (IBAction)gotoMenuButtonTouched:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    
    UINavigationController *instantiateInitialViewController = [storyboard instantiateInitialViewController];
    
    //push Animation

    
    [self presentViewController:instantiateInitialViewController animated:YES completion:^{
        
        ((MenuViewController *)[instantiateInitialViewController.childViewControllers objectAtIndex:0]).completionHandler = ^(id settingController) {
            
            [settingController dismissViewControllerAnimated:YES completion:nil];
        };
        
    }];

}

- (IBAction)gotoSettingButtonTouched:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UINavigationController *instantiateInitialViewController = [storyboard instantiateInitialViewController];
    
    [self presentViewController:instantiateInitialViewController animated:YES completion:^{
        
        ((SettingViewController *)[instantiateInitialViewController.childViewControllers objectAtIndex:0]).completionHandler = ^(id settingController) {
            
            [settingController dismissViewControllerAnimated:YES completion:nil];
        };
    }];
}

#pragma mark - callback method
- (void)_pageControlTapped:(id)sender {
    
    CGRect frame = scView.frame;
    frame.origin.x = frame.size.width * pgControl.currentPage;
    [scView scrollRectToVisible:frame animated:YES];
    
}


#pragma mark - UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    //横方向のみスクロールする
    CGPoint origin = [scView contentOffset];
    [scView setContentOffset:CGPointMake(origin.x, 0.0)];
    
    //page control
    CGFloat pageWidth = scView.frame.size.width;
    if ((NSInteger)fmod(scView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        pgControl.currentPage = scView.contentOffset.x / pageWidth;
    }
    
    self.screen = (int)pgControl.currentPage;
    
}


@end
