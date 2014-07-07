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
@property (nonatomic, strong) REBoolItem *workDayBoolItme;
@property (nonatomic, strong) RENumberItem *restTimeNumberItem;

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
//    TimeCardDao *dao = [TimeCardDao new];
//    
//    [dao insertModel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KJViewController override methods
- (void)initControls {
    
    saveBarButton.title = LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_save_btn");
    
    //キーボードの閉じる処理のため
    self.keyboardDismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(onKeyboardDismissTap:)];
    self.keyboardDismissTap.delegate = self;
    self.keyboardDismissTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_keyboardDismissTap];
    
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
    //出勤
    if ([_timeCard.start_time isEqualToString:@""] || [_timeCard.end_time isEqualToString:@""]) {
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
    
    //休憩時間
    self.restTimeNumberItem = [RENumberItem itemWithTitle:@"休憩時間" value:@"" placeholder:@"1時間" format:@"X時間"];
    [section addItem:_restTimeNumberItem];
    
    //平日、休日
    self.workDayBoolItme = [REBoolItem itemWithTitle:@"営業日" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        NSLog(@"Value: %i", item.value);
    }];
    
    [section addItem:_workDayBoolItme];
    
}

#pragma mark - TextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TextField Returnタップ
    
    // キーボード非表示
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(void)onKeyboardDismissTap:(UITapGestureRecognizer *)recognizer {
    
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
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
