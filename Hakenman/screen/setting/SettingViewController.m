//
//  SettingViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "SettingViewController.h"

enum {
    settingTitleWorkingSpace,
    settingTitleCalcTimeUnit,
    settingTitleDefaultWorkTime,
    settingTitleWorkTableDisplayOption,
    settingTitleDailyMailContent,
//    settingTitleBackupRestore,
    
} settingTitle;

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    //設定メニュー作成
    _items = @[LOCALIZE(@"SettingViewController_menulist_working_space_title")
               ,LOCALIZE(@"SettingViewController_menulist_calc_time_unit_title")
               ,LOCALIZE(@"SettingViewController_menulist_default_work_time_title")
               ,LOCALIZE(@"SettingViewController_menulist_work_table_display_option_title")
               ,LOCALIZE(@"SettingViewController_menulist_daily_mail_content_title")];
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

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = @"SettingTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case settingTitleWorkingSpace:
            //勤務地設定
            cell.detailTextLabel.text = @"大崎";
            break;
            
        case settingTitleCalcTimeUnit:
            
            cell.detailTextLabel.text = @"10分";
            break;
            
        case settingTitleDefaultWorkTime:
            //デフォルト勤務時間
            cell.detailTextLabel.text = @"09:00 - 18:00";
            break;
            
        case settingTitleWorkTableDisplayOption:
            //勤務表リスト表示オプション
            cell.detailTextLabel.text = @"すべて";
            break;
            
        case settingTitleDailyMailContent:
            //日報メール文言設定
            cell.detailTextLabel.text = @"文言１";            
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"%@ table cell selected.", [_items objectAtIndex:indexPath.row]);
    
    switch (indexPath.row) {
        case settingTitleWorkingSpace:
            //勤務地設定
            [self goToWorkingSpace];
            break;
            
        case settingTitleCalcTimeUnit:
            //勤務時間計算単位
            [self goToCalcTimeUnit];
            break;
            
        case settingTitleDefaultWorkTime:
            //デフォルト勤務時間
            [self goToDefaultWorkTime];
            break;
            
        case settingTitleWorkTableDisplayOption:
            //勤務表リスト表示オプション
            [self goToTableDisplayOption];
            break;
            
        case settingTitleDailyMailContent:
            //日報メール文言設定
            [self goToDailyMailContent];
            break;
            
        default:
            break;
    }
}

@end
