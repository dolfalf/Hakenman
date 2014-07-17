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
#import <UIKit/UIDocumentInteractionController.h>
#import "NSUserDefaults+Setting.h"
#import "NSDate+Helper.h"
#import "Util.h"
#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"

//#define SEND_CSV_DOCUMENT_TEST_ENABLE

enum {
    settingTitleWorkingSpace,
    settingTitleCalcTimeUnit,
    settingTitleDefaultWorkTime,
    settingTitleWorkTableDisplayOption,
    settingTitleDailyMailContent,
//    settingTitleBackupRestore,
    
} settingTitle;

@interface SettingViewController () <UIAlertViewDelegate, UIDocumentInteractionControllerDelegate> {
    
    IBOutlet UIBarButtonItem *closeButton;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RETableViewManager *reTableManager;
@property (nonatomic, weak) IBOutlet UITableView *settingTableView;

@property (nonatomic, strong) UIAlertView *deleteAlertview;

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
    
    self.title = LOCALIZE(@"SettingViewController_navi_title");
    
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
    
    [self loadInitDataSection];
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
        if ([self validate] == YES) {
            [NSUserDefaults setWorkSitename:item.value];
        }else {
            
        }

    };
    
    workspaceItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    workspaceItem.style = UITableViewCellStyleValue1;
    workspaceItem.charactersLimit = 20;
    workspaceItem.validators = @[@"length(0, 20)"];
    [basicSection addItem:workspaceItem];
    
    //時間きり設定 picker
    NSArray *kubunPickData = [Util worktimePickList];
    
    NSString *defaultTimePickString = kubunPickData[[NSUserDefaults timeKubun]];
    
    REPickerItem *defalutTimePickerItem = [REPickerItem itemWithTitle:LOCALIZE(@"SettingViewController_worktime_picker_title")
                                                                value:@[defaultTimePickString]
                                                          placeholder:nil
                                                              options:@[kubunPickData]];
    
    [basicSection addItem:defalutTimePickerItem];
    
    defalutTimePickerItem.onChange = ^(REPickerItem *item ) {
        
        DLog(@"item:%@", [item.value objectAtIndex:0]);
        
        if([item.value count] > 0) {
            [NSUserDefaults setTimeKubun:[Util worktimeKubun:[item.value objectAtIndex:0]]];
        }
    };
    
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
        [NSUserDefaults setWorkEndTime:[item.value convHHmmString]];
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
                                                          
                                                          //保存
                                                          DLog(@"item:%@", item.value);
                                                          
                                                          [NSUserDefaults setDisplayWorkSheet:[Util displayWorkSheetIndex:item.value]];
                                                          
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
                                                         value:[NSUserDefaults reportToMailaddress] placeholder:LOCALIZE(@"SettingViewController_work_report_placehold_mail_address")];
    
    reportMailTextItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    reportMailTextItem.style = UITableViewCellStyleValue1;
    reportMailTextItem.charactersLimit = 30;
    reportMailTextItem.name = LOCALIZE(@"SettingViewController_work_report_placehold_mail_address");
//    reportMailTextItem.name = @"Your email";
    reportMailTextItem.keyboardType = UIKeyboardTypeEmailAddress;
    reportMailTextItem.autocapitalizationType = UITextAutocapitalizationTypeNone;
    reportMailTextItem.validators = @[@"email"];
    [reportSection addItem:reportMailTextItem];
    
    reportMailTextItem.onEndEditing = ^(RETextItem *item) {
        //入力完了の時
        if ([self validate] == YES) {
            [NSUserDefaults setReportToMailaddress:item.value];
        }else {
            //値が更新されない
            //item.value = [NSUserDefaults reportToMailaddress];
        }
        
    };
    
    //日報タイトル設定
    //【日報】2014年7月3日
    // (日報)20140703
    RETextItem *reportMailTitleTextItem = [RETextItem itemWithTitle:LOCALIZE(@"SettingViewController_mail_title_title")
                                                         value:[NSUserDefaults reportMailTitle]
                                                   placeholder:LOCALIZE(@"SettingViewController_work_report_mail_title_placeholder")];
    
    reportMailTitleTextItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    reportMailTitleTextItem.style = UITableViewCellStyleValue1;
    reportMailTitleTextItem.validators = @[@"length(1, 30)"];
    reportMailTitleTextItem.name = LOCALIZE(@"SettingViewController_work_report_title_defalut");
    [reportSection addItem:reportMailTitleTextItem];
    
    reportMailTitleTextItem.onEndEditing = ^(RETextItem *item) {
        //入力完了の時
        if ([self validate] == YES) {
            [NSUserDefaults setReportMailTitle:item.value];
        }else {
            
        }
        
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
    
    mailContentTextItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    mailContentTextItem.style = UITableViewCellStyleValue1;
    mailContentTextItem.charactersLimit = 200;
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

    __typeof (self) __weak weakSelf = self;
    
    // Add a section
    //
    RETableViewSection *appInfoSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_app_info_section_title")];
    [self.reTableManager addSection:appInfoSection];
    
    //チュートリアル
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_tutorial_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        //遷移
        [StoryboardUtil gotoTutorialViewController:self animated:YES];
    }]];
    
    //アプリについて
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_app_info_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        //遷移
        [StoryboardUtil gotoAppInformationViewController:self completion:^(id controller) {
            //
        }];
    }]];
    
    //Open source lisence
    [appInfoSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_open_lisence_title") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        [StoryboardUtil gotoOpenLicenseViewController:self completion:^(id controller) {
            //
        }];
    }]];
    
}

- (void)loadInitDataSection {

    __typeof (self) __weak weakSelf = self;
    //
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_init_database_title")];
    [self.reTableManager addSection:section];
    
    // Add a basic cell with disclosure indicator
    [section addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_database_init_title")
                                      accessoryType:UITableViewCellAccessoryDetailDisclosureButton
                                   selectionHandler:^(RETableViewItem *item) {
                                       
                                       __typeof (weakSelf) __strong strongSelf = weakSelf;
                                       [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                       
                                       NSLog(@"initialize database: %@", item);
                                       weakSelf.deleteAlertview = [[UIAlertView alloc] initWithTitle:@""
                                                                                             message:LOCALIZE(@"SettingViewController_database_init_alert_text")
                                                                                            delegate:weakSelf
                                                                                   cancelButtonTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                                                   otherButtonTitles:LOCALIZE(@"Common_alert_button_ok"), nil];
                                       
                                       [weakSelf.deleteAlertview show];
                                   
                                   }]];
    
#ifdef SEND_CSV_DOCUMENT_TEST_ENABLE
    // Add a basic cell with disclosure indicator
    [section addItem:[RETableViewItem itemWithTitle:@"CSV生成テスト"
                                      accessoryType:UITableViewCellAccessoryDetailDisclosureButton
                                   selectionHandler:^(RETableViewItem *item) {
                                       
                                       __typeof (weakSelf) __strong strongSelf = weakSelf;
                                       [strongSelf.settingTableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                       
                                       TimeCardDao *tdao = [TimeCardDao new];
                                       NSArray *arrays = [tdao fetchModelYear:2014 month:6];
                                       [Util sendWorkSheetCsvfile:self data:arrays];
                                       
                                   }]];
#endif
    
}

#pragma mark - validate method
- (BOOL)validate {
    NSArray *managerErrors = _reTableManager.errors;
    if (managerErrors.count > 0) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    } else {
        DLog(@"All good, no errors!");
    }
    
    return YES;
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

#pragma mark - UIAlertView delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView isEqual:_deleteAlertview] == YES) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            //Cancel
        }else {
            //OK
            TimeCardDao *timeCardDao = [TimeCardDao new];
            [timeCardDao deleteAllModel];
            TimeCardSummaryDao *timeCardSummaryDao = [TimeCardSummaryDao new];
            [timeCardSummaryDao deleteAllModel];
        }
        
    }
}

@end
