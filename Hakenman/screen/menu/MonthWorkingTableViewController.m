//
//  MonthWorkingTableViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
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

@interface MonthWorkingTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UIView *leftHeaderView;
    IBOutlet UITableView *leftTableView;
    
    IBOutlet UIView *rightHeaderView;
    IBOutlet UITableView *rightTableView;
    
    IBOutlet UIImageView *backgroundImageView;
}

@property (nonatomic, assign) NSInteger selectedIndex;
//@property (nonatomic, strong) NSArray *rightItems;
@property (nonatomic, strong) NSMutableDictionary *rightItems;

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
    [leftTableView reloadData];
    [rightTableView reloadData];
    [self reloadSheetDate];
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KJViewController override method
- (void)initControls {
    //viewDidLoadで実行される

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
    
    //TODO:イメージに差し替え予定
    backgroundImageView.backgroundColor = [UIColor lightGrayColor];
    [self reloadSheetDate];
}

-(void)reloadSheetDate{
    //選択された月の語尾に@"01"をつけて、その月の表示のための形に変更する
    if ([_inputDates isEqualToString:@""] == NO) {
        //20140701
        _inputDates = [_inputDates stringByAppendingString:@"01"];
    }
    
    //NSDate convDate2ShortStringでDateを決めるべき（なおった？）
    NSDate *sheetDate = [NSDate convDate2ShortString:_inputDates];
    
    //sheetDateで受け取った値は正常に受け取るのに、ログで表示するときだけ変に出る
    DLog(@"[sheetDate convDate2ShortString] - %@", [NSDate convDate2ShortString:_inputDates]);
    
    //任意のArrayに３０日までの値を格納
    NSMutableArray *mTempArray = [[NSMutableArray alloc]init];
    
    //create right item
    self.rightItems = [NSMutableDictionary new];
    
    NSNumber *leftDates;
    NSNumber *leftWeeks;
    if (_items == nil) {
        //sheetDateからその月の最後の日を算出（何日で終わるのか）
        int lastDay = [sheetDate getLastday];
        //sheetDateからその日の曜日を算出
        int weekDay = [sheetDate getWeekday];
        //休日か否かを取る
        NSNumber *workFlag = [NSNumber numberWithBool:YES];
        //終わる日時にあわせて繰り返す
        for (int i = 1; i<=lastDay; i++) {
            
            LeftTableViewData *leftDataModel = [[LeftTableViewData alloc]init];
            
            leftDates = [NSNumber numberWithInt:i];
            leftWeeks = [NSNumber numberWithInt:weekDay];
            //土日は基本的に休み
            if (weekDay == weekSatDay || weekDay == weekSunday) {
                workFlag = [NSNumber numberWithBool:NO];
            }else{
                workFlag = [NSNumber numberWithBool:YES];
            }
            
            leftDataModel.yearData = [NSNumber numberWithInt:[sheetDate getYear]];
            leftDataModel.monthData = [NSNumber numberWithInt:[sheetDate getMonth]];
            leftDataModel.dayData = leftDates;
            leftDataModel.weekData = leftWeeks;
            leftDataModel.workFlag = workFlag;
            
            [mTempArray addObject:leftDataModel];
            
            //土曜日になったら、曜日表示を日曜日からやり直す
            if (weekDay == 7) {
                weekDay = 1;
            }else{
                weekDay++;
            }
            
            //right
            RightTableViewData *rMOdel = [RightTableViewData new];
            [_rightItems setObject:rMOdel forKey:[sheetDate yyyyMMddString]];
            
        }
        _items = [mTempArray mutableCopy];
        
        
        
        
        DLog(@"[sheetDate getYear] - %d", [sheetDate getYear]);
        DLog(@"[sheetDate getMonth] - %d", [sheetDate getMonth]);
        DLog(@"[sheetDate getDay] - %d", [sheetDate getDay]);
        DLog(@"[sheetDate getWeekday] - %d", [sheetDate getWeekday]);
        DLog(@"[sheetDate getLastday] - %d", [sheetDate getLastday]);
        DLog(@"[sheetDate getHour] - %d", [sheetDate getHour]);
        DLog(@"[sheetDate getBeginOfMonth] - %@", [sheetDate getBeginOfMonth]);
        DLog(@"[sheetDate getEndOfMonth] - %@", [sheetDate getEndOfMonth]);
        DLog(@"[sheetDate getDayOfMonth] - %@", [sheetDate getDayOfMonth:[sheetDate getDay]]);
    }
    
    //right
    TimeCardDao *dao = [TimeCardDao new];
    NSArray *models = [dao fetchModelYear:[sheetDate getYear] month:[sheetDate getMonth]];
    
    for (TimeCard *tm in models) {
        RightTableViewData *rMOdel = [_rightItems objectForKey:[tm.t_yyyymmdd stringValue]];
        
        rMOdel.start_time = tm.start_time;
        rMOdel.end_time = tm.end_time;
        
    }
    
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableViewController_navi_title"),
                  [sheetDate getYear], [sheetDate getMonth]];
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"goToEdit"]) {
        MonthWorkingTableEditViewController *controller = (MonthWorkingTableEditViewController *)[segue destinationViewController];
        
        //編集画面へ遷移するとき、選んだ日のデータを編集画面へ渡す
        controller.showData = [_items objectAtIndex:_selectedIndex];
        if (_rightItems.count != 0) {
//            controller.timeCard = [_rightItems objectAtIndex:_selectedIndex];
        }
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    //get
//    NSDictionary *dic = [_arr objectAtIndex:indexPath.row];
//    
//    LeftTableViewData *left_item = [dic objectForKey:@"leftdata"];
//    RightTableViewData *rignt_item = [dic objectForKey:@"rightdata"];
//    
//    
//    //set
//    NSDictionary *dic = [_arr objectAtIndex:indexPath.row];
    
    
    
    LeftTableViewData *leftModel = [_items objectAtIndex:indexPath.row];
//    RightTableViewData *rightModel = [_rightItems obj];
    
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
//        if ([rightModel.workday_flag isEqual:[NSNumber numberWithBool:NO]]) {
//            leftModel.workFlag = [NSNumber numberWithBool:NO];
//        }else if([rightModel.workday_flag isEqual:[NSNumber numberWithBool:YES]]){
//            leftModel.workFlag = [NSNumber numberWithBool:YES];
//        }
        
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
        
        //cell update.
//        [cell updateCell:rightModel];
        
        return cell;
    }

    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%d table cell selected.", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"goToEdit" sender:self];

    
}

@end
