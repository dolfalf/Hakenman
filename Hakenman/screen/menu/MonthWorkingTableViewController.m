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
#import "MonthWorkingTableEditViewController.h"

#define TEST_MODE 0

#define LEFT_DAY @"leftDay"
#define LEFT_WEEK @"leftWeek"
#define LEFT_WORKFLAG @"leftWorkFlag"

@interface MonthWorkingTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UIView *leftHeaderView;
    IBOutlet UITableView *leftTableView;
    
    IBOutlet UIView *rightHeaderView;
    IBOutlet UITableView *rightTableView;
    
}

@property (nonatomic, assign) NSInteger selectedIndex;

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
    
    [rightTableView reloadData];
    
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

#if TEST_MODE
    //NSDate convDate2ShortStringでDateを決めるべき
    NSDate *sheetDate = [NSDate date];
#else
    _inputDates = @"20140602";
    
    //NSDate convDate2ShortStringでDateを決めるべき
    NSDate *sheetDate = [NSDate convDate2ShortString:_inputDates];

    DLog(@"[sheetDate convDate2ShortString] - %@", [NSDate convDate2ShortString:_inputDates]);
    
    NSMutableDictionary *mTempDictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray *mTempArray = [[NSMutableArray alloc]init];
    
    NSString *leftDates = @"";
    NSString *leftWeeks = @"";
    if (_items == nil) {
        DLog(@"_items is nil");
        int lastDay = [sheetDate getLastday];
        int weekDay = [sheetDate getWeekday];
        NSNumber *workFlag = [NSNumber numberWithBool:YES];    //model.workday_flagからとるべきですか?
            for (int i = 1; i<=lastDay; i++) {
                leftDates = [NSString stringWithFormat:@"%d", i];
                leftWeeks = [NSString stringWithFormat:@"%d", i];
                if (weekDay == weekSatDay && weekDay == weekSunday) {
                    workFlag = [NSNumber numberWithBool:NO];
                }else{
                    workFlag = [NSNumber numberWithBool:YES];
                }
                DLog(@"day is - %@", leftDates);
                
//            for (int i = 1; i<=lastDay; i++) {
//                _inputDates = [NSString stringWithFormat:@"%d", i];
//                DLog(@"day is - %@", _inputDates);
//                [mTempArr addObject:_inputDates];
//            }
//            _items = [mTempArr mutableCopy];
//                [mTempArray setValue:leftDates forKey:LEFT_DAY];
//                [mTempArray setValue:leftWeeks forKey:LEFT_WEEK];
//                [mTempArray setValue:workFlag forKey:LEFT_WORKFLAG];

                    [mTempDictionary setObject:leftDates forKey:LEFT_DAY];
                    [mTempDictionary setObject:leftWeeks forKey:LEFT_WEEK];
                    [mTempDictionary setObject:workFlag forKey:LEFT_WORKFLAG];
                
//                for (<#type *object#> in <#collection#>) {
//                    <#statements#>
//                }
                    [mTempArray addObject:mTempDictionary];
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
#endif
    
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableViewController_navi_title"),
                  [sheetDate getYear], [sheetDate getMonth]];
    


#if TEST_MODE
    NSMutableArray *mTempArr = [[NSMutableArray alloc]init];
    
    if (_items == nil) {
        DLog(@"_items is nil");
        int lastDay = [sheetDate getLastday];
        if(_inputDates == nil){
            _inputDates = [NSString stringWithFormat:@"%04d%02d01", [sheetDate getYear], [sheetDate getMonth]];
            DLog(@"[sheetDate convDate2ShortString] - %@", [NSDate convDate2ShortString:_inputDates]);
//            
//            for (int i = 1; i<=lastDay; i++) {
//                _inputDates = [NSString stringWithFormat:@"%d", i];
//                DLog(@"day is - %@", _inputDates);
//                [mTempArr addObject:_inputDates];
//            }
//            _items = [mTempArr mutableCopy];
        }
        
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
#endif
//    self.title = [NSString stringWithFormat:@"%d%d",
//                  [sheetDate getYear], [sheetDate getMonth]];

    //coreDataに今月カレンダーが存在しているかどうかをチェック
    //新しい今月カレンダーを作成
    //今月カレンダーをロードしテーブルを更新
    TimeCardDao *dao = [TimeCardDao new];
    [dao insertModelWorkSheet:[NSDate date]];
    
}

#pragma mark - private methods

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"goToEdit"]) {
        MonthWorkingTableEditViewController *controller = (MonthWorkingTableEditViewController *)[segue destinationViewController];
        
        controller.timeCard = [_items objectAtIndex:_selectedIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:rightTableView] == YES) {
        leftTableView.contentOffset = CGPointMake(leftTableView.contentOffset.x,
                                                  rightTableView.contentOffset.y);
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
    
//    TimeCard *model = [_items objectAtIndex:indexPath.row];
    NSArray *showArr = [_items objectAtIndex:indexPath.row];
    
    if ([tableView isEqual:leftTableView] == YES) {
        //左側を表示するときには、TimeCardを参照する必要がない(自分で作る必要がある)
        NSString *cellIdentifier = @"LeftTableViewCell";
        LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //cell update.

        [cell updateCell:[showArr valueForKey:LEFT_DAY] week:[showArr valueForKey:LEFT_WEEK] isWork:[showArr valueForKey:LEFT_WORKFLAG]];
//        [cell updateCell:model.t_day week:model.t_week isWork:model.workday_flag];
        
        return cell;
        
    }else if([tableView isEqual:rightTableView] == YES) {
        NSString *cellIdentifier = @"RightTableViewCell";
        RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //cell update.
//        [cell updateCell:model];
        
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
