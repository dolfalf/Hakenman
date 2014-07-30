//
//  MonthWorkingTableViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthWorkingTableViewController.h"
#import "TimeCardDao.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "NSDate+Helper.h"
#import "UIColor+Helper.h"
#import "MonthWorkingTableEditViewController.h"
#import "LeftTableViewData.h"
#import "RightTableViewData.h"
#import "TimeCard.h"
#import "Util.h"
#import <UIKit/UIDocumentInteractionController.h>

@interface MonthWorkingTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UIView *leftHeaderView;
    IBOutlet UITableView *leftTableView;
    
    IBOutlet UIView *rightHeaderView;
    IBOutlet UITableView *rightTableView;
    
    IBOutlet UIImageView *backgroundImageView;
    
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *weekDayLabel;
    IBOutlet UILabel *workingDayLabel;
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    IBOutlet UILabel *workTimeLabel;
    IBOutlet UILabel *totlaTimeLabel;
    
}

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *bigItems;
@property (nonatomic, strong) NSDate *sheetDate;

@end

@implementation MonthWorkingTableViewController

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
    
    DLog(@"%s", __FUNCTION__);
    
    //テーブルビュー更新
    [self reloadSheetDate];
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(autoSelectedCell) withObject:nil afterDelay:.1f];
    
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KJViewController override method
- (void)initControls {
    
    //viewDidLoadが呼ばれるタイミングで実行される
    
    if ([_inputDates isEqualToString:@""] == NO) {
        //ex : 20140701など
        _inputDates = [_inputDates stringByAppendingString:@"01"];
    }

    self.sheetDate = [NSDate convDate2ShortString:_inputDates];
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableViewController_navi_title"),
                  [_sheetDate getYear], [_sheetDate getMonth]];
    
    dateLabel.text = LOCALIZE(@"MonthWorkingTableViewController_date_label_text");
    weekDayLabel.text = LOCALIZE(@"MonthWorkingTableViewController_weekday_label_text");
    workingDayLabel.text = LOCALIZE(@"MonthWorkingTableViewController_workingday_label_text");
    startTimeLabel.text = LOCALIZE(@"MonthWorkingTableViewController_starttime_label_text");
    endTimeLabel.text = LOCALIZE(@"MonthWorkingTableViewController_endtime_label_text");
    workTimeLabel.text = LOCALIZE(@"MonthWorkingTableViewController_worktime_label_text");
    totlaTimeLabel.text = LOCALIZE(@"MonthWorkingTableViewController_total_label_text");
    
    
    //テーブル色指定
    leftHeaderView.backgroundColor = [UIColor lightGrayColor];
    for(UIView *vw in [leftHeaderView subviews]) {
        vw.backgroundColor = [UIColor HKMDarkblueColor];
    }
    rightHeaderView.backgroundColor = [UIColor lightGrayColor];
    for(UIView *vw in [rightHeaderView subviews]) {
        vw.backgroundColor = [UIColor HKMDarkblueColor];
    }
    
    leftTableView.backgroundColor
    = rightTableView.backgroundColor = [UIColor clearColor];
    
    leftTableView.opaque
    = rightTableView.opaque = NO;
    
    backgroundImageView.backgroundColor = [UIColor lightGrayColor];
    
}

-(void)reloadSheetDate {
    
    NSMutableDictionary *bTempDictionary = [[NSMutableDictionary alloc]init];
    
    NSNumber *leftDates = nil;
    NSNumber *leftWeeks = nil;
    
    //sheetDateからその月の最後の日を算出（何日で終わるのか）
    int lastDay = [_sheetDate getLastday];
    //sheetDateからその日の曜日を算出
    int weekDay = [_sheetDate getWeekday];
    //休日か否かを取る
    NSNumber *workFlag = [NSNumber numberWithBool:YES];
    //終わる日時にあわせて繰り返す
    
    //right
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *models = [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    
    for (int i = 1; i<=lastDay; i++) {
        
        LeftTableViewData *leftDataModel = [[LeftTableViewData alloc]init];
        RightTableViewData *rightDataModel = [[RightTableViewData alloc]init];
        
        leftDates = [NSNumber numberWithInt:i];
        leftWeeks = [NSNumber numberWithInt:weekDay];
        
        //土日は基本的に休み
        if (weekDay == weekSatDay || weekDay == weekSunday) {
            workFlag = [NSNumber numberWithBool:NO];
        }else{
            workFlag = [NSNumber numberWithBool:YES];
        }
        
        leftDataModel.yearData = [NSNumber numberWithInt:[_sheetDate getYear]];
        leftDataModel.monthData = [NSNumber numberWithInt:[_sheetDate getMonth]];
        leftDataModel.dayData = leftDates;
        leftDataModel.weekData = leftWeeks;
        leftDataModel.workFlag = workFlag;
        
//取り出した結果のデータ(資料型)  fetchとして取り出した結果
        for (TimeCard *tm in models) {
            //DBに保存されている値を日付単位で検索、表示する日付にあたる値が出るとその値をrightDataModelに入れる
            NSString *compareStringToday = [NSString stringWithFormat:@"%@%.2d%.2d", leftDataModel.yearData, [_sheetDate getMonth], i];
            NSString *compareStringCore = [NSString stringWithFormat:@"%@", tm.t_yyyymmdd];

            if ([compareStringToday isEqualToString:compareStringCore]) {
                rightDataModel.start_time = tm.start_time;
                rightDataModel.end_time = tm.end_time;
                rightDataModel.rest_time = tm.rest_time;
                rightDataModel.workday_flag = tm.workday_flag;
            }
            
        }
        //土曜日になったら、曜日表示を日曜日からやり直す
        if (weekDay == 7) {
            weekDay = 1;
        }else{
            weekDay++;
        }
        
        //左に表示すべき値と、右に表示すべき値をDictionaryとして順次で保存
        [bTempDictionary setObject:leftDataModel forKey:[NSString stringWithFormat:@"left_%d", (i-1)]];
        [bTempDictionary setObject:rightDataModel forKey:[NSString stringWithFormat:@"right_%d", (i-1)]];
    }
    
    //表示すべきテーブルに結果を入れる
    self.bigItems = [bTempDictionary mutableCopy];
    
    //テーブルの更新
    [leftTableView reloadData];
    [rightTableView reloadData];
    
}

- (void)autoSelectedCell {
    if (_fromCurruntTimeInput == YES) {
        int inputTimeToDay = [[_fromCurruntInputDates substringWithRange:NSMakeRange(6, 2)] intValue];
//        NSIndexPath *indexPath = [[NSIndexPath alloc]initWithIndexes:inputTimeToDay length:0];
        [leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:inputTimeToDay inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        [leftTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark - private methods
- (void)tableViewAlternateBackgroundColor:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)cell {
    if (indexPath.row % 2) {
        for (UIView *vw in [[[cell.contentView subviews] objectAtIndex:0] subviews]) {
            vw.backgroundColor = [UIColor HKMSkyblueColor:0.3f];
        }
        
    } else {
        for (UIView *vw in [[[cell.contentView subviews] objectAtIndex:0] subviews]) {
            vw.backgroundColor = [UIColor whiteColor];
        }
    }
}

//[tableView scrollToRowAtIndexPath:<#(NSIndexPath *)#> atScrollPosition:<#(UITableViewScrollPosition)#> animated:<#(BOOL)#>];

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"goToEdit"]) {
        MonthWorkingTableEditViewController *controller = (MonthWorkingTableEditViewController *)[segue destinationViewController];
        
        //編集画面へ遷移するとき、選んだ日のデータを編集画面へ渡す
        controller.showData = [_bigItems objectForKey:[NSString stringWithFormat:@"left_%d", _selectedIndex]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //右と左のスクロールが同時に行われるようにする（オフセットを動的に合わせる）
    if ([scrollView isEqual:rightTableView] == YES) {
        leftTableView.contentOffset = CGPointMake(leftTableView.contentOffset.x,
                                                  rightTableView.contentOffset.y);
    }else{
        rightTableView.contentOffset = CGPointMake(rightTableView.contentOffset.x,
                                                  leftTableView.contentOffset.y);
    }
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (_bigItems.count/2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LeftTableViewData *leftModel = [_bigItems objectForKey:[NSString stringWithFormat:@"left_%d", indexPath.row]];
    RightTableViewData *rightModel = [_bigItems objectForKey:[NSString stringWithFormat:@"right_%d", indexPath.row]];
    
    if ([tableView isEqual:leftTableView] == YES) {
        //左側を表示するときには、TimeCardを参照する必要がない(自分で作る必要がある)
        NSString *cellIdentifier = @"LeftTableViewCell";
        LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //background color
        [self tableViewAlternateBackgroundColor:indexPath tableViewCell:cell];
        
        //cell update.
        if ([rightModel.workday_flag isEqual:[NSNumber numberWithBool:NO]]) {
            leftModel.workFlag = [NSNumber numberWithBool:NO];
        }else if([rightModel.workday_flag isEqual:[NSNumber numberWithBool:YES]]){
            leftModel.workFlag = [NSNumber numberWithBool:YES];
        }
        
        [cell updateCell:leftModel.dayData week:leftModel.weekData isWork:leftModel.workFlag];
        
        return cell;
        
    }else if([tableView isEqual:rightTableView] == YES) {
        
        NSString *cellIdentifier = @"RightTableViewCell";
        RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //background color
        [self tableViewAlternateBackgroundColor:indexPath tableViewCell:cell];
        
        //合計時間表示部分
        NSDate *startTimeFromCore = [NSDate convDate2String:rightModel.start_time];
        NSDate *endTimeFromCore = [NSDate convDate2String:rightModel.end_time];
        float workTimeFromCore = [Util getWorkTime:startTimeFromCore endTime:endTimeFromCore] - [rightModel.rest_time floatValue];
        
        //workflagがたてている場合のみ計算するため、営業日ではない場合は０にする。
        if ([rightModel.workday_flag boolValue] == NO) {
            workTimeFromCore = 0.f;
        }
        
        //最初のセールは前のデータがないためそのまま自分のみ反映する
        if (indexPath == 0) {
            rightModel.total_time = workTimeFromCore;
        }else {
            //前のセルのデータを取得して累計を計算する
            RightTableViewData *preRightModel = [_bigItems objectForKey:[NSString stringWithFormat:@"right_%d", indexPath.row-1]];
            rightModel.total_time = preRightModel.total_time + workTimeFromCore;
        }
        
        //cell update.
        [cell updateCell:rightModel];
        
        return cell;
    }
    
    return nil;
    
}


-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:leftTableView]) {
        [rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        [leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%d table cell selected.", indexPath.row);
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"goToEdit" sender:self];

    
}

#pragma mark - IBAction delegate

-(IBAction)barButtonAction:(id)sender{
    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *models = [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    [Util sendWorkSheetCsvfile:self data:models];
}


@end
