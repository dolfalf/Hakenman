//
//  HistoryEditViewController.m
//  Hakenman
//
//  Created by kjcode on 2015/02/18.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#import "HistoryEditViewController.h"

#import "MenuViewController.h"
#import "UIColor+Helper.h"
#import "NSDate+Helper.h"
#import "TimeCardDao.h"
#import "TimeCardSummaryDao.h"
#import "MonthWorkingTableViewController.h"
#import "AdvertisingManager.h"
#import "UIFont+Helper.h"
#import "Util.h"

#define START_YEAR 2014     // PickerViewの最初の年

@interface HistoryEditViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>{
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

@property (nonatomic, weak) IBOutlet UIView *topContainerView;
@property (nonatomic, weak) IBOutlet UIView *pickerContainerView;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *structureTopBannerView;
@property (nonatomic, weak) IBOutlet UIView *structureBottomBannerView;

@end

@implementation HistoryEditViewController

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
    [self initYearMonth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    if (_editType == HistoryEditTypeAdd) {
        self.title = LOCALIZE(@"HistoryEditViewController_title_add");
        _descLabel.text = LOCALIZE(@"HistoryEditViewController_add_desc_message");
    }else if(_editType == HistoryEditTypeRemove) {
        self.title = LOCALIZE(@"HistoryEditViewController_title_remove");
        _descLabel.text = LOCALIZE(@"HistoryEditViewController_remove_desc_message");
    }else {
        self.title = @"";
        _descLabel.text = @"";
    }
    self.navigationItem.leftBarButtonItem.title = LOCALIZE(@"Common_navigation_closebutton_title");
    self.navigationItem.rightBarButtonItem.title = LOCALIZE(@"Common_navigation_savebutton_title");
    HKM_INIT_LABLE(_descLabel, HKMFontTypeNanum, _descLabel.font.pointSize);

    //AD Banner.
    AdvertisingManager *mgr = [AdvertisingManager sharedADBannerView];
    [_structureTopBannerView addSubview:[mgr getADBannerView:AdViewTypeGAd]];
    [_structureBottomBannerView addSubview:[mgr getADBannerView:AdViewTypeIAd]];
    
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
    }else{
        [self.pickerView selectRow:rowOfTodayMonth inComponent:0 animated:YES];
        [self.pickerView selectRow:rowOfTodayYear inComponent:1 animated:YES];
        
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onCheckAlert:(id)sender{
    
    NSString *message = nil;
    
    if (_editType == HistoryEditTypeAdd) {
        message = LOCALIZE(@"Common_alert_add_sheet_message");
    }else if(_editType == HistoryEditTypeRemove) {
        message = LOCALIZE(@"Common_alert_remove_message");
    }
    
    if (IOS8) {
        //iOS8
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert setTitle:@""];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_no")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 
                                                             }];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_yes")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self _saveThePast];
                                                         }];
        
        [alert addAction:actionCancel];
        [alert addAction:actionOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //before iOS7
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZE(@"Common_alert_button_no")
                                              otherButtonTitles:LOCALIZE(@"Common_alert_button_yes"), nil];
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

#pragma mark - picker helper methods
//- (UILabel *)pickerYearLabel:(NSString *)text {
//
//    NSDictionary *valueAttribute = @{ NSForegroundColorAttributeName:[UIColor blackColor],
//                                      NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
//
//    NSAttributedString *valueString = [[NSAttributedString alloc] initWithString:text
//                                                                      attributes: valueAttribute];
//
//
//    NSDictionary *unitAttribute = @{ NSForegroundColorAttributeName:[UIColor lightGrayColor],
//                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f] };
//    NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:@"年"
//                                                                     attributes:unitAttribute];
//
//
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
//
//    [mutableAttributedString appendAttributedString:valueString];
//    [mutableAttributedString appendAttributedString:unitString];
//
//    //라벨에 텍스트를 설정
//    UILabel *lbl = [UILabel alloc] initWithFrame:CGRectMake(0, 0, 24*4.f, 70.f);
//    lbl.attributedText = mutableAttributedString;
//}

//- (UILabel *)pickerMonthLabel:(NSString *)text {
//
//    NSDictionary *valueAttribute = @{ NSForegroundColorAttributeName:[UIColor blackColor],
//                                      NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
//
//    NSAttributedString *valueString = [[NSAttributedString alloc] initWithString:@"1234"
//                                                                      attributes: valueAttribute];
//
//
//    NSDictionary *unitAttribute = @{ NSForegroundColorAttributeName:[UIColor lightGrayColor],
//                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f] };
//    NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:@"km"
//                                                                     attributes:unitAttribute];
//
//
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
//    [mutableAttributedString appendAttributedString:string1];
//    [mutableAttributedString appendAttributedString:string2];
//
//    //라벨에 텍스트를 설정
//    _label.attributedText = mutableAttributedString;
//}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    float width = 30.f;
    
    switch (component) {
        case 0:
            width = width*4.f;
            break;
        case 1:
            width = width;
            break;
        case 2:
            width = width*2.f;
            break;
    }
    
    
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 80.f;
}

// 列数を返す
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    // 年と月を表示するので2列を指定
    return 3;
}

// 各列に対する、行数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    switch (component) {
        case 0: // 年(1列目)の場合(配列と同じように0から始まる)
            return [_years count];   // 年のデータ数を返す
        case 1:
            return 1;
        case 2: // 月(2列目)の場合
            return [_months count]; // 月のデータ数を返す
    }
    
    return 0;
}

#if 0
// 列×行に対応する文字列を返す
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    switch (component) {
        case 0: // 年(1列目)の場合(配列と同じように0から始まる)
            return [_years objectAtIndex:row];   // 年のデータの列に対応した文字列を返す
        case 1:
            return 1;
        case 2: // 月(2列目)の場合
            return [_months objectAtIndex:row];  // 月のデータの列に対応した文字列を返す
    }
    
    return nil;
}

#endif

#if 1
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    float width = 30.f;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                             width,
                                                             80.f)];
    
    lbl.font = [UIFont nanumFontOfSize:48.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    
    //debug code.
    lbl.backgroundColor = [UIColor clearColor];
    
    switch (component) {
        case 0: // 年(1列目)の場合(配列と同じように0から始まる)
        {
            // 年のデータの列に対応した文字列を返す
            lbl.frame = CGRectMake(0, 0, width*4.f, 80.f);
            lbl.text = [_years objectAtIndex:row];
            break;
        }
        case 1:
            lbl.frame = CGRectMake(0, 0, width, 80.f);
            lbl.text = @"/";
            break;
            
        case 2: // 月(3列目)の場合
        {
            // 月のデータの列に対応した文字列を返す
            lbl.frame = CGRectMake(0, 0, width*2.f, 80.f);
            lbl.text = [_months objectAtIndex:row];
            break;
        }
    }
    
    return lbl;
    
}

#endif

// PickerViewの操作が行われたときに呼ばれる
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row  inComponent:(NSInteger)component {
    
#if __LP64__
    // PickerViewの選択されている年と月の列番号を取得
    long rowOfYear  = (long)[pickerView selectedRowInComponent:0]; // 年を取得
    long rowOfMonth = (long)[pickerView selectedRowInComponent:2]; // 月を取得
    savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] integerValue];
    savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] integerValue];
#else
    // PickerViewの選択されている年と月の列番号を取得
    int rowOfYear  = (int)[pickerView selectedRowInComponent:0]; // 年を取得
    int rowOfMonth = (int)[pickerView selectedRowInComponent:2]; // 月を取得
    savePastYear = [[NSString stringWithFormat:@"%@", [_years objectAtIndex:rowOfYear]] intValue];
    savePastMonth = [[NSString stringWithFormat:@"%@", [_months objectAtIndex:rowOfMonth]] intValue];
#endif
        
}

@end
