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
#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"
#import "MonthWorkingTableViewController.h"

#define START_YEAR 2014     // PickerViewの最初の年

@interface MenuViewController ()<UIPickerViewDelegate,
UIPickerViewDataSource, UIAlertViewDelegate>{
#if __LP64__
    long countOfTodayYear;
    long countOfTodayMonth;
    long savePastYear;
    long savePastMonth;
#else
    int countOfTodayYear;
    int countOfTodayMonth;
    int savePastYear;
    int savePastMonth;
#endif
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *years;     // PickerViewの年のデータ保持用
@property (nonatomic, strong) NSMutableArray *months;    // PickerViewの月のデータ保持用
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
    // Do any additional setup after loading the view.
    [self initControls];
    [self initYearMonth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    self.navigationItem.title = LOCALIZE(@"MenuViewController_add_past_year_month_title");
    self.navigationItem.leftBarButtonItem.title = LOCALIZE(@"Common_navigation_closebutton_title");
    self.navigationItem.rightBarButtonItem.title = LOCALIZE(@"Common_navigation_donebutton_title");
}

- (NSString*)checkCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

#pragma mark - initializeYearMonth
-(void)initYearMonth{
    // 現在の日付を取得
    NSDate *today = [[NSDate date]getBeginOfMonth];
    
    // 現在の日付(NSDate)から年と月をintで取得
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];
    
#if __LP64__
    long todayYear  = components.year;   // 現在の年を取得
    long todayMonth = components.month;  // 現在の月を取得
#else
    int todayYear  = components.year;   // 現在の年を取得
    int todayMonth = components.month;  // 現在の月を取得
#endif
    countOfTodayYear = todayYear;
    countOfTodayMonth = todayMonth;
    
    // Pickerviewにデリゲートを設定
    self.pickerView.delegate = self;
    
    // PickerViewに表示させるデータの作成
    // PickerViewに初期の選択値として、現在の日付を設定
    // PickerViewの列数を計算する
    // 列数(row)は0から始まるので注意。例えば、1970年を指定したかったらrowは0, 1971ならrowは1となる
#if __LP64__
    long rowOfTodayYear  = todayYear  - START_YEAR;    // 年の列数を計算
    long rowOfTodayMonth = todayMonth - 2;             // 月の列数を計算
#else
    int rowOfTodayYear  = todayYear  - START_YEAR;    // 年の列数を計算
    int rowOfTodayMonth = todayMonth - 2;             // 月の列数を計算
#endif
    
    if (todayMonth == 1) {
        rowOfTodayYear = rowOfTodayYear - 1;
        rowOfTodayMonth = 11;
        todayYear = todayYear - 1;
        
        savePastYear = countOfTodayYear - 1;
        savePastMonth = 12;
    }else{
        savePastYear = countOfTodayYear;
        savePastMonth = countOfTodayMonth - 1;
    }
    
    // PickerViewに年部分に表示させる年データの作成 (1970, 1971, ..., 2030)
    self.years = [[NSMutableArray alloc] initWithCapacity:(todayYear-START_YEAR)];
    
    for (int i = START_YEAR; i <= todayYear; i++) {
        [_years addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    // PickerViewの月部分に表示させる月データの作成 (1, 2, ..., 12)
    self.months = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [_months addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    
    // PickerViewの初期の選択値を設定
    // componentが行番号、selectRowが列番号
    //英語の場合は日付の表示が逆順
    if ([[self checkCurrentLanguage]isEqualToString:@"ja"]||
        [[self checkCurrentLanguage]isEqualToString:@"kr"]) {
        [self.pickerView selectRow:rowOfTodayYear inComponent:0 animated:YES];
        [self.pickerView selectRow:rowOfTodayMonth inComponent:1 animated:YES];
        // ラベルに現在の日付を表示
        self.dateLabel.text = [NSString stringWithFormat:LOCALIZE(@"MenuViewController_add_past_year_month_label"),
                               [_years objectAtIndex:rowOfTodayYear], [_months objectAtIndex:rowOfTodayMonth]];
    }else{
        [self.pickerView selectRow:rowOfTodayMonth inComponent:0 animated:YES];
        [self.pickerView selectRow:rowOfTodayYear inComponent:1 animated:YES];
        // ラベルに現在の日付を表示
        self.dateLabel.text = [NSString stringWithFormat:LOCALIZE(@"MenuViewController_add_past_year_month_label"),
                               [_months objectAtIndex:rowOfTodayMonth], [_years objectAtIndex:rowOfTodayYear]];
        
    }
}

- (void)_saveThePast{
    //저장한 순간에 피커에서 값을 읽어냄
    //읽어낸 값을 기준으로 새 NSDate를 작성
    //그 후 해당 과거월의 더미데이터를 생성
    //(생성전 해당 과거월에 관련된 데이터가 하나라도 있을 시에는 데이터가 작성 되지 않도록 함)
    //화면 전이는 하지 않음.(작성이 완료되었다는 안내만 주고 창을 끔)
    //메인으로 돌아왔을때 해당 과거월이 표시되어 있을 것(데이터가 들어있을 것)
    
    //該当する年月にデータが一つでも存在したら生成しない
    TimeCardDao *dao = [TimeCardDao new];
    
    NSNumber *year = [NSNumber numberWithInteger:savePastYear];
    NSNumber *month = [NSNumber numberWithInteger:savePastMonth];
    NSArray *tempModel = [dao fetchModelYear:[year integerValue] month:[month integerValue]];
    //該当する年月にデータがない＋該当する年月の枠(TimeCardSummary)が存在したら生成しない
    TimeCardSummaryDao *timeCardSummaryDao = [TimeCardSummaryDao new];
#if __LP64__
    NSArray *tempSummaryModel = [timeCardSummaryDao fetchModelMonth:[NSString stringWithFormat:@"%ld%ld",savePastYear, savePastMonth]];
#else
    NSArray *tempSummaryModel = [timeCardSummaryDao fetchModelMonth:[NSString stringWithFormat:@"%d%d",savePastYear, savePastMonth]];
#endif
    
    //全部存在しない場合
    if ([tempModel count] == 0 && [tempSummaryModel count] == 0){
        NSNumber *resultYearMonth;
        NSNumber *todayYearMonth;
#if __LP64__
        resultYearMonth = @([[NSString stringWithFormat:@"%ld%.2ld",savePastYear, savePastMonth] integerValue]);
        todayYearMonth = @([[NSString stringWithFormat:@"%ld%.2ld",countOfTodayYear, countOfTodayMonth] integerValue]);
#else
        resultYearMonth = @([[NSString stringWithFormat:@"%d%.2d",savePastYear, savePastMonth] integerValue]);
        todayYearMonth = @([[NSString stringWithFormat:@"%d%.2d",countOfTodayYear, countOfTodayMonth]integerValue]);
#endif
        BOOL isFutureYearMonth = todayYearMonth <= resultYearMonth? YES:NO;
        
        if (isFutureYearMonth) {
            DLog(@"未来のデータは作れないよ");
            [self _showErrorAlertWithErrorMessage:
             LOCALIZE(@"MenuViewController_add_past_year_month_Alert_Message_Error_2")];
            return;
        }
        
        //データ更新可能
        TimeCardSummaryDao *timeCardSummaryDao = [[TimeCardSummaryDao alloc] init];
        
        TimeCardSummary *model = [timeCardSummaryDao createModel];
#if __LP64__
        model.t_yyyymm = @([[NSString stringWithFormat:@"%ld%ld",savePastYear, savePastMonth] integerValue]);
#else
        model.t_yyyymm = @([[NSString stringWithFormat:@"%d%d",savePastYear, savePastMonth] integerValue]);
#endif
        
        DLog(@"t_yyyymm:[%d]", [model.t_yyyymm intValue]);
        
        [timeCardSummaryDao insertModel];
        
        TimeCardSummaryDao *summaryDao = [TimeCardSummaryDao new];
#if __LP64__
        [summaryDao updatedTimeCardSummaryTable:[NSString stringWithFormat:@"%ld%.2ld", [year integerValue], [month integerValue]]];
#else
        [summaryDao updatedTimeCardSummaryTable:[NSString stringWithFormat:@"%d%.2d", [year integerValue], [month integerValue]]];
#endif
        
        [self close:nil];
    }else{
        DLog(@"既にデータがあるよ");
        [self _showErrorAlertWithErrorMessage:
         LOCALIZE(@"MenuViewController_add_past_year_month_Alert_Message_Error_1")];
        return;
    }
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

- (IBAction)onCheckAlert:(id)sender{
    
    if (IOS8) {
        //iOS8
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZE(@"MenuViewController_add_past_year_month_Alert_Message") preferredStyle:UIAlertControllerStyleAlert];

        [alert setTitle:@""];
        [alert setMessage:LOCALIZE(@"MenuViewController_add_past_year_month_Alert_Message")];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *action){
                                                        
                                                        }];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_ok")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 [self _saveThePast];
                                                             }];
        
        [alert addAction:actionCancel];
        [alert addAction:actionOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //before iOS7
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""                                                            message:LOCALIZE(@"MenuViewController_add_past_year_month_Alert_Message")
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZE(@"Common_alert_button_cancel")
                                              otherButtonTitles:LOCALIZE(@"Common_alert_button_ok"), nil];
        [alert show];

    }
}

#pragma mark - UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self _saveThePast];
    }else{
        return;
    }
}

-(void)_showErrorAlertWithErrorMessage:(NSString *)errorMessage{
    if (IOS8) {
        //iOS8
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_cancel")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 
                                                             }];
        
        [alert addAction:actionCancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //before iOS7
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""                                                            message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZE(@"Common_alert_button_cancel")
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark - UIPickerView Delegate

// 列数を返す
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    // 年と月を表示するので2列を指定
    return 2;
}

// 各列に対する、行数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //英語の場合は日付の表示が逆順
    if ([[self checkCurrentLanguage]isEqualToString:@"ja"]||
        [[self checkCurrentLanguage]isEqualToString:@"kr"]) {
        switch (component) {
            case 0: // 年(1列目)の場合(配列と同じように0から始まる)
                return [_years count];   // 年のデータ数を返す
            case 1: // 月(2列目)の場合
                return [_months count]; // 月のデータ数を返す
        }
    }else{
        switch (component) {
            case 0: // 月(1列目)の場合
                return [_months count]; // 月のデータ数を返す
            case 1: // 年(2列目)の場合(配列と同じように0から始まる)
                return [_years count]; // 年のデータ数を返す
        }
    }
    return 0;
}
// 列×行に対応する文字列を返す
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //英語の場合は日付の表示が逆順
    if ([[self checkCurrentLanguage]isEqualToString:@"ja"]||
        [[self checkCurrentLanguage]isEqualToString:@"kr"]) {
        switch (component) {
            case 0: // 年(1列目)の場合(配列と同じように0から始まる)
                return [_years objectAtIndex:row];   // 年のデータの列に対応した文字列を返す
            case 1: // 月(2列目)の場合
                return [_months objectAtIndex:row];  // 月のデータの列に対応した文字列を返す
        }
    }else{
        switch (component) {
            case 0: // 月(1列目)の場合(配列と同じように0から始まる)
                return [_months objectAtIndex:row];   // 年のデータの列に対応した文字列を返す
            case 1: // 年(2列目)の場合
                return [_years objectAtIndex:row];  // 月のデータの列に対応した文字列を返す
        }
    }
    return nil;
}

// PickerViewの操作が行われたときに呼ばれる
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row  inComponent:(NSInteger)component {
    
    //英語の場合は日付の表示が逆順
    if ([[self checkCurrentLanguage]isEqualToString:@"ja"]||
        [[self checkCurrentLanguage]isEqualToString:@"kr"]) {
#if __LP64__
        // PickerViewの選択されている年と月の列番号を取得
        long rowOfYear  = (long)[pickerView selectedRowInComponent:0]; // 年を取得
        long rowOfMonth = (long)[pickerView selectedRowInComponent:1]; // 月を取得
        savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] integerValue];
        savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] integerValue];
#else
        // PickerViewの選択されている年と月の列番号を取得
        int rowOfYear  = (int)[pickerView selectedRowInComponent:0]; // 年を取得
        int rowOfMonth = (int)[pickerView selectedRowInComponent:1]; // 月を取得
        savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] intValue];
        savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] intValue];
#endif
        
        // ラベルに現在の日付を表示
        self.dateLabel.text = [NSString stringWithFormat:LOCALIZE(@"MenuViewController_add_past_year_month_label"),
                               [_years objectAtIndex:rowOfYear], [_months objectAtIndex:rowOfMonth]];
    }else{
#if __LP64__
        // PickerViewの選択されている年と月の列番号を取得
        long rowOfMonth = (long)[pickerView selectedRowInComponent:0]; // 月を取得
        long rowOfYear  = (long)[pickerView selectedRowInComponent:1]; // 年を取得
        savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] integerValue];
        savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] integerValue];
#else
        // PickerViewの選択されている年と月の列番号を取得
        int rowOfMonth = (int)[pickerView selectedRowInComponent:0]; // 月を取得
        int rowOfYear  = (int)[pickerView selectedRowInComponent:1]; // 年を取得
        savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] intValue];
        savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] intValue];
#endif
        
        // ラベルに現在の日付を表示
        self.dateLabel.text = [NSString stringWithFormat:LOCALIZE(@"MenuViewController_add_past_year_month_label"),
                               [_months objectAtIndex:rowOfMonth], [_years objectAtIndex:rowOfYear]];
    }
}


@end
