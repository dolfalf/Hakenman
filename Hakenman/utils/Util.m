//
//  Util.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/29.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//


#import "Util.h"


#import "const.h"
#import "NSDate+Helper.h"
#import "UIColor+Helper.h"
#import "NSUserDefaults+Setting.h"
#import "NSError+Common.h"

@implementation Util

+ (BOOL)isJanpaneseLanguage {
    
    //選択可能な言語設定の配列を取得
    NSArray *langs = [NSLocale preferredLanguages];
    
    //取得した配列から先頭の文字列を取得（先頭が現在の設定言語）
    NSString *currentLanguage = [langs objectAtIndex:0];
    
    if([currentLanguage compare:@"ja"] == NSOrderedSame) {
        //日本語の場合の処理
        return YES;
        
    }else {
        return NO;
    }
    
    return NO;
}

+ (BOOL)is3_5inch {
    
    CGSize r = [[UIScreen mainScreen] bounds].size;
    if(r.height == 480){
        //3.5inch
        return YES;
    }else{
        //4inch
        return NO;
    }
}

+ (int)iOSVersion {
    UIDevice *device = [UIDevice currentDevice];
    
    return (int)[device.systemVersion floatValue] * 1000;
}

+ (NSString *)getDocumentPath {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories lastObject];
    DLog(@"%@", documentDirectory);
    
    return documentDirectory;
}

+ (NSString *)weekdayString:(int)weekday {
    //1 = Sunday, 2 = Monday, etc.

    NSString *weekString = nil;

    switch (weekday) {
        case weekSunday:
            weekString = LOCALIZE(@"Common_weekday_sunday");
            break;
        case weekMonday:
            weekString = LOCALIZE(@"Common_weekday_monday");
            break;
        case weekTueDay:
            weekString = LOCALIZE(@"Common_weekday_tueday");
            break;
        case weekWedDay:
            weekString = LOCALIZE(@"Common_weekday_wedday");
            break;
        case weekThuDay:
            weekString = LOCALIZE(@"Common_weekday_thuday");
            break;
        case weekFriDay:
            weekString = LOCALIZE(@"Common_weekday_friday");
            break;
        case weekSatDay:
            weekString = LOCALIZE(@"Common_weekday_satday");
            break;
        default:
            break;
    }
    
    return weekString;
}

+ (NSString *)weekdayString2:(int)weekday {
    
    //1 = Sunday, 2 = Monday, etc.
    
    NSString *weekString = nil;
    
    switch (weekday) {
        case weekSunday:
            weekString = LOCALIZE(@"Common_weekday2_sunday");
            break;
        case weekMonday:
            weekString = LOCALIZE(@"Common_weekday2_monday");
            break;
        case weekTueDay:
            weekString = LOCALIZE(@"Common_weekday2_tueday");
            break;
        case weekWedDay:
            weekString = LOCALIZE(@"Common_weekday2_wedday");
            break;
        case weekThuDay:
            weekString = LOCALIZE(@"Common_weekday2_thuday");
            break;
        case weekFriDay:
            weekString = LOCALIZE(@"Common_weekday2_friday");
            break;
        case weekSatDay:
            weekString = LOCALIZE(@"Common_weekday2_satday");
            break;
        default:
            break;
    }
    
    return weekString;
}

+ (NSString *)worktimeString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%02d:%02d",[dt getHour],[dt getMinuite]];
}

+ (NSString *)weekStatusDayString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd";
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dt];
    DLog(@"%@", formattedDateString);
    
    return formattedDateString;
    
}

+ (NSString *)weekStatusTimeString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dt];
//    DLog(@"%@", formattedDateString);
    
    return formattedDateString;
}

+ (NSString *)eventTimeString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dt];
    DLog(@"%@", formattedDateString);
    
    return formattedDateString;
    
}

+ (float)getWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    
    //start_time & end_time 語尾の桁数を００に変換
    
    //合計時間の計算のため秒単位の語尾を「00」に固定
    NSString *startStr = [startTime yyyyMMddHHmmssString];
    startStr = [startStr stringByReplacingCharactersInRange:(NSMakeRange(12, 2)) withString:@"00"];
    NSDate *convertStart = [NSDate convDate2String:startStr];
    
    NSString *endStr = [endTime yyyyMMddHHmmssString];
    endStr = [endStr stringByReplacingCharactersInRange:(NSMakeRange(12, 2)) withString:@"00"];
    NSDate *convertEnd = [NSDate convDate2String:endStr];
    
	NSTimeInterval since = [convertEnd timeIntervalSinceDate:convertStart];
    
    float resultSince1 = since/(60.f*60.f);
    float resultSince2 = resultSince1 * 100.f;
    float resultSince3 = ceilf(resultSince2);
    float resultSince4 = resultSince3/100.f;
    return resultSince4;
    
}

+ (NSString *)correctWorktime:(NSString *)yyyymmddHHmmss {
    
    NSString *minute = [yyyymmddHHmmss substringWithRange:NSMakeRange(10, 2)];
    NSString *currentMinute = @"00";
    
    switch ([NSUserDefaults timeKubun]) {
        case 0:
            //0
            //なにもしない
            currentMinute = minute;
            break;
        case 1:
            //10分単位
        {
            currentMinute = [NSString stringWithFormat:@"%02d",((int)[minute integerValue]/10)*10];
        }
            break;
        case 2:
            //15分単位
        {
            currentMinute = [NSString stringWithFormat:@"%02d",((int)[minute integerValue]/15)*15];
        }
            break;
        case 3:
            //30分単位
            currentMinute = [NSString stringWithFormat:@"%02d",((int)[minute integerValue]/30)*30];
            break;
    }
    
//    NSString *aa = [yyyymmddHHmmss substringWithRange:NSMakeRange(0, 9)];
//    NSString *bb = [yyyymmddHHmmss substringWithRange:NSMakeRange(12, 2)];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@"
            ,[yyyymmddHHmmss substringWithRange:NSMakeRange(0, 10)]
            ,currentMinute
            ,[yyyymmddHHmmss substringWithRange:NSMakeRange(12, 2)]];
    
    
    return str;
    
}

+ (NSArray *)worktimePickList {
    
    return @[LOCALIZE(@"SettingViewController_worktime_picker_none"),
                                  LOCALIZE(@"SettingViewController_worktime_picker_10"),
                                  LOCALIZE(@"SettingViewController_worktime_picker_15"),
                                  LOCALIZE(@"SettingViewController_worktime_picker_30")];
}

+ (NSInteger)worktimeKubun:(NSString *)pickString {
    
    NSInteger kubun = 0;
    if ([pickString isEqualToString:LOCALIZE(@"SettingViewController_worktime_picker_none")] == YES) {
        kubun = 0;
    }else if ([pickString isEqualToString:LOCALIZE(@"SettingViewController_worktime_picker_10")] == YES) {
        kubun = 1;
    }else if ([pickString isEqualToString:LOCALIZE(@"SettingViewController_worktime_picker_15")] == YES) {
        kubun = 2;
    }else if ([pickString isEqualToString:LOCALIZE(@"SettingViewController_worktime_picker_30")] == YES) {
        kubun = 3;
    }

    return kubun;
}

+ (NSArray *)displayWorkSheetList {
    return @[LOCALIZE(@"SettingViewController_last_worksheet_display_all"),
                                   LOCALIZE(@"SettingViewController_last_worksheet_display_oneyear"),
                                   LOCALIZE(@"SettingViewController_last_worksheet_display_sixmonth")];
}

+ (NSInteger)displayWorkSheetIndex:(NSString *)optionString {
    
    NSInteger index = 0;
    if ([optionString isEqualToString:LOCALIZE(@"SettingViewController_last_worksheet_display_all")] == YES) {
        index = 0;
    }else if ([optionString isEqualToString:LOCALIZE(@"SettingViewController_last_worksheet_display_oneyear")] == YES) {
        index = 1;
    }else if ([optionString isEqualToString:LOCALIZE(@"SettingViewController_last_worksheet_display_sixmonth")] == YES) {
        index = 2;
    }
    
    return index;
    
}

+ (NSArray *)reportTitleList {
    return @[LOCALIZE(@"SettingViewController_work_report_title_templete1"),
             LOCALIZE(@"SettingViewController_work_report_title_templete2")];
}

//+ (NSString* )exportCSVString:(NSArray*)sources error:(NSError **)error {
//    
//    
//    if (sources == nil || [sources count] == 0) {
//        *error = [NSError errorWithHKMErrorCode:HKMErrorCodeNoDataError localizedDescription:LOCALIZE(@"")];
//        return nil;
//    }
//    
//    NSDateFormatter* f = [[NSDateFormatter alloc] init];
//    [f setDateFormat:@"yyyy-MM-dd"];
//    
//    // 1行目だけ先に追加
//    NSMutableArray* all = [@[@"date,work_starttime ,work_endtime,rest_time"] mutableCopy];
//    
//    // データを降順にソート
//    NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
//    sources = [sources sortedArrayUsingDescriptors:@[desc]];
//    
//    
//
//    // カンマ区切りで追加
//    for (NSInteger i=0; i<sources.count; i++) {
//        TimeCard* model = [sources objectAtIndex:i];
//        NSArray* adding = @[model.t_yyyymmdd, model.start_time, model.end_time, model.rest_time];
//        NSString* str = [adding componentsJoinedByString:@","];
//        [all addObject:str];
//    }
//    // CRLFで区切ったNSStringを返す
//    return [all componentsJoinedByString:@"\r\n"];
//}

//+ (void)sendMailWorkSheet:(id)owner append:(NSArray *)worksheets {
//
//    // メールを利用できるかチェック
//    if (![MFMailComposeViewController canSendMail]) {
//        return;
//    }
//    
//    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
//    [controller setMailComposeDelegate:owner];
//    
//    if ([worksheets count] > 0) {
//        // 取得したNSStringをNSdataに変換
//        NSData* data = [[self exportCSVString:worksheets] dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *prefix = [[((TimeCard *)[worksheets objectAtIndex:0]).t_yyyymmdd stringValue] substringWithRange:NSMakeRange(0, 6)];
//        // mimeTypeはtext/csv
//        [controller addAttachmentData:data mimeType:@"text/csv" fileName:[self generateCSVFilename:prefix]];
//        
//        // 表示
//        [((KJViewController *)owner).navigationController presentViewController:controller animated:YES completion:nil];
//    }else {
//        DLog(@"生成するCSVデータがない");
//        return;
//    }
//    
//}

+ (BOOL)olderThanVersion:(NSString *)ver {
    
    //version1.0.2->102にして比較
    NSArray *v_arrays = [ver componentsSeparatedByString:@"."];
    if ([v_arrays count] == 3) {
        int num_ver = [v_arrays[0] intValue] * 100
        + [v_arrays[1] intValue] * 10
        + [v_arrays[2] intValue] * 1;
        
        NSArray *c_arrays = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]componentsSeparatedByString:@"."];
        
        int curr_num_ver = [c_arrays[0] intValue] * 100
        + [c_arrays[1] intValue] * 10
        + [c_arrays[2] intValue] * 1;
        
        DLog(@"check version:[%d], current version[%d]", num_ver, curr_num_ver);
        if (num_ver > curr_num_ver) {
            return YES;
        }
    }
    
    return NO;
}

@end
