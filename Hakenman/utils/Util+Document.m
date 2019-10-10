//
//  Util+Document.m
//  Hakenman
//
//  Created by kjcode on 2015/10/07.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "Util+Document.h"
#import "UIColor+Helper.h"
#import "NSDate+Helper.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIDocumentInteractionController.h>
#import "TimeCard.h"

@implementation Util (Document)

+ (NSString *)generateCSVFilename:(NSString *)prefix {
    
    return [NSString stringWithFormat:@"%@_%@.csv",prefix, [[NSDate date] yyyyMMddHHmmssString]];
}

+ (void)sendReportMailWorkSheet:(id)owner subject:(NSString *)subject toRecipient:(NSString *)toRecipient messageBody:(NSString *)body {
    
    // メールを利用できるかチェック
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    //navigation textColor
    //色の変更ができなかった。appleの仕様らしい。
    //controller.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"HKMBlueColor"];
    [UINavigationBar appearance].tintColor = [UIColor colorNamed:@"HKMBlueColor"];
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
    [((UIViewController *)owner).navigationController presentViewController:controller animated:YES completion:nil];
}

+ (void)sendWorkSheetCsvfile:(id<CsvExportProtocol, UIDocumentInteractionControllerDelegate>)owner data:(NSArray *)worksheets {
    
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
        NSMutableArray* all = [@[@"DATE,WEEKDAY,WORK_START_TIME,WORK_END_TIME,REST_TIME,REMARKS"] mutableCopy];
        
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
                    
                    NSString *remarkValue;
                    if (tm.remarks == nil) {
                        remarkValue = @"";
                    }else{
                        remarkValue = tm.remarks;
                    }
                    
                    [adding addObject:remarkValue];
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
        isValid = [owner.docInterCon presentOpenInMenuFromRect:((UIViewController *)owner).view.frame
                                                        inView:((UIViewController *)owner).view
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
