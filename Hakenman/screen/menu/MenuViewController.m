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
#import "HistoryEditViewController.h"

@interface MenuViewController() <RETableViewManagerDelegate> {
    
    IBOutlet UIBarButtonItem *closeButton;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RETableViewManager *reTableManager;
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, assign) HistoryEditType selectedEditType;

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
    
    //メニュー作成
    _items = @[LOCALIZE(@"MenuViewController_menu_item_add_past_month_menu")
               ,LOCALIZE(@"MenuViewController_menu_item_delete_past_month_menu")];
    
    [self initTableView];
    
    self.title = LOCALIZE(@"MenuViewController_navi_title");
    
    
    
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
    RETableViewSection *menuSection = [RETableViewSection sectionWithHeaderTitle:LOCALIZE(@"MenuViewController_menu_item_section_title")];
    [self.reTableManager addSection:menuSection];
    
    //修正画面へ
    [menuSection addItem:[RETableViewItem itemWithTitle:[_items objectAtIndex:0]
                                          accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                       selectionHandler:^(RETableViewItem *item) {
        
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        [strongSelf.menuTableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
                                           //遷移
                                           self.selectedEditType = HistoryEditTypeAdd;
                                           [self performSegueWithIdentifier:@"HistoryEditSegue" sender:self];
    }]];
    
    //修正画面へ
    [menuSection addItem:[RETableViewItem itemWithTitle:[_items objectAtIndex:1]
                                          accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                       selectionHandler:^(RETableViewItem *item) {
                                           
                                           __typeof (weakSelf) __strong strongSelf = weakSelf;
                                           [strongSelf.menuTableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                           
                                           //遷移
                                           self.selectedEditType = HistoryEditTypeRemove;
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

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     ((HistoryEditViewController *)[segue destinationViewController]).editType = _selectedEditType;
     
 }

@end
