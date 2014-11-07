//
//  MonthWorkingCalendarViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/10/25.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthWorkingCalendarViewController.h"
#import "WorkingDayCell.h"
#import "UIColor+Helper.h"
#import "NSDate+Helper.h"
#import "TimeCardDao.h"
#import "const.h"

@interface MonthWorkingCalendarViewController ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDate *sheetDate;

@end

@implementation MonthWorkingCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Calendar";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)initControls {
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    self.calendarView.separatorStyle = RDVCalendarViewDayCellSeparatorTypeHorizontal;
    self.calendarView.separatorColor = [[UIColor lightGrayColor]  colorWithAlphaComponent:0.7f];
    self.calendarView.selectedDayColor = [UIColor HKMSkyblueColor:0.7f];
    self.calendarView.currentDayColor = [[UIColor HKMSkyblueColor] colorWithAlphaComponent:0.3f];
    
    [[self calendarView] registerDayCellClass:[WorkingDayCell class]];
    
    self.calendarView.backButton.hidden
    = self.calendarView.forwardButton.hidden
    = YES;
    
    [self targetMonth];
    
    _inputDates = [_inputDates stringByAppendingString:@"01"];
    self.sheetDate = [NSDate convDate2ShortString:_inputDates];
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableViewController_navi_title"),
                  [_sheetDate getYear], [_sheetDate getMonth]];
    
    TimeCardDao *dao = [TimeCardDao new];
    self.items = [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    
}

- (void)targetMonth {
 
    //現在の月から指定した月の差を計算して逆に戻す処理。
    //情けない処理だが、月のプロパティが隠蔽されているのでしかたない。
    
    NSString *target_date = _inputDates;
    NSString* curr_date = [[NSDate date] yyyyMMString];
    
    int target_year = [[target_date substringWithRange:NSMakeRange(0, 4)] intValue];
    int target_month = [[target_date substringWithRange:NSMakeRange(4, 2)] intValue];
    
    int curr_year = [[curr_date substringWithRange:NSMakeRange(0, 4)] intValue];
    int curr_month = [[curr_date substringWithRange:NSMakeRange(4, 2)] intValue];
    
    int diff_month = ((curr_year - target_year) * 12) + (curr_month - target_month);
    
    for (int i=0; i<diff_month; i++) {
        [self.calendarView showPreviousMonth];
    }
    
}

#pragma mark - calendar delegate methods
- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    WorkingDayCell *workingDayCell = (WorkingDayCell *)dayCell;
    
    for (TimeCard *tm in _items) {
        if ((index + 1) == [tm.t_day intValue]) {
            NSLog(@"hit!!");
            
            [workingDayCell updateWorkStartTime:tm.start_time endTime:tm.end_time];
            workingDayCell.memo = ([tm.remarks isEqualToString:@""] == YES || tm.remarks == nil)?NO:YES;
            break;
        }
    }
    
    
    
}

- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index {
    [calendarView deselectDayCellAtIndex:index animated:YES];
    
    //編集画面へ遷移
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
