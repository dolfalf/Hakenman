//
//  MonthWorkingTableEditViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthWorkingTableEditViewController.h"
#import "EditTimeTableViewCell.h"
#import "SwitchButtonTableViewCell.h"
#import "TimeCardDao.h"
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
//@property (nonatomic, strong) REDateTimeItem *restTimePickerItem;
@property (nonatomic, strong) REPickerItem *restTimePickerItem;
@property (nonatomic, strong) REBoolItem *workDayBoolItme;

@property (nonatomic, weak) IBOutlet UITableView *editTableView;

@property (nonatomic, strong) UITapGestureRecognizer *keyboardDismissTap;
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

//    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_title"),
////                  [_timeCard.t_year intValue],[_timeCard.t_month intValue],[_timeCard.t_day intValue]];
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_title"),
                  [_showData.yearData intValue],[_showData.monthData intValue],[_showData.dayData intValue]];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)saveAndClose:(id)sender {
    
    TimeCardDao *dao = [TimeCardDao new];
    
    [dao createModel];
    
    //画面上の値を変更した場合、_timeCardを変更する？
    _timeCard.start_time = [_startWtPickerItem.value yyyyMMddHHmmssString];
    _timeCard.end_time = [_endWtPickerItem.value yyyyMMddHHmmssString];
    //今後修正必要
//    _timeCard.rest_time = [NSNumber numberWithFloat:[_restTimeNumberItem.value floatValue]];
    _timeCard.workday_flag = [NSNumber numberWithBool:_workDayBoolItme.value];

    [dao insertModel];
    
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
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"勤務時間入力"];
    [_reTableManager addSection:section];

    NSDate *startWt;
    NSDate *endWt;
    
    if (_timeCard.start_time == nil ||
        _timeCard.end_time == nil) {
        startWt = [NSDate convDate2String:[NSString stringWithFormat:@"%@%@00",
                                               [[NSDate date] yyyyMMddString],
                                               [[NSUserDefaults workStartTime]
                                                stringByReplacingOccurrencesOfString:@":" withString:@""]]];
        endWt = [NSDate convDate2String:
                         [NSString stringWithFormat:@"%@%@00",
                          [[NSDate date] yyyyMMddString],
                          [[NSUserDefaults workEndTime]
                           stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    }else{
        startWt = [NSDate convDate2String:_timeCard.start_time];
        endWt = [NSDate convDate2String:_timeCard.end_time];
    }
    BOOL workTime = YES;
    //営業日ではない場合の基本表示は？
    if ([_timeCard.workday_flag isEqual:[NSNumber numberWithBool:NO]]) {
        workTime = NO;
    }
    //反応が遅いかそれとも変か。。。
    //出勤
    self.startWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_start_worktime_picker_title") value:startWt
                                                          placeholder:nil format:@"HH:mm"
                                                       datePickerMode:UIDatePickerModeDateAndTime];
    _startWtPickerItem.datePickerMode = UIDatePickerModeTime;
    [section addItem:_startWtPickerItem];
    
    //退勤
    self.endWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_end_worktime_picker_title") value:endWt
                                                            placeholder:nil format:@"HH:mm"
                                                         datePickerMode:UIDatePickerModeDateAndTime];
    _endWtPickerItem.datePickerMode = UIDatePickerModeTime;
    [section addItem:_endWtPickerItem];
    
    //休憩時間  //休息時間が既に設定されている場合の基本表示は？
    self.restTimePickerItem = [REPickerItem itemWithTitle:@"休息時間" value:@[@"1", @"00"] placeholder:nil options:@[@[@"1", @"2", @"3", @"4", @"5", @"6"], @[@"00", @"15", @"30", @"45"]]];
//    self.restTimePickerItem = [REDateTimeItem itemWithTitle:@"休憩時間" value:nil placeholder:nil format:@"HH:mm" datePickerMode:UIDatePickerModeCountDownTimer];
    [section addItem:_restTimePickerItem];
//    self.restTimeNumberItem = [RENumberItem itemWithTitle:@"休憩時間" value:@"" placeholder:@"1時間" format:@"X時間"];
//    [section addItem:_restTimeNumberItem];
    
    //平日、休日
    self.workDayBoolItme = [REBoolItem itemWithTitle:@"営業日" value:workTime switchValueChangeHandler:^(REBoolItem *item) {
        NSLog(@"Value: %i", item.value);
    }];
    
    [section addItem:_workDayBoolItme];
    
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
