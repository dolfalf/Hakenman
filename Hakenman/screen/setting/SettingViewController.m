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
    
    IBOutlet UIBarButtonItem *closeButton;
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
    
    closeButton.title = LOCALIZE(@"Common_navigation_closebutton_title");
}

#pragma mark - RETableView methods
- (void)initTableView {
    
    // Create the manager
    //
    self.reTableManager = [[RETableViewManager alloc] initWithTableView:self.settingTableView];

    [self loadBasicSection];
    
    [self loadReportSection];
    
    [self loadMailContentSection];
    
    [self loadAppInfoSection];
    
}

- (void)loadBasicSection {
    
    __typeof (self) __weak weakSelf = self;
    
    // Add a section
    RETableViewSection *basicSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_basic_section_title")];
    [self.reTableManager addSection:basicSection];
    
    //勤務先 textField
    RETextItem *workspaceItem = [RETextItem itemWithTitle:LOCALIZE(@"SettingViewController_menulist_working_space_title")
                                                    value:[NSUserDefaults workSitename]];
    
    workspaceItem.onEndEditing = ^(RETextItem *item) {
        //入力完了の時
        [NSUserDefaults setWorkSitename:item.value];
    };
    
    workspaceItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    workspaceItem.textAlignment = NSTextAlignmentLeft;
    workspaceItem.style = UITableViewCellStyleValue1;
    [basicSection addItem:workspaceItem];
    
    //時間きり設定 picker
    NSArray *kubunPickData = [Util worktimePickList];
    
    NSString *defaultTimePickString = kubunPickData[[NSUserDefaults timeKubun]];
    [basicSection addItem:[REPickerItem itemWithTitle:LOCALIZE(@"SettingViewController_worktime_picker_title")
                                                value:@[defaultTimePickString]
                                          placeholder:nil
                                              options:@[kubunPickData]]];
    
    //出勤
    NSDate *startWt = [NSDate convDate2String:[NSString stringWithFormat:@"%@%@00",
                                               [[NSDate date] yyyyMMddString],
                                               [[NSUserDefaults workStartTime]
                                                stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    
    REDateTimeItem *startWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_start_worktime_picker_title") value:startWt
                                                          placeholder:nil format:@"HH:mm"
                                                       datePickerMode:UIDatePickerModeDateAndTime];
    startWtPickerItem.datePickerMode = UIDatePickerModeTime;
    startWtPickerItem.format = @"HH:mm";
    [basicSection addItem:startWtPickerItem];
    
    startWtPickerItem.onChange = ^ (REDateTimeItem *item) {
        //Picker値変更
        [NSUserDefaults setWorkStartTime:[item.value convHHmmString]];
    };
    
    //退勤
    NSDate *endWt = [NSDate convDate2String:
                     [NSString stringWithFormat:@"%@%@00",
                      [[NSDate date] yyyyMMddString],
                      [[NSUserDefaults workEndTime]
                       stringByReplacingOccurrencesOfString:@":" withString:@""]]];
    
    REDateTimeItem *endWtPickerItem = [REDateTimeItem itemWithTitle:LOCALIZE(@"SettingViewController_default_end_worktime_picker_title") value:endWt
                                                        placeholder:nil format:@"HH:mm"
                                                     datePickerMode:UIDatePickerModeDateAndTime];
    endWtPickerItem.datePickerMode = UIDatePickerModeTime;
    endWtPickerItem.format = @"HH:mm";
    [basicSection addItem:endWtPickerItem];
    
    endWtPickerItem.onChange = ^ (REDateTimeItem *item) {
        //Picker値変更
        [NSUserDefaults setWorkStartTime:[item.value convHHmmString]];
    };
    
    //過去勤務表リスト表示
    NSArray *worksheet_options = [Util displayWorkSheetList];
    
    RERadioItem *worksheet_optionItem = [RERadioItem itemWithTitle:
                                         LOCALIZE(@"SettingViewController_last_worksheet_display_title")
                                                             value:[worksheet_options objectAtIndex:[NSUserDefaults displayWorkSheet]]
                                                  selectionHandler:^(RERadioItem *item) {
                                                      __typeof (weakSelf) __strong strongSelf = weakSelf;
                                                      [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                                      
                                                      // Present options controller
                                                      //
                                                      RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:worksheet_options multipleChoice:NO completionHandler:^ {
                                                          [strongSelf.settingTableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }];
                                                      [strongSelf.navigationController pushViewController:optionsController animated:YES];
                                                  }];
    [basicSection addItem:worksheet_optionItem];
}

- (void)loadReportSection {
    
    // Add a section
    RETableViewSection *reportSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_work_report_section_title")];
    [self.reTableManager addSection:reportSection];
    
    //日報報告宛先メール
    RETextItem *reportMailTextItem = [RETextItem itemWithTitle:LOCALIZE(@"SettingViewController_work_report_title_mail_address")
                                                         value:[NSUserDefaults reportToMailaddress]
                                                   placeholder:@"Email Address"];
    
    reportMailTextItem.name = LOCALIZE(@"SettingViewController_work_report_placehold_mail_address");
    reportMailTextItem.validators = @[@"presence", @"email"];
    [reportSection addItem:reportMailTextItem];
    
    reportMailTextItem.onEndEditing = ^(RETextItem *item) {
        //入力完了の時
        [NSUserDefaults setReportToMailaddress:item.value];
    };
    
    //日報タイトル設定
    //【日報】2014年7月3日
    // (日報)20140703
    RETextItem *reportMailTitleTextItem = [RETextItem itemWithTitle:LOCALIZE(@"SettingViewController_mail_title_title")
                                                         value:[NSUserDefaults reportMailTitle]
                                                   placeholder:@"Email Title"];
    
    reportMailTitleTextItem.name = LOCALIZE(@"SettingViewController_work_report_title_defalut");
    [reportSection addItem:reportMailTitleTextItem];
    
    reportMailTitleTextItem.onEndEditing = ^(RETextItem *item) {
        //入力完了の時
        [NSUserDefaults setReportMailTitle:item.value];
    };

    
    //日報時間表示内容追加可否
    [reportSection addItem:[REBoolItem itemWithTitle:LOCALIZE(@"SettingViewController_work_report_time_templete_add")
                                               value:[NSUserDefaults reportMailTempleteTimeAdd]
                            switchValueChangeHandler:^(REBoolItem *item) {
                                //DLog(@"Value: %i", item.value);
                                [NSUserDefaults setReportMailTempleteTimeAdd:[@(item.value) boolValue]];
                                //LOCALIZE(@"SettingViewController_menulist_work_report_content_worktime_templete)
    }]];
}

- (void)loadMailContentSection {
    
    __typeof (self) __weak weakSelf = self;
    
    // Add a section
    RETableViewSection *mailContentSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_work_report_content_section_title")];
    [self.reTableManager addSection:mailContentSection];
    
    //日報内容テンプレート
    RELongTextItem *mailContentTextItem = [RELongTextItem itemWithValue:[NSUserDefaults reportMailContent]
                                                            placeholder:LOCALIZE(@"SettingViewController_menulist_work_report_content_placeholder")];
    mailContentTextItem.cellHeight = 88;
    [mailContentSection addItem:mailContentTextItem];
    
    mailContentTextItem.onBeginEditing = ^(RELongTextItem *item) {
        //入力のとき
        [weakSelf.settingTableView setContentOffset:CGPointMake(0,
                                                                weakSelf.settingTableView.contentOffset.y + item.cellHeight) animated:YES];
    };
    
    mailContentTextItem.onEndEditing = ^(RELongTextItem *item) {
        //入力が完了したら
        [weakSelf.settingTableView setContentOffset:CGPointMake(0,
                                                                weakSelf.settingTableView.contentOffset.y - item.cellHeight) animated:YES];
        
        [NSUserDefaults setReportMailContent:item.value];
    };
}

- (void)loadAppInfoSection {

    // Add a section
    //
    RETableViewSection *appInfoSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_app_info_section_title")];
    [self.reTableManager addSection:appInfoSection];
    
    //チュートリアル
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_tutorial_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        NSLog(@"tutorial: %@", item);
        //遷移
    }]];
    
    //アプリについて
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_app_info_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        NSLog(@"app_info: %@", item);
        //遷移
    }]];
    
    //Open source lisence
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_open_lisence_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        NSLog(@"open source: %@", item);
        [StoryboardUtil gotoOpenLicenseViewController:self completion:^(id controller) {
            //
        }];
    }]];
    
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

@end
