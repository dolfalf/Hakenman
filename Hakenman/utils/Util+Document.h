//
//  Util+Document.h
//  Hakenman
//
//  Created by kjcode on 2015/10/07.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "Util.h"
#import "CsvExportProtocol.h"

@interface Util (Document)

+ (NSString *)generateCSVFilename:(NSString *)prefix;

//+ (void)sendMailWorkSheet:(id)owner append:(NSArray *)worksheets;
+ (void)sendReportMailWorkSheet:(id)owner subject:(NSString *)subject toRecipient:(NSString *)toRecipient messageBody:(NSString *)body;

+ (void)sendWorkSheetCsvfile:(id<CsvExportProtocol,UIDocumentInteractionControllerDelegate>)owner data:(NSArray *)worksheets;

@end
