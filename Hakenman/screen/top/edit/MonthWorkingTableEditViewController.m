//
//  MonthWorkingTableEditViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthWorkingTableEditViewController.h"
#import "EditTimeTableViewCell.h"
#import "SwitchButtonTableViewCell.h"
#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"
#import "NSDate+Helper.h"
#import "NSUserDefaults+Setting.h"
#import "LeftTableViewData.h"
#import <RETableViewManager/RETableViewManager.h>


#define TABLE_CELL_COUNT            4
#define TABLE_CELL_TEXTFIELD_TAG    500

typedef enum {
    cellTypeStartTime = 0,
    cellTypeEndTime,
    cellTypeRestTime,
    CellTypeWorkday
} CellType;

@interface MonthWorkingTableEditViewController () {
    IBOutlet UIBarButtonItem *saveBarButton;
}

@property (nonatomic, strong) RETableViewManager *reTableManager;
@property (nonatomic, strong) REDateTimeItem *startWtPickerItem;
@property (nonatomic, strong) REDateTimeItem *endWtPickerItem;
@property (nonatomic, strong) REPickerItem *restTimePickerItem;
@property (nonatomic, strong) RELongTextItem *remarkLongTextItem;
@property (nonatomic, strong) REBoolItem *workDayBoolItme;
@property (nonatomic, strong) RETableViewItem *clearTimeCellItem;

@property (nonatomic, weak) IBOutlet UITableView *editTableView;
@end

@implementation MonthWorkingTableEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    self.title = [NSString stringWithFormat:
                  LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_title"),
                  [_showData.yearData intValue],
                  [_showData.monthData intValue],
                  [_showData.dayData intValue]];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)saveAndClose:(id)sender {
    
    if ([[_startWtPickerItem.value convHHmmString] isEqualToString:[_endWtPickerItem.value convHHmmString]]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:LOCALIZE(@"MonthWorkingTableEditViewController_edit_start_end_equals_alert")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 
                                                             }];
        
        [alert addAction:actionCancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if ([_startWtPickerItem.value earlierDate:_endWtPickerItem.value] == _endWtPickerItem.value) {
        NSTimeInterval t = 60 * 60 * 24; // 1日
        _endWtPickerItem.value = [_endWtPickerItem.value dateByAddingTimeInterval:t];
    }
    
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *tempModel = [dao fetchModelYear:[_showData.yearData intValue] month:[_showData.monthData intValue] day:[_showData.dayData intValue]];
    
    //既に存在したら更新
    if ([tempModel count] == 0) {
        DLog(@"create Coredata!");
        [dao createModel];
    }else{
        //[tempModel count] != 0
        dao.model = (TimeCard*)[tempModel objectAtIndex:0];

    }
    
    TimeCard *timeCard = (TimeCard *)dao.model;
    
    timeCard.start_time = [_startWtPickerItem.value yyyyMMddHHmmssString];
    timeCard.end_time = [_endWtPickerItem.value yyyyMMddHHmmssString];
    timeCard.t_year = @([[timeCard.start_time substringWithRange:NSMakeRange(0, 4)] intValue]);
    timeCard.t_month = @([[timeCard.start_time substringWithRange:NSMakeRange(4, 2)] intValue]);
    timeCard.t_day = @([[timeCard.start_time substringWithRange:NSMakeRange(6, 2)] intValue]);
    timeCard.t_yyyymmdd = @([[timeCard.start_time substringWithRange:NSMakeRange(0, 8)] intValue]);
    timeCard.t_week = _showData.weekData;
    timeCard.remarks = _remarkLongTextItem.value;
    //今後修正必要
    NSString *getRestTime = [NSString stringWithFormat:@"%@", [_restTimePickerItem.value objectAtIndex:0]];
    timeCard.rest_time = [NSNumber numberWithFloat:getRestTime.floatValue];
    timeCard.workday_flag = [NSNumber numberWithBool:_workDayBoolItme.value];

    [dao insertModel];
    
    
    TimeCardSummaryDao *summaryDao = [TimeCardSummaryDao new];
    [summaryDao updatedTimeCardSummaryTable:[NSString stringWithFormat:@"%d%.2d", [_showData.yearData intValue], [_showData.monthData intValue]]];
    
    [DBManager syncDBFileToWatch];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KJViewController override methods
- (void)initControls {
    
    saveBarButton.title = LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_save_btn");
    
    [self initTableView];
}

- (void)initTableView {
    
    // Create the manager and assign a UITableView
    //
    self.reTableManager = [[RETableViewManager alloc] initWithTableView:self.editTableView];
    
    // Add a section
    //
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"MonthWorkingTableEditViewController_edit_section_title")];
    [_reTableManager addSection:section];
    
    NSDate *getWd = [NSDate convDate2ShortString:[NSString stringWithFormat:@"%d%.2d%.2d",[_showData.yearData intValue],[_showData.monthData intValue],[_showData.dayData intValue]]];
    NSDate *startWt;
    NSDate *endWt;
    BOOL workTime = YES;
    
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *tempModel = [dao fetchModelYear:[_showData.yearData intValue] month:[_showData.monthData intValue] day:[_showData.dayData intValue]];
    
    TimeCard *timeCard;
    
    //既に存在したら更新
    if ([tempModel count] == 0) {
        
    }else{
        //[tempModel count] != 0
        timeCard = (TimeCard*)[tempModel objectAtIndex:0];
    }
    
    //営業日ではない場合の基本表示は？
    if ([timeCard.workday_flag isEqual:[NSNumber numberWithBool:NO]] &&
        [_showData.workFlag isEqual:[NSNumber numberWithBool:NO]]) {
        workTime = NO;
    }
    
    if (timeCard.start_time == nil &&
        timeCard.end_time == nil) {
        startWt = [NSDate convDate2String:[NSString stringWithFormat:@"%@%@00",
                                               [getWd yyyyMMddString],
                                               [[NSUserDefaults workStartTime]
                                                stringByReplacingOccurrencesOfString:@":" withString:@""]]];
        endWt = [NSDate convDate2String:
                         [NSString stringWithFormat:@"%@%@00",
                          [getWd yyyyMMddString],
                          [[NSUserDefaults workEndTime]
                           stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    }else if(timeCard.start_time == nil){
        startWt = [NSDate convDate2String:[NSString stringWithFormat:@"%@%@00",
                                           [getWd yyyyMMddString],
                                           [[NSUserDefaults workStartTime]
                                            stringByReplacingOccurrencesOfString:@":" withString:@""]]];
        endWt = [NSDate convDate2String:timeCard.end_time];
    }else if(timeCard.end_time == nil){
        startWt = [NSDate convDate2String:timeCard.start_time];
        endWt = [NSDate convDate2String:
                 [NSString stringWithFormat:@"%@%@00",
                  [getWd yyyyMMddString],
                  [[NSUserDefaults workEndTime]
                   stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    }else{
        startWt = [NSDate convDate2String:timeCard.start_time];
        endWt = [NSDate convDate2String:timeCard.end_time];
    }

    //出勤
    self.startWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_start_worktime_picker_title") value:startWt
                                                          placeholder:nil format:@"HH:mm"
                                                       datePickerMode:UIDatePickerModeDateAndTime];
    _startWtPickerItem.datePickerMode = UIDatePickerModeTime;
    _startWtPickerItem.inlineDatePicker = YES;
    [section addItem:_startWtPickerItem];
    
    //退勤
    self.endWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_end_worktime_picker_title") value:endWt
                                                            placeholder:nil format:@"HH:mm"
                                                         datePickerMode:UIDatePickerModeDateAndTime];
    _endWtPickerItem.datePickerMode = UIDatePickerModeTime;
    _endWtPickerItem.inlineDatePicker = YES;
    [section addItem:_endWtPickerItem];
    
    //休憩時間
    NSString *restStr;
    if (timeCard.rest_time == nil) {
        restStr = @"1";
    }else{
        restStr = [timeCard.rest_time stringValue];
    }
    
    self.restTimePickerItem = [REPickerItem itemWithTitle:LOCALIZE(@"MonthWorkingTableEditViewController_edit_rest_time_cell") value:@[restStr] placeholder:nil options:@[@[@"0", @"1", @"1.5", @"2", @"2.5", @"3", @"3.5", @"4", @"4.5", @"5", @"5.5", @"6", @"6.5", @"7", @"7.5", @"8"]]];
    _restTimePickerItem.inlinePicker = YES;
    [section addItem:_restTimePickerItem];
    
    NSString *remarkValue;
    
    if (timeCard.remarks == nil || [timeCard.remarks isEqualToString:@""]) {
        remarkValue = nil;
    }else{
        remarkValue = timeCard.remarks;
    }
    
    //Remarks
    self.remarkLongTextItem = [RELongTextItem itemWithValue:remarkValue placeholder:LOCALIZE(@"MonthWorkingTableEditViewController_edit_memo_placeholder")];
    _remarkLongTextItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    _remarkLongTextItem.style = UITableViewCellStyleValue1;
    _remarkLongTextItem.editingStyle = UITableViewCellEditingStyleDelete;
    _remarkLongTextItem.charactersLimit = 200;
    _remarkLongTextItem.cellHeight = 88;
    [section addItem:_remarkLongTextItem];
    
    //入力を始めると、キーボードにテキストフィールドがかぶって表示することを対応
    //ブロック文の中で普通にselfを使うとRetainしてしまうので。。。
    //後で保存完了時の表示をテーブルビューを横スクロールさせる必要ありですぅ。。。
    __typeof (self) __weak weakSelf = self;
    
    _remarkLongTextItem.onBeginEditing = ^(RELongTextItem *item) {
        //入力のとき
        [weakSelf.editTableView setContentOffset:CGPointMake(0,
                                                                weakSelf.editTableView.contentOffset.y + item.cellHeight) animated:YES];
    };
    
    _remarkLongTextItem.onEndEditing = ^(RELongTextItem *item) {
        //入力が完了したら
        [weakSelf.editTableView setContentOffset:CGPointMake(0,
                                                                weakSelf.editTableView.contentOffset.y - item.cellHeight) animated:YES];

    };
    
    
    //平日、休日
    self.workDayBoolItme = [REBoolItem itemWithTitle:LOCALIZE(@"MonthWorkingTableEditViewController_edit_workday_switch_cell") value:workTime switchValueChangeHandler:^(REBoolItem *item) {
        DLog(@"Value: %i", item.value);
    }];
    
    [section addItem:_workDayBoolItme];
    
    // Add a basic cell with disclosure indicator
    //
    
    self.clearTimeCellItem = [RETableViewItem itemWithTitle:LOCALIZE(@"MonthWorkingTableEditViewController_edit_cleardate_cell") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:LOCALIZE(@"MonthWorkingTableEditViewController_edit_cleardate_alert")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 //clear cancel
                                                                 [_clearTimeCellItem deselectRowAnimated:NO];
                                                             }];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_ok")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self clearDate];
                                                         }];
        
        [alert addAction:actionCancel];
        [alert addAction:actionOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [section addItem:_clearTimeCellItem];
}


-(void)clearDate{
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *tempModel = [dao fetchModelYear:[_showData.yearData intValue] month:[_showData.monthData intValue] day:[_showData.dayData intValue]];
    
    //既に存在したら更新
    if ([tempModel count] == 0) {
        DLog(@"削除するデータがないよ");
    }else{
        dao.model = (TimeCard*)[tempModel objectAtIndex:0];
    }

    [dao clearTimeCardWithYear:[_showData.yearData intValue] month:[_showData.monthData intValue] day:[_showData.dayData intValue]];
    
    
    TimeCardSummaryDao *summaryDao = [TimeCardSummaryDao new];
    [summaryDao updatedTimeCardSummaryTable:[NSString stringWithFormat:@"%d%.2d", [_showData.yearData intValue], [_showData.monthData intValue]]];
    
    [DBManager syncDBFileToWatch];
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
