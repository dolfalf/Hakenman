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
#import "Util+Document.h"
#import "RDVCalendarView+Extension.h"
#import "MonthWorkingTableEditViewController.h"
#import "LeftTableViewData.h"
#import "UIFont+Helper.h"

@interface MonthWorkingCalendarViewController ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDate *sheetDate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UILabel *summaryLabel;
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

#pragma mark - life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControls];
}

- (void)viewWillAppear:(BOOL)animated {

    
    [self reloadCalendarData];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)initControls {
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(rightBarButtonTouched:)];
    
    self.navigationItem.rightBarButtonItems = @[rightButton];
    
    self.calendarView.separatorStyle = RDVCalendarViewDayCellSeparatorTypeHorizontal;
    self.calendarView.separatorColor = [[UIColor lightGrayColor]  colorWithAlphaComponent:0.7f];
    self.calendarView.selectedDayColor = [UIColor HKMSkyblueColor:0.7f];
    self.calendarView.currentDayColor = [[UIColor HKMOrangeColor] colorWithAlphaComponent:0.3f];
    
    [[self calendarView] registerDayCellClass:[WorkingDayCell class]];
    
    self.calendarView.backButton.hidden
    = self.calendarView.forwardButton.hidden
    = YES;
    
    [self targetMonth];
    
    _inputDates = [_inputDates stringByAppendingString:@"01"];
    self.sheetDate = [NSDate convDate2ShortString:_inputDates];
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableViewController_navi_title"),
                  [_sheetDate getYear], [_sheetDate getMonth]];

    //Localize Label
    [self.calendarView updateMonthLocalizeLabel];
    [self.calendarView updateWeekDayLocalizeLabel];
    
}

- (void)summaryLabelWorkTime {
    
//    if ([Util is3_5inch] == YES) {
//        //3.5inchの場合非表示する
//        return;
//    }
    
    float wTime = [self calendarTotalWorkTime];
    
    if (_summaryLabel == nil) {
        float margin = 16.f;
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,
                                                                      self.calendarView.frame.size.height -44.f - 15.f,
                                                                      self.calendarView.frame.size.width - (margin*2),
                                                                      12.f)];
        HKM_INIT_LABLE(_summaryLabel, HKMFontTypeNanum, 12.f);
        _summaryLabel.textAlignment = NSTextAlignmentRight;
        [self.calendarView addSubview:_summaryLabel];
    }

    NSArray *textString = [LOCALIZE(@"MonthWorkingCalendarViewController_total_work_time") componentsSeparatedByString:@"*"];
    
    NSDictionary *textAttr = @{ NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                         NSFontAttributeName:[UIFont systemFontOfSize:12.f]};
    
    NSAttributedString *text1 = [[NSAttributedString alloc] initWithString:[textString objectAtIndex:0]
                                                                attributes:textAttr];

    NSAttributedString *text2 = [[NSAttributedString alloc] initWithString:[textString objectAtIndex:1]
                                                                attributes:textAttr];
    
    
    NSDictionary *numberAttr = @{ NSForegroundColorAttributeName : [UIColor HKMOrangeColor],
                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:12.f]};
    
    NSAttributedString *hourString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)wTime]
                                                                     attributes:numberAttr];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    [mutableAttributedString appendAttributedString:text1];
    [mutableAttributedString appendAttributedString:hourString];
    [mutableAttributedString appendAttributedString:text2];
    
    _summaryLabel.attributedText = mutableAttributedString;
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

- (void)reloadCalendarData {
    TimeCardDao *dao = [TimeCardDao new];
    self.items = [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    
    //REMARK: 総勤務時間、総勤務日を表示ビュー
    [self summaryLabelWorkTime];
    
    [self.calendarView reloadData];
}

- (float)calendarTotalWorkTime {
    
    //MARK:累計計算メソッド
    float display_total_time = 0.f;
    
    
    for (TimeCard *tm in _items) {
        
        NSDate *startTimeFromCore = [NSDate convDate2String:tm.start_time];
        NSDate *endTimeFromCore = [NSDate convDate2String:tm.end_time];
        float workTimeFromCore = [Util getWorkTime:startTimeFromCore endTime:endTimeFromCore] - [tm.rest_time floatValue];
        
        if (tm.start_time == nil || [tm.start_time isEqualToString:@""] == YES
            || tm.end_time == nil || [tm.end_time isEqualToString:@""] == YES) {
            continue;
        }
        
        if ([tm.workday_flag boolValue] == NO) {
            workTimeFromCore = 0.f;
        }
        
        display_total_time = display_total_time + workTimeFromCore;
    }
    
    return display_total_time;
    
}

#pragma mark - BarButton Action
-(void)rightBarButtonTouched:(id)sender {

    TimeCardDao *dao = [TimeCardDao new];
    
    NSArray *models = [dao fetchModelForCSVWithYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    
//    [dao fetchModelYear:[_sheetDate getYear] month:[_sheetDate getMonth]];
    [Util sendWorkSheetCsvfile:self data:models];
}

#pragma mark - calendar delegate methods
- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    WorkingDayCell *workingDayCell = (WorkingDayCell *)dayCell;
    
    for (TimeCard *tm in _items) {
        if ((index + 1) == [tm.t_day intValue]) {
            
            workingDayCell.workday = [tm.workday_flag boolValue];
            
            [workingDayCell updateWorkStartTime:tm.start_time endTime:tm.end_time];
            workingDayCell.memo = ([tm.remarks isEqualToString:@""] == YES || tm.remarks == nil)?NO:YES;
            
            break;
        }
    }
    
    
    
}

- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index {
    [calendarView deselectDayCellAtIndex:index animated:YES];
    
    __typeof (self) __weak weakSelf = self;
    
    _selectedIndex = index;
    
    //編集画面へ遷移
    [StoryboardUtil gotoMonthWorkingTableEditViewController:self completion:^(id controller) {
        
//        TimeCard *tm = [_items objectAtIndex:_selectedIndex];
        
        //param
        LeftTableViewData *param = [LeftTableViewData new];
        
        param.yearData = @([weakSelf.sheetDate getYear]);
        param.monthData = @([weakSelf.sheetDate getMonth]);
        param.dayData = @((int)index + 1);
        param.weekData = @([weakSelf.sheetDate getWeekday]);
        param.workFlag = @(([weakSelf.sheetDate getWeekday] == weekSatDay || [weakSelf.sheetDate getWeekday] == weekSunday)?NO:YES);
        
        ((MonthWorkingTableEditViewController *)controller).showData = param;
    }];
    
}


@end
