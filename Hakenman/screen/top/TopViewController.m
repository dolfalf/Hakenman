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
#import <DJWActionSheet/DJWActionSheet.h>
#import "Util.h"
#import "MonthWorkingTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "NSUserDefaults+Setting.h"

#define TOPVIEWCONTROLLER_MENU_HIDDEN

NS_ENUM(NSInteger, tableCellType) {
    tableCellTypeToday = 0,
    tableCellTypeMonth,
};

NS_ENUM(NSInteger, actionsheetButtonType) {
    actionsheetButtonTypeWriteStartTime = 0,
    actionsheetButtonTypeWriteEndTime,
    actionsheetButtonTypeSendWorkReport,
};

static NSString * const kTodayCellIdentifier = @"todayCellIdentifier";
static NSString * const kMonthCellIdentifier = @"monthCellIdentifier";

@interface TopViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    
    IBOutlet UITableView *mainTableView;
    
    PBBarButtonIconButton *_menuBarButton;
    PBBarButtonIconButton *_settingBarButton;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) TodayTableViewCell *todayCell;
@property (nonatomic, strong) UIActionSheet *writeActionSheet;
@property (nonatomic, assign) NSTimer *loadTimer;

@property (nonatomic, strong) UIAlertView *writeWorkStartAlert;
@property (nonatomic, strong) UIAlertView *writeWorkEndAlert;

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
    
    //summary table更新
    TimeCardSummaryDao *timeCardSummaryDao = [[TimeCardSummaryDao alloc] init];
//    [timeCardSummaryDao updatedTimeCardSummaryTable:[[NSDate date] yyyyMMString]];
    [timeCardSummaryDao updatedTimeCardSummaryTable:@"201308"];
    
    //MARK: テストデータの生成
#if 0
    TimeCardDao *timeCardDao = [[TimeCardDao alloc] init];

    [timeCardDao deleteAllModel];
    for (int j=3; j < 9; j++) {
        for (int i=1; i <= 31; i++) {
            TimeCard *model = [timeCardDao createModel];
            //20140301090000
            model.start_time = [NSString stringWithFormat:@"20140%d%02d090000",j,i];
            model.end_time = [NSString stringWithFormat:@"20140%d%02d1%d0000",j,i, rand()%9];
            model.t_year = @([[model.start_time substringWithRange:NSMakeRange(0, 4)] intValue]);
            model.t_month = @([[model.start_time substringWithRange:NSMakeRange(4, 2)] intValue]);
            model.t_day = @([[model.start_time substringWithRange:NSMakeRange(6, 2)] intValue]);
            model.t_yyyymmdd = @([[model.start_time substringWithRange:NSMakeRange(0, 8)] intValue]);
            model.workday_flag = [NSNumber numberWithBool:YES];
            model.remarks = @"あいうえお";
            
            DLog(@"start_time:[%@], end_time:[%@]", model.start_time, model.end_time);
            [timeCardDao insertModel];
        }
    }
    
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
    
    //Tutorial Show
    [self performSelector:@selector(showTutorialView) withObject:nil afterDelay:0.3];
}


- (void)viewWillAppear:(BOOL)animated {
    
#ifdef TOPVIEWCONTROLLER_MENU_HIDDEN
    _menuBarButton.hidden = YES;
#else
    _menuBarButton.hidden = NO;
#endif
    _settingBarButton.hidden = NO;

    //グラプデータをリロードする
    self.items = [self displayCellItems];
    [mainTableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    //出勤時間チェック開始
    [self startLoadTimer];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _menuBarButton.hidden = YES;
    _settingBarButton.hidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    self.loadTimer = nil;
    
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

#pragma mark - timer 
- (void)startLoadTimer {
    
    if (_loadTimer != nil) {
        return;
    }
    
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:20.f
                                                      target:self
                                                    selector:@selector(updateWorkTime:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    //最初は直接に実行する
    [self updateWorkTime:nil];
}

#pragma mark - callback method
- (void)updateWorkTime:(NSTimer *)tm {
    
    DLog(@"%s",__FUNCTION__);
    
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
    
    //出勤時間チェック開始
    [self startLoadTimer];
    
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

#pragma mark - Custom Actionsheet
- (IBAction)writeWorkSheetButtonTouched:(id)sender {
    
    [DJWActionSheet showInView:self.navigationController.view
                     withTitle:LOCALIZE(@"Common_actionsheet_title")
             cancelButtonTitle:LOCALIZE(@"Common_actionsheet_cancel")
        destructiveButtonTitle:nil
             otherButtonTitles:@[
                                 LOCALIZE(@"TopViewController_actionsheet_start_work_write"),
                                 LOCALIZE(@"TopViewController_actionsheet_end_work_write"),
                                 LOCALIZE(@"TopViewController_actionsheet_send_work_report")]
     
                      tapBlock:^(DJWActionSheet *actionSheet, NSInteger tappedButtonIndex) {
                          if (tappedButtonIndex == actionSheet.cancelButtonIndex) {
                              DLog(@"User Cancelled");
                              
                          } else if (tappedButtonIndex == actionSheet.destructiveButtonIndex) {
//                              DLog(@"Destructive button tapped");
                          }else {
                              DLog(@"The user tapped button at index: %i", tappedButtonIndex);
                              
                              if (tappedButtonIndex == actionsheetButtonTypeWriteStartTime) {
                                  //
                                  self.writeWorkStartAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                                        message:LOCALIZE(@"TopViewController_write_workstart_alertview_message")
                                                                                       delegate:self
                                                                              cancelButtonTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                                              otherButtonTitles:LOCALIZE(@"Common_alert_button_ok"), nil];
                                  [_writeWorkStartAlert show];
                                  
                                  
                              }else if(tappedButtonIndex == actionsheetButtonTypeWriteEndTime) {
                                  
                                  self.writeWorkEndAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                                        message:LOCALIZE(@"TopViewController_write_workend_alertview_message")
                                                                                       delegate:self
                                                                              cancelButtonTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                                              otherButtonTitles:LOCALIZE(@"Common_alert_button_ok"), nil];
                                  [_writeWorkEndAlert show];
                                  
                              }else if(tappedButtonIndex == actionsheetButtonTypeSendWorkReport) {
                                  
                                  NSMutableString *mailContent = [NSMutableString new];
                                  
                                  if ([NSUserDefaults reportMailTempleteTimeAdd] == YES) {
                                      TimeCardDao *dao = [TimeCardDao new];
                                      TimeCard *model = [dao fetchModelWorkDate:[NSDate date]];
//                                      //test
//                                      TimeCard *model = [dao createModel];
//                                      model.start_time = @"20140707091234";
//                                      model.end_time = @"20140707214567";
                                      NSString *st = [NSUserDefaults workStartTime];
                                      if (model.start_time != nil && [model.start_time isEqualToString:@""] == NO) {
                                          //時間きりで補正する
                                          NSString *corrent_st = [Util correctWorktime:model.start_time];
                                          st = [NSString stringWithFormat:@"%@:%@"
                                                ,[corrent_st substringWithRange:NSMakeRange(8, 2)]
                                                ,[corrent_st substringWithRange:NSMakeRange(10, 2)]];
                                      }
                                      NSString *et = [NSUserDefaults workEndTime];
                                      if (model.end_time != nil && [model.end_time isEqualToString:@""] == NO) {
                                          //時間きりで補正する
                                          NSString *corrent_et = [Util correctWorktime:model.end_time];
                                          et = [NSString stringWithFormat:@"%@:%@"
                                                ,[corrent_et substringWithRange:NSMakeRange(8, 2)]
                                                ,[corrent_et substringWithRange:NSMakeRange(10, 2)]];
                                      }
                    
                                      //定型文追加
                                      NSString *templetFormat = LOCALIZE(@"SettingViewController_menulist_work_report_content_worktime_templete");
                                      NSString *siteName = [NSUserDefaults workSitename];
                                      if ([siteName isEqualToString:@""] || siteName == nil) {
                                          templetFormat = LOCALIZE(@"SettingViewController_menulist_work_report_content_worktime_templete_worksite_nothing");
                                          [mailContent appendFormat:templetFormat,st, et];
                                      }else{
                                          [mailContent appendFormat:templetFormat,st, et, [NSUserDefaults workSitename]];
                                      }
                                      
                                      [mailContent appendString:[NSUserDefaults reportMailContent]];
                                      
                                  }
                                  //report mail send
                                  [Util sendReportMailWorkSheet:self
                                                        subject:[NSUserDefaults reportMailTitle]
                                                    toRecipient:[NSUserDefaults reportToMailaddress]
                                                    messageBody:mailContent];
                              }
                              
                          }
                      }];
    
//    [_writeActionSheet showInView:self.navigationController.toolbar];
}

#pragma mark - private methods
- (void)showTutorialView {
    
    //最初起動の場合、チュートリアルを表示
    if ([NSUserDefaults readWelcomePage] == NO) {
        [StoryboardUtil gotoTutorialViewController:self animated:YES];
    }
}

- (NSArray *)displayCellItems {
    
    NSMutableArray *arrays = [NSMutableArray new];
    
    //一番目は固定
    [arrays addObject:@"first cell"];
    
    //サマリーからデータを持ってくる
    TimeCardSummaryDao *summaryDao = [[TimeCardSummaryDao alloc] init];
    NSDate *today = [NSDate date];
    NSDate *lastYear = [today addMonth:-1];
    NSDate *oneYearsAgo = (NSDate *)[lastYear dateByAddingTimeInterval:(60*60*24*365 *-1)];
    
    DLog(@"oneYearsAgo[%@] today[%@]",oneYearsAgo, lastYear);
    
    [arrays addObjectsFromArray:
     [summaryDao fetchModelStartMonth:[oneYearsAgo yyyyMMString] EndMonth:[lastYear yyyyMMString] ascending:NO]];
    
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
        NSArray *weekTimeCards = [dao fetchModelGraphDate:[NSDate date]];
        [cell updateCell:cellMessageTypeWorkStart graphItems:weekTimeCards];
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
    
//    DLog(@"%d table cell selected.", indexPath.row);
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    if (indexPath.row == tableCellTypeToday) {
        //
        [StoryboardUtil gotoMonthWorkingTableViewController:self completion:^(id destinationController) {
            //paramを渡す
            MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)destinationController;
            
            //現在の日時を渡す
            NSDate *today = [NSDate date];
            controller.inputDates = [today yyyyMMString];
            
        }];
        
    }else {
        [StoryboardUtil gotoMonthWorkingTableViewController:self completion:^(id destinationController) {
            //paramを渡す
            MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)destinationController;
            
            //TODO:
            TimeCardSummary *summaryModel = [_items objectAtIndex:indexPath.row];
            controller.inputDates = [NSString stringWithFormat:@"%@", summaryModel.t_yyyymm];
        }];
    }
}

#pragma mark - mail delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if(error) DLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    TimeCardDao *dao = [TimeCardDao new];
    NSDate *today = [NSDate date];
    
    if ([alertView isEqual:_writeWorkStartAlert] == YES) {
        //出勤
        [dao insertModelWorkStart:today];
        [StoryboardUtil gotoMonthWorkingTableViewController:self completion:^(id destinationController) {
            //paramを渡す
            MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)destinationController;
            
            //現在の日時を渡す
            NSDate *today = [NSDate date];
            controller.inputDates = [today yyyyMMString];
            controller.fromCurruntInputDates = [today yyyyMMddString];
            controller.fromCurruntTimeInput = YES;
        }];
    }else if ([alertView isEqual:_writeWorkEndAlert] == YES) {
        //退勤
        [dao insertModelWorkEnd:today];
        [StoryboardUtil gotoMonthWorkingTableViewController:self completion:^(id destinationController) {
            //paramを渡す
            MonthWorkingTableViewController *controller = (MonthWorkingTableViewController *)destinationController;
            
            //現在の日時を渡す
            NSDate *today = [NSDate date];
            controller.inputDates = [today yyyyMMString];
            controller.fromCurruntInputDates = [today yyyyMMddString];
            controller.fromCurruntTimeInput = YES;
        }];
    }
    
    
}


@end
