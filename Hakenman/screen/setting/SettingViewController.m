//
//  SettingViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "SettingViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import <RETableViewManager/RETableViewOptionsController.h>
#import "NSUserDefaults+Setting.h"
#import "NSDate+Helper.h"
#import "Util.h"

enum {
    settingTitleWorkingSpace,
    settingTitleCalcTimeUnit,
    settingTitleDefaultWorkTime,
    settingTitleWorkTableDisplayOption,
    settingTitleDailyMailContent,
//    settingTitleBackupRestore,
    
} settingTitle;

@interface SettingViewController () {
    
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RETableViewManager *reTableManager;
@property (nonatomic, weak) IBOutlet UITableView *settingTableView;

- (IBAction)close:(id)sender;

@end

@implementation SettingViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    [super initControls];
    
    [self initTableView];
    
    //設定メニュー作成
    _items = @[LOCALIZE(@"SettingViewController_menulist_working_space_title")
               ,LOCALIZE(@"SettingViewController_menulist_calc_time_unit_title")
               ,LOCALIZE(@"SettingViewController_menulist_default_work_time_title")
               ,LOCALIZE(@"SettingViewController_menulist_work_table_display_option_title")
               ,LOCALIZE(@"SettingViewController_menulist_daily_mail_content_title")];
}

- (void)initTableView {
    
    // Create the manager
    //
    self.reTableManager = [[RETableViewManager alloc] initWithTableView:self.settingTableView];
    
    // Add a section
    //
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Test"];
    [self.reTableManager addSection:section];
    
    //勤務先 textField
    RETextItem *workspaceItem = [RETextItem itemWithTitle:LOCALIZE(@"SettingViewController_menulist_working_space_title")
                                                    value:@"test"];
    workspaceItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    workspaceItem.textAlignment = NSTextAlignmentLeft;
    workspaceItem.style = UITableViewCellStyleValue1;
    [section addItem:workspaceItem];
    
    //時間きり設定 picker
    NSArray *kubunPickData = [Util worktimePickList];
    
    NSString *defaultTimePickString = kubunPickData[[NSUserDefaults timeKubun]];
    [section addItem:[REPickerItem itemWithTitle:LOCALIZE(@"SettingViewController_worktime_picker_title")
                                           value:@[defaultTimePickString]
                                     placeholder:nil
                                         options:@[kubunPickData]]];
    
    //出勤
    NSDate *startWt = [NSDate convDate2String:[NSString stringWithFormat:@"%@%@00",
                                               [[NSDate date] yyyyMMddString],
                                               [[NSUserDefaults workStartTime]
                                                stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    
    [NSDate convDate2String:@""];
    REDateTimeItem *startWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_start_worktime_picker_title") value:startWt
                                                            placeholder:nil format:@"HH:mm"
                                                         datePickerMode:UIDatePickerModeDateAndTime];
    startWtPickerItem.datePickerMode = UIDatePickerModeTime;
    startWtPickerItem.format = @"HH:mm";
    [section addItem:startWtPickerItem];
    
    //退勤
    NSDate *endWt = [NSDate convDate2String:
                       [NSString stringWithFormat:@"%@%@00",
                                               [[NSDate date] yyyyMMddString],
                                               [[NSUserDefaults workEndTime]
                                                stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    
    REDateTimeItem *endWtworkPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_end_worktime_picker_title") value:endWt
                                                            placeholder:nil format:@"HH:mm"
                                                         datePickerMode:UIDatePickerModeDateAndTime];
    endWtworkPickerItem.datePickerMode = UIDatePickerModeTime;
    endWtworkPickerItem.format = @"HH:mm";
    [section addItem:endWtworkPickerItem];
    
    //過去勤務表リスト表示
    NSArray *options = [Util displayWorkSheetList];
    
    __typeof (self) __weak weakSelf = self;
    RERadioItem *optionItem = [RERadioItem itemWithTitle:
                               LOCALIZE(@"SettingViewController_last_worksheet_display_title")
                                                   value:[options objectAtIndex:[NSUserDefaults displayWorkSheet]]
                                        selectionHandler:^(RERadioItem *item) {
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^ {
            [strongSelf.settingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [strongSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [section addItem:optionItem];

    
}

#pragma mark - transition screen method
- (void)goToWorkingSpace {
    
}

- (void)goToCalcTimeUnit {
    
}

- (void)goToDefaultWorkTime {
    
}

- (void)goToTableDisplayOption {
    
}

- (void)goToDailyMailContent {
    
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

//#pragma mark - UITableView Delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 44.0f;
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [_items count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    NSString *cellIdentifier = @"SettingTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    switch (indexPath.row) {
//        case settingTitleWorkingSpace:
//            //勤務地設定
//            cell.detailTextLabel.text = @"大崎";
//            break;
//            
//        case settingTitleCalcTimeUnit:
//            
//            cell.detailTextLabel.text = @"10分";
//            break;
//            
//        case settingTitleDefaultWorkTime:
//            //デフォルト勤務時間
//            cell.detailTextLabel.text = @"09:00 - 18:00";
//            break;
//            
//        case settingTitleWorkTableDisplayOption:
//            //勤務表リスト表示オプション
//            cell.detailTextLabel.text = @"すべて";
//            break;
//            
//        case settingTitleDailyMailContent:
//            //日報メール文言設定
//            cell.detailTextLabel.text = @"文言１";            
//            break;
//            
//        default:
//            break;
//    }
//    
//    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
//    
//    return cell;
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    DLog(@"%@ table cell selected.", [_items objectAtIndex:indexPath.row]);
//    
//    switch (indexPath.row) {
//        case settingTitleWorkingSpace:
//            //勤務地設定
//            [self goToWorkingSpace];
//            break;
//            
//        case settingTitleCalcTimeUnit:
//            //勤務時間計算単位
//            [self goToCalcTimeUnit];
//            break;
//            
//        case settingTitleDefaultWorkTime:
//            //デフォルト勤務時間
//            [self goToDefaultWorkTime];
//            break;
//            
//        case settingTitleWorkTableDisplayOption:
//            //勤務表リスト表示オプション
//            [self goToTableDisplayOption];
//            break;
//            
//        case settingTitleDailyMailContent:
//            //日報メール文言設定
//            [self goToDailyMailContent];
//            break;
//            
//        default:
//            break;
//    }
//}

@end
