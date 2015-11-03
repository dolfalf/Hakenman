//
//  MonthWorkingCalendarViewController.h
//  Hakenman
//
//  Created by kjcode on 2014/10/25.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "RDVCalendarViewController.h"
#import "CsvExportProtocol.h"
#import <UIKit/UIDocumentInteractionController.h>

@interface MonthWorkingCalendarViewController : RDVCalendarViewController <CsvExportProtocol, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *docInterCon;
@property (nonatomic, strong) NSString *inputDates;

@end
