//
//  KJViewController.h
//  Hakenman
//
//  Created by Lee jaeeun on 2014/02/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "const.h"
#import "StoryboardUtil.h"
#import <PBFlatUI/PBFlatBarButtonItems.h>
#import <UIKit/UIDocumentInteractionController.h>
#import "CsvExportProtocol.h"

@interface KJViewController : UIViewController <CsvExportProtocol, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *docInterCon;

- (void)initControls;

@end
