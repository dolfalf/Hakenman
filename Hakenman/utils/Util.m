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
#import <MessageUI/MessageUI.h>
#import "KJViewController.h"
#import "TimeCard.h"
#import <UIKit/UIDocumentInteractionController.h>
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
    NSLog(@"%@", formattedDateString);
    
    return formattedDateString;
    
}

+ (NSString *)weekStatusTimeString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dt];
    NSLog(@"%@", formattedDateString);
    
    return formattedDateString;
}

+ (NSString *)eventTimeString:(NSDate *)dt {
    
    if (dt == nil) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dt];
    NSLog(@"%@", formattedDateString);
    
    return formattedDateString;
    
}

+ (float)getWorkTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    
	NSTimeInterval since = [endTime timeIntervalSinceDate:startTime];
    
    return since/(60.f*60.f);
    
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
            currentMinute = [NSString stringWithFormat:@"%02d",([minute integerValue]/10)*10];
        }
            break;
        case 2:
            //15分単位
        {
            currentMinute = [NSString stringWithFormat:@"%02d",([minute integerValue]/15)*15];
        }
            break;
        case 3:
            //30分単位
            currentMinute = [NSString stringWithFormat:@"%02d",([minute integerValue]/30)*30];
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

+ (NSString *)generateCSVFilename:(NSString *)prefix {
    
    return [NSString stringWithFormat:@"%@_%@.csv",prefix, [[NSDate date] yyyyMMddHHmmssString]];
}

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

+ (void)sendReportMailWorkSheet:(id)owner subject:(NSString *)subject toRecipient:(NSString *)toRecipient messageBody:(NSString *)body {
    
    // メールを利用できるかチェック
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    //navigation textColor
    //色の変更ができなかった。appleの仕様らしい。
    //controller.navigationController.navigationBar.barTintColor = [UIColor HKMBlueColor];
    [UINavigationBar appearance].tintColor = [UIColor HKMBlueColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:owner];
    
    
    //subject
    [ controller setSubject:subject];
    //to
    [ controller setToRecipients:@[toRecipient]];
    //cc
//    [ controller setCcRecipients:[ NSArray arrayWithObjects:@"cc1@example.com", @"cc2@excample.com", nil ] ];
    //bcc
//    [ controller setBccRecipients:[ NSArray arrayWithObjects:@"bcc1@example.com", @"bcc2@excample.com", nil ] ];
    //content
    [ controller setMessageBody:body isHTML:NO ];

    // 表示
    [((KJViewController *)owner).navigationController presentViewController:controller animated:YES completion:nil];
}

+ (void)sendWorkSheetCsvfile:(KJViewController *)owner data:(NSArray *)worksheets {
    
    //テキストファイルとして書き出すためのディレクトリを作成する
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    
    NSString* dirPath = [NSString stringWithFormat:@"%@/cache", docDir];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    // ディレクトリが存在するか確認する
    if (![fileManager fileExistsAtPath:dirPath])
    {
        // 存在しなければ、ディレクトリを作成する
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES
                                attributes:nil error:nil];
    }
    
    
    if ([worksheets count] > 0) {
        // 最終的に他のアプリで開きたい文字列を用意しておきます
        
        //MARK:
        NSString *csvString = @"";
        NSMutableArray* all = [@[@"DATE,WEEKDAY,WORK_START_TIME,WORK_END_TIME,REST_TIME"] mutableCopy];
        
        NSString *targetDateYYYYmmdd = [((TimeCard *)[worksheets objectAtIndex:0]).t_yyyymmdd stringValue];
        NSDate *targetMonth = [NSDate convDate2ShortString:targetDateYYYYmmdd];
        
        //カレンダーことにカラム生成
        for (int d = 1; d <= [targetMonth getLastday]; d++) {
            
            //日付を作成
            NSMutableArray *adding = [NSMutableArray new];
            [adding addObject:[NSString stringWithFormat:@"%d/%d",[targetMonth getMonth], d]];
            
            NSDate *targetDay = [NSDate convDate2ShortString:[NSString stringWithFormat:@"%@%02d",[targetMonth yyyyMMString],d]];
            [adding addObject:[NSString stringWithFormat:@"%@",[Util weekdayString:[targetDay getWeekday]]]];
            
            //データを検索するためのキーを生成
            NSString *keyString = [NSString stringWithFormat:@"%@",[targetDay yyyyMMddString]];
            
            //検索
            for (TimeCard *tm in worksheets) {
                if ([[tm.t_yyyymmdd stringValue] isEqualToString:keyString] == YES) {
                    
                    [adding addObject:[Util worktimeString:[NSDate convDate2String:tm.start_time]]];
                    [adding addObject:[Util worktimeString:[NSDate convDate2String:tm.end_time]]];
                    [adding addObject:[NSString stringWithFormat:@"%.1f",[tm.rest_time floatValue]]];
                    
                    continue;
                }
            }
            
            // カンマ区切りで追加
            NSString* str = [adding componentsJoinedByString:@","];
            DLog(@"record:%@",str);
            
            [all addObject:str];
        }
        
        // CRLFで区切ったNSStringを返す
        csvString = [all componentsJoinedByString:@"\r\n"];
        
        NSString *prefix = [[((TimeCard *)[worksheets objectAtIndex:0]).t_yyyymmdd stringValue] substringWithRange:NSMakeRange(0, 6)];
        
        // データの書き込み
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", dirPath, [self generateCSVFilename:prefix]];
        
        [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        //UIDocumentController propertyの存在を確認
        owner.docInterCon = [UIDocumentInteractionController interactionControllerWithURL:url];
        owner.docInterCon.delegate = owner;
        
        BOOL isValid;
        isValid = [owner.docInterCon presentOpenInMenuFromRect:((KJViewController *)owner).view.frame
                                                        inView:((KJViewController *)owner).view
                                                      animated:YES];
        //    isValid = [owner.docInterCon presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
        if (!isValid) {
            DLog(@"データを開けるアプリケーションが見つかりません。");
        }
    }else {
        DLog(@"生成するCSVデータがない");
        return;
    }
    
}

@end
