//
//  MainViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TopViewController.h"

#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"

#import "SettingViewController.h"
#import "MenuViewController.h"

#import "TodayTableViewCell.h"
#import "MonthTableViewCell.h"

#import "NSDate+Helper.h"

#import "MonthWorkingTableViewController.h"

NS_ENUM(NSInteger, tableCellType) {
    tableCellTypeToday = 0,
    tableCellTypeMonth,
};

static NSString * const kTodayCellIdentifier = @"todayCellIdentifier";
static NSString * const kMonthCellIdentifier = @"monthCellIdentifier";

@interface TopViewController () {
    
    IBOutlet UITableView *mainTableView;
    
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) TodayTableViewCell *todayCell;

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
    
    //MARK: テストデータの生成
#if 1
    TimeCardDao *timeCardDao = [[TimeCardDao alloc] init];

    [timeCardDao deleteAllModel];
    for (int j=3; j < 9; j++) {
        for (int i=1; i < 30; i++) {
            TimeCard *model = [timeCardDao createModel];
            
            model.start_time = [NSString stringWithFormat:@"20140%d%02d090000",j,i];
            model.end_time = [NSString stringWithFormat:@"20140%d%02d1%d0000",j,i, rand()%9];
            model.t_yyyymmdd = @([[model.start_time substringWithRange:NSMakeRange(0, 8)] intValue]);
            model.workday_flag = @(1);
            model.remarks = @"あいうえお";
            
            DLog(@"start_time:[%@], end_time:[%@]", model.start_time, model.end_time);
            [timeCardDao insertModel];
        }
    }
    
    TimeCardSummaryDao *timeCardSummaryDao = [[TimeCardSummaryDao alloc] init];
    
    [timeCardSummaryDao deleteAllModel];
    
    for (int j=3; j < 9; j++) {
        TimeCardSummary *model = [timeCardSummaryDao createModel];
        model.t_yyyymm = @([[NSString stringWithFormat:@"20140%d",j] intValue]);
        
        model.workTime = @160;
        model.summary_type = @1;
        model.workdays = @21;
        model.remark = @"test data.";
        
        DLog(@"t_yyyymm:[%d]", [model.t_yyyymm intValue]);
        
        [timeCardSummaryDao insertModel];
    }
    
#endif
    
    
    //初期化
    self.items = [self displayCellItems];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
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

#pragma mark - override method
- (void)initControls {
    
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
    
//    self.title = LOCALIZE(@"TopViewController_goWork_title");
    
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

#pragma mark - private methods
- (NSArray *)displayCellItems {
    
    NSMutableArray *arrays = [NSMutableArray new];
    
    //一番目は固定
    [arrays addObject:@"first cell"];
    
    //サマリーからデータを持ってくる
    TimeCardSummaryDao *summaryDao = [[TimeCardSummaryDao alloc] init];
    
    NSDate *today = [NSDate date];
    NSDate *oneYearsAgo = (NSDate *)[today dateByAddingTimeInterval:(60*60*24*365 *-1)];
    
    DLog(@"oneYearsAgo[%@] today[%@]",oneYearsAgo, today);
    
    [arrays addObjectsFromArray:
     [summaryDao fetchModelStartMonth:[oneYearsAgo yyyyMMString] EndMonth:[today yyyyMMString] ascending:NO]];
    
    return arrays;
    
}
#pragma mark - tableView private method
- (TodayTableViewCell *)tableView:(UITableView *)tableView todayCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_todayCell == nil) {
        self.todayCell = (TodayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTodayCellIdentifier];
    }

    return _todayCell;
}

- (MonthTableViewCell *)tableView:(UITableView *)tableView monthCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMonthCellIdentifier];
    
    if (cell == nil) {
        cell = [[MonthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == tableCellTypeToday) {
        return 140.0f;
    }else {
        return 80.0f;
    }
    
    return 44.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == tableCellTypeToday) {
        TodayTableViewCell *cell = [self tableView:tableView todayCellForRowAtIndexPath:indexPath];
        
        TimeCardDao *dao = [TimeCardDao new];
        NSArray *weekTimeCards = [dao fetchModelLastWeek];
        [cell updateCell:cellMessageTypeWorkEnd graphItems:weekTimeCards];
        return cell;
        
    }else if(indexPath.row >= tableCellTypeMonth) {
        MonthTableViewCell *cell = [self tableView:tableView monthCellForRowAtIndexPath:indexPath];
        
        //TODO: cell update.
        [cell updateCell:[_items objectAtIndex:indexPath.row]];
        
        return cell;
        
    }else {
        //その他
    }
    
    //ここにくることはありえないのでnilにする
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"%d table cell selected.", indexPath.row);
    
    if (indexPath.row == tableCellTypeToday) {
        //
    }else {
        [StoryboardUtil gotoMonthWorkingTableViewController:self completion:^(id destinationController) {
            //paramを渡す
            MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)destinationController;
            
            //TODO:
            TimeCardSummary *summaryModel = [_items objectAtIndex:indexPath.row];
//            NSString *dateString = [NSString stringWithFormat:@"%d", summaryModel.t_yyyymm];
            
            
            TimeCardDao *timeCardDao = [TimeCardDao new];
//            [timeCardDao fetchModelYear:summaryMode month:<#(NSInteger)#>
            
//            controller.timeCard = ;
        }];
    }
    
}


@end
