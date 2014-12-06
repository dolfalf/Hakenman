//
//  MenuViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MenuViewController.h"
#import "UIColor+Helper.h"
#import "NSDate+Helper.h"
//#import <RETableViewManager/RETableViewManager.h>

#define KJCODE_START_YEAR 2010     // PickerViewの最初の年

enum {
    menuTitleMonthWorkingTable,
    menuTitleWorkTableList,
    menuTitleSendDailyMail
} menuTitle;

//예상 실장수단
//RETableView의 date item을 생성
//date item(이하 피커)를 선택하면 년/월 별로 값을 입력한 다음 Done을 누르면 입력한 값에 대한 년/월의 근무표가 생성된다
//그 후에는 통상 근무표 입력과 같음
//문제점 1 : 피커의 날짜표시 제어가 가능한 것인지(너무 과거라던가 미래라던가)
//문제점 2 : 이미 데이터가 존재하는 월에 대해서는 근무표 생성이 되지 않도록 막아야 하는건지
//기타 문제점 다수 예상...

@interface MenuViewController ()<UIPickerViewDelegate,
UIPickerViewDataSource> {
    
    NSMutableArray *years;     // PickerViewの年のデータ保持用
    NSMutableArray *months;    // PickerViewの月のデータ保持用
    
}

@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, strong) RETableViewManager *manager;
//@property (nonatomic, strong) RETableViewSection *section;
//@property (nonatomic, strong) RETableViewItem *item;
//@property (nonatomic, strong) REDateTimeItem *date;
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@end

@implementation MenuViewController

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
    //    self.manager = [[RETableViewManager alloc]initWithTableView:menuTableView];
    //    self.section = [[RETableViewSection alloc]initWithHeaderTitle:@"過去のデータ入力"];
    //    //datePickerの選択値に制限をかける必要あり（ex : 過去のデータだから入力は先月から）
    //    NSDate *dateValue = [[NSDate date]getBeginOfMonth];
    //    self.date = [[REDateTimeItem alloc]initWithTitle:nil value:dateValue placeholder:@"place!!!" format:@"yyyy-MM" datePickerMode:UIDatePickerModeDate];
    //    self.date.maximumDate = dateValue;
    //    self.date.minimumDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    
    // 現在の日付を取得
    NSDate *today = [[NSDate date]getBeginOfMonth];
    
    // 現在の日付(NSDate)から年と月をintで取得
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    long todayYear  = components.year;   // 現在の年を取得
    long todayMonth = components.month;  // 現在の月を取得
    
    // ラベルに現在の日付を表示
    self.dateLabel.text = [NSString stringWithFormat:@"西暦%ld年%ld月", todayYear, todayMonth];
#else
    int todayYear  = components.year;   // 現在の年を取得
    int todayMonth = components.month;  // 現在の月を取得
    
    // ラベルに現在の日付を表示
    self.dateLabel.text = [NSString stringWithFormat:@"西暦%d年%d月", todayYear, todayMonth];
#endif
    
    // Pickerviewにデリゲートを設定
    self.pickerView.delegate = self;
    
    // -------------------------------------------
    // PickerViewに表示させるデータの作成
    // -------------------------------------------
    // PickerViewに年部分に表示させる年データの作成 (1970, 1971, ..., 2030)
    years = [[NSMutableArray alloc] initWithCapacity:(todayYear-KJCODE_START_YEAR)];
    for (int i = KJCODE_START_YEAR; i <= todayYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%d", i]];
    }
    // PickerViewの月部分に表示させる月データの作成 (1, 2, ..., 12)
    months = [[NSMutableArray alloc] initWithCapacity:12];
    
    for (int i = 1; i <= 12; i++) {
        [months addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    // -------------------------------------------
    // PickerViewに初期の選択値として、現在の日付を設定
    // -------------------------------------------
    // PickerViewの列数を計算する
    // 列数(row)は0から始まるので注意。例えば、1970年を指定したかったらrowは0, 1971ならrowは1となる
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    long rowOfTodayYear  = todayYear  - KJCODE_START_YEAR;    // 年の列数を計算
    long rowOfTodayMonth = todayMonth - 1;             // 月の列数を計算
#else
    int rowOfTodayYear  = todayYear  - KJCODE_START_YEAR;    // 年の列数を計算
    int rowOfTodayMonth = todayMonth - 1;             // 月の列数を計算
#endif
    // PickerViewの初期の選択値を設定
    // componentが行番号、selectRowが列番号
    [self.pickerView selectRow:rowOfTodayYear inComponent:0 animated:YES];  // 年を選択
    [self.pickerView selectRow:rowOfTodayMonth inComponent:1 animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    //メニューリスト生成
    _items = @[LOCALIZE(@"MenuViewController_menulist_month_working_table_title")
               ,LOCALIZE(@"MenuViewController_menulist_working_tablelist_title")
               ,LOCALIZE(@"MenuViewController_menulist_send_daily_mail_title")];
    
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqual:@"goToMonthWorkingTable"]) {
        //
    }else if ([[segue identifier] isEqual:@"goToWorkTableList"]) {
        //
    }else if ([[segue identifier] isEqual:@"goToSendDailyMail"]) {
        //
    }
}

#pragma mark - transition screen method
- (void)goToMonthWorkingTable {
    DLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"goToMonthWorkingTable" sender:self];
    
}

- (void)goToWorkTableList {
    DLog(@"%s", __FUNCTION__);
}

-(void)goToSendDailyMail {
    DLog(@"%s", __FUNCTION__);
}

#pragma mark - UIPickerView Delegate

// 列数を返す
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    // 年と月を表示するので2列を指定
    return 2;
}

// 各列に対する、行数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0: // 年(1列目)の場合(配列と同じように0から始まる)
            return [years count];   // 年のデータ数を返す
        case 1: // 月(2列目)の場合
            return [months count];  // 月のデータ数を返す
    }
    return 0;
}
// 列×行に対応する文字列を返す
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0: // 年(1列目)の場合(配列と同じように0から始まる)
            return [years objectAtIndex:row];   // 年のデータの列に対応した文字列を返す
        case 1: // 月(2列目)の場合
            return [months objectAtIndex:row];  // 月のデータの列に対応した文字列を返す
    }
    return nil;
}

// PickerViewの操作が行われたときに呼ばれる
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row  inComponent:(NSInteger)component {
    
    // PickerViewの選択されている年と月の列番号を取得
    int rowOfYear  = (int)[pickerView selectedRowInComponent:0]; // 年を取得
    int rowOfMonth = (int)[pickerView selectedRowInComponent:1]; // 月を取得
    
    // ラベルに現在の日付を表示
    self.dateLabel.text = [NSString stringWithFormat:@"西暦%@年%@月",
                           [years objectAtIndex:rowOfYear], [months objectAtIndex:rowOfMonth]];
}

#pragma mark - UITableView Delegate
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
//    NSString *cellIdentifier = @"MenuTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//
//    // セルが作成されていないか?
//    if (!cell) { // yes
//        // セルを作成
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//
//    // セルにテキストを設定
//    // セルの内容はNSArray型の「items」にセットされているものとする
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
//    DLog(@"%@ tableCell Selected.", [_items objectAtIndex:indexPath.row]);
//
//    switch (indexPath.row) {
//        case menuTitleMonthWorkingTable:
//            //今月の勤務表
//            [self goToMonthWorkingTable];
//            break;
//
//        case menuTitleWorkTableList:
//            //勤務表リスト
//            [self goToWorkTableList];
//            break;
//
//        case menuTitleSendDailyMail:
//            //日報メール送信
//            [self goToSendDailyMail];
//            break;
//
//        default:
//            break;
//    }
//}


@end
