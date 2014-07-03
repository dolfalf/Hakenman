//
//  MonthWorkingTableEditViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/05/05.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MonthWorkingTableEditViewController.h"
#import "EditTimeTableViewCell.h"
#import "SwitchButtonTableViewCell.h"
#import "TimeCardDao.h"
#import "NSDate+Helper.h"
#import "LeftTableViewData.h"

#define TABLE_CELL_COUNT            4
#define TABLE_CELL_TEXTFIELD_TAG    500

typedef enum {
    cellTypeStartTime = 0,
    cellTypeEndTime,
    cellTypeRestTime,
    CellTypeWorkday
} CellType;

@interface MonthWorkingTableEditViewController () {
    
    IBOutlet UITableView *editTableView;
    IBOutlet UIBarButtonItem *saveBarButton;
    
    UITextField *_currentTextField;
}

@property (nonatomic, strong) EditTimeTableViewCell *editStartTimeCell;
@property (nonatomic, strong) EditTimeTableViewCell *editEndTimeCell;
@property (nonatomic, strong) EditTimeTableViewCell *editRestTimeCell;
@property (nonatomic, strong) SwitchButtonTableViewCell *editworkDayCell;

@property (nonatomic, weak) UITextField *startTimeTextField;
@property (nonatomic, weak) UITextField *endTimeTextField;
@property (nonatomic, weak) UITextField *restTimeTextField;
@property (nonatomic, strong) UITapGestureRecognizer *keyboardDismissTap;
@end

@implementation MonthWorkingTableEditViewController

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

//    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_title"),
////                  [_timeCard.t_year intValue],[_timeCard.t_month intValue],[_timeCard.t_day intValue]];
    self.title = [NSString stringWithFormat:LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_title"),
                  [_showData.yearData intValue],[_showData.monthData intValue],[_showData.dayData intValue]];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)saveAndClose:(id)sender {
    
    TimeCardDao *dao = [TimeCardDao new];
    
    if ([_startTimeTextField.text isEqualToString:@""] == NO) {
        NSArray *st = [_startTimeTextField.text componentsSeparatedByString:@":"];
        
        if (_timeCard.start_time == nil) {
//            _timeCard.start_time = [NSDate convDate2ShortString:_timeCard.t_yyyymmdd];
        }
        
//        _timeCard.start_time = [_timeCard.start_time getTimeOfMonth:[[st objectAtIndex:0] intValue]
//                                                             mimute:[[st objectAtIndex:1] intValue]];
    }
    
    if ([_endTimeTextField.text isEqualToString:@""] == NO) {
        NSArray *et = [_endTimeTextField.text componentsSeparatedByString:@":"];
        
        if (_timeCard.end_time == nil) {
//            _timeCard.end_time = [NSDate convDate2ShortString:_timeCard.t_yyyymmdd];
        }
        
//        _timeCard.end_time = [_timeCard.end_time getTimeOfMonth:[[et objectAtIndex:0] intValue]
//                                                             mimute:[[et objectAtIndex:1] intValue]];
    }
    
    if ([_restTimeTextField.text isEqualToString:@""] == NO) {
        _timeCard.rest_time = [NSNumber numberWithFloat:[_restTimeTextField.text floatValue]];
    }
    
    [dao insertModel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KJViewController override methods
- (void)initControls {
    
    saveBarButton.title = LOCALIZE(@"MonthWorkingTableEditViewController_edit_navi_save_btn");
    
    //キーボードの閉じる処理のため
    self.keyboardDismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(onKeyboardDismissTap:)];
    self.keyboardDismissTap.delegate = self;
    self.keyboardDismissTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_keyboardDismissTap];
    
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return TABLE_CELL_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == cellTypeStartTime) {
        
        NSString *cellIdentifier = @"EditTimeTableViewCell";
        self.editStartTimeCell = (EditTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!_editStartTimeCell) {
            self.editStartTimeCell = [[EditTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        _startTimeTextField = (UITextField *)[_editStartTimeCell viewWithTag:TABLE_CELL_TEXTFIELD_TAG];
        _startTimeTextField.delegate = self;
        _startTimeTextField.placeholder = LOCALIZE(@"MonthWorkingTableEditViewController_edit_placeholder");
        
        [_editStartTimeCell updateCell:LOCALIZE(@"MonthWorkingTableEditViewController_edit_start_time_cell") inputTime:_timeCard.start_time];
        
        
        
        return _editStartTimeCell;
        
    }else if(indexPath.row == cellTypeEndTime) {
        
        NSString *cellIdentifier = @"EditTimeTableViewCell";
        self.editEndTimeCell = (EditTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!_editEndTimeCell) {
            self.editEndTimeCell = [[EditTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        _endTimeTextField = (UITextField *)[_editEndTimeCell viewWithTag:TABLE_CELL_TEXTFIELD_TAG];
        _endTimeTextField.placeholder = LOCALIZE(@"MonthWorkingTableEditViewController_edit_placeholder");
        _endTimeTextField.delegate = self;
        
        [_editEndTimeCell updateCell:LOCALIZE(@"MonthWorkingTableEditViewController_edit_end_time_cell") inputTime:_timeCard.end_time];
        
        return _editEndTimeCell;
        
    }else if (indexPath.row == cellTypeRestTime) {
        
        NSString *cellIdentifier = @"EditTimeTableViewCell";
        self.editRestTimeCell = (EditTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!_editRestTimeCell) {
            self.editRestTimeCell = [[EditTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        _restTimeTextField = (UITextField *)[_editRestTimeCell viewWithTag:TABLE_CELL_TEXTFIELD_TAG];
        _restTimeTextField.placeholder = LOCALIZE(@"MonthWorkingTableEditViewController_edit_placeholder");
        _restTimeTextField.delegate = self;
        
        [_editRestTimeCell updateCell:LOCALIZE(@"MonthWorkingTableEditViewController_edit_rest_time_cell") inputTime:_timeCard.rest_time];
        return _editRestTimeCell;
        
    }else if (indexPath.row == CellTypeWorkday) {
        
        NSString *cellIdentifier = @"SwitchButtonTableViewCell";
        self.editworkDayCell = (SwitchButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!_editworkDayCell) {
            self.editworkDayCell = [[SwitchButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [_editworkDayCell updateCell:LOCALIZE(@"MonthWorkingTableEditViewController_edit_workday_switch_cell")
                           isWorkday:_timeCard.workday_flag switchHandler:^(BOOL on) {
                               //TODO: スウィッチが変更された時の処理
                           }];
        
        return _editworkDayCell;
    }
    
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"%d table cell selected.", indexPath.row);
    
}

#pragma mark - TextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TextField Returnタップ
    
    // キーボード非表示
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([_restTimeTextField isEqual:textField] == NO) {
        
        NSString *timeCheck = [textField.text stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        if ([timeCheck length] == 4 || [timeCheck length] == 0) {
            //ok
            textField.text = [NSString stringWithFormat:@"%@:%@",
                              [timeCheck substringWithRange:NSMakeRange(0,2)],
                              [timeCheck substringWithRange:NSMakeRange(2,2)]];
        }else {
            //error.
            return;
        }
    }else {
        //休憩時間編集
        if ([textField.text floatValue] > 8) {
            //error
        }
    }
    
}

-(void)onKeyboardDismissTap:(UITapGestureRecognizer *)recognizer {
    
    [_currentTextField resignFirstResponder];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer == _keyboardDismissTap) {
        // キーボード表示中のみ有効
        if (_currentTextField.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
