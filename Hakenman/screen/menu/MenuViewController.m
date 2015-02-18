//
//  MenuViewController.m
//  Hakenman
//
//  Created by Lee Junha on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//
#import "MenuViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import <RETableViewManager/RETableViewOptionsController.h>
#import <UIKit/UIDocumentInteractionController.h>

@interface MenuViewController() <RETableViewManagerDelegate> {
    
    IBOutlet UIBarButtonItem *closeButton;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RETableViewManager *reTableManager;
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;

@property (nonatomic, strong) UIAlertView *deleteAlertview;

- (IBAction)close:(id)sender;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    [super initControls];
    
    [self initTableView];
    
    self.title = LOCALIZE(@"SettingViewController_navi_title");
    
    //設定メニュー作成
    _items = @[LOCALIZE(@"SettingViewController_menulist_working_space_title")
               ,LOCALIZE(@"SettingViewController_menulist_calc_time_unit_title")];
    
    closeButton.title = LOCALIZE(@"Common_navigation_closebutton_title");
}

#pragma mark - RETableView methods
- (void)initTableView {
    
    // Create the manager
    //
    self.reTableManager = [[RETableViewManager alloc] initWithTableView:self.menuTableView];
    _reTableManager.delegate = self;
    
    [self loadBasicSection];
}

- (void)loadBasicSection {
    
    __typeof (self) __weak weakSelf = self;
    
    // Add a section
    //
    RETableViewSection *menuSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"SettingViewController_menulist_app_info_section_title")];
    [self.reTableManager addSection:menuSection];
    
    //修正画面へ
    [menuSection addItem:[RETableViewItem itemWithTitle:LOCALIZE(@"SettingViewController_app_info_title")
                                          accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                       selectionHandler:^(RETableViewItem *item) {
        
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.menuTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        //遷移
        [self performSegueWithIdentifier:@"HistoryEditSegue" sender:self];
    }]];
    
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

@end
