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

#define TOPVIEWCONTROLLER_MENU_HIDDEN

NS_ENUM(NSInteger, tableCellType) {
    tableCellTypeToday = 0,
    tableCellTypeMonth,
};

NS_ENUM(NSInteger, actionsheetButtonType) {
    actionsheetButtonTypeWriteStartTime = 0,
    actionsheetButtonTypeWriteEndTime,
    actionsheetButtonTypeSendWorkReport,
    actionsheetButtonTypeCancel,
};

static NSString * const kTodayCellIdentifier = @"todayCellIdentifier";
static NSString * const kMonthCellIdentifier = @"monthCellIdentifier";

@interface TopViewController () <UIActionSheetDelegate> {
    
    IBOutlet UITableView *mainTableView;
    
    PBBarButtonIconButton *_menuBarButton;
    PBBarButtonIconButton *_settingBarButton;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) TodayTableViewCell *todayCell;
@property (nonatomic, strong) UIActionSheet *writeActionSheet;
@property (nonatomic, assign) NSTimer *loadTimer;

- (IBAction)gotoMenuButtonTouched:(id)sender;
- (IBAction)gotoSettingButtonTouched:(id)sender;

@end

@implementation TopViewController

#pragma setter
- (void)setLoadTimer:(NSTimer *)newTimer {
	[_loadTimer invalidate];
	_loadTimer = newTimer;
}

#pragma mark - life cycle
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
    
#ifdef TOPVIEWCONTROLLER_MENU_HIDDEN
    _menuBarButton.hidden = YES;
#else
    _menuBarButton.hidden = NO;
#endif
    _settingBarButton.hidden = NO;

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _menuBarButton.hidden = YES;
    _settingBarButton.hidden = YES;
    self.navigationController.toolbarHidden = YES;
     
    [super viewWillDisappear:animated];
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

//オーバーライドして非表示かどうかを選択
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - callback method
- (void)updateWorkTime:(NSTimer *)tm {
    
    if (_todayCell != nil) {
        [_todayCell updateWorkTime];
    }
}

#pragma mark - override method
- (void)initControls {
    
    [super initControls];
    
    //Navigation button add.
    [PBFlatSettings sharedInstance].mainColor = [UIColor whiteColor];
    _menuBarButton = [[PBBarButtonIconButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)
                                                                            andWithType:PBFlatIconMenu];
    
    [_menuBarButton addTarget:self action:@selector(gotoMenuButtonTouched:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _settingBarButton = [[PBBarButtonIconButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 40, 5, 35, 35)
                                                                               andWithType:PBFlatIconMore];
    [_settingBarButton addTarget:self action:@selector(gotoSettingButtonTouched:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:_menuBarButton];
    [self.navigationController.navigationBar addSubview:_settingBarButton];
    
    //title
    self.title = LOCALIZE(@"TopViewController_goWork_title");
    
    _writeActionSheet = [[UIActionSheet alloc] init];
    _writeActionSheet.delegate = self;
//    _writeActionSheet.title = @"選択してください。";
    [_writeActionSheet addButtonWithTitle:LOCALIZE(@"TopViewController_actionsheet_start_work_write")];
    [_writeActionSheet addButtonWithTitle:LOCALIZE(@"TopViewController_actionsheet_end_work_write")];
    [_writeActionSheet addButtonWithTitle:LOCALIZE(@"TopViewController_actionsheet_send_work_report")];
    [_writeActionSheet addButtonWithTitle:LOCALIZE(@"Common_actionsheet_cancel")];
    _writeActionSheet.destructiveButtonIndex = 2;
    _writeActionSheet.cancelButtonIndex = 3;
    
    //Timer
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                                      target:self
                                                    selector:@selector(updateWorkTime:)
                                                    userInfo:nil
                                                     repeats:YES];
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

- (IBAction)writeWorkSheetButtonTouched:(id)sender {
    
    [_writeActionSheet showInView:self.navigationController.toolbar];
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
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
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

#pragma mark - UIActionSheet delegate method
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
    case actionsheetButtonTypeWriteStartTime:
            [StoryboardUtil gotoMonthWorkingTableEditViewController:self completion:^(id destinationController) {
                //set param.
            }];
            
        break;
    case actionsheetButtonTypeWriteEndTime:
            [StoryboardUtil gotoMonthWorkingTableEditViewController:self completion:^(id destinationController) {
                //set param.
            }];
        break;
            
        case actionsheetButtonTypeSendWorkReport:
            //TODO:UserDefalutからデータを取得し、メールフォーム表示
            break;
    case actionsheetButtonTypeCancel:
            //cancel
        break;
    }

}

@end
