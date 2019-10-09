//
//  RDVCalendarView+Extension.m
//  Hakenman
//
//  Created by kjcode on 2014/11/08.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "RDVCalendarView+Extension.h"
#import "Util.h"
#import "const.h"

@implementation RDVCalendarView (Extension)

- (void)updateMonthLocalizeLabel {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = LOCALIZE(@"MonthWorkingCalendarViewController_cal_month_format");
    
    NSDate *date = [self.month.calendar dateFromComponents:self.month];
    self.monthLabel.text = [formatter stringFromDate:date];
    self.monthLabel.textColor = [UIColor colorNamed:@"calendarLabelColor"];
}

- (void)updateWeekDayLocalizeLabel {
    
    for (UILabel *l in self.weekDayLabels) {
//        NSLog(@"%@",l.text);
        
        if ([l.text isEqualToString:@"Sun"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_sunday");
        }else if ([l.text isEqualToString:@"Mon"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_monday");
        }else if ([l.text isEqualToString:@"Tue"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_tueday");
        }else if ([l.text isEqualToString:@"Wed"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_wedday");
        }else if ([l.text isEqualToString:@"Thu"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_thuday");
        }else if ([l.text isEqualToString:@"Fri"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_friday");
        }else if ([l.text isEqualToString:@"Sat"] == YES) {
            l.text = LOCALIZE(@"Common_weekday_satday");
        }
    }
}

@end
