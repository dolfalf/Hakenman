//
//  MenuViewController.m
//  Hakenman
//
//  Created by Lee jaeeun on 2014/03/22.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "MenuViewController.h"

enum {
    menuTitleMonthWorkingTable,
    menuTitleWorkTableList,
    menuTitleSendDailyMail
} menuTitle;

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *menuTableView;
}

@property (nonatomic, strong) NSArray *items;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override method
- (void)initControls {
    
    //メニューリスト生成
    _items = @[LOCALIZE(@"MenuViewController_menulist_month_working_table_title")
               ,LOCALIZE(@"MenuViewController_menulist_working_tablelist_title")
               ,LOCALIZE(@"MenuViewController_menulist_send_daily_mail_title")];
}

#pragma mark - IBAction
- (IBAction)close:(id)sender {
    
    if (_completionHandler) {
        _completionHandler(self);
    }
    
    self.completionHandler = nil;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqual:@"goToMonthWorkingTable"]) {
        //
    }else if ([[segue identifier] isEqual:@"goToWorkTableList"]) {
        //
    }else if ([[segue identifier] isEqual:@"goToSendDailyMail"]) {
        //
    }
}

#pragma mark - transition screen method
- (void)goToMonthWorkingTable {
    DLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"goToMonthWorkingTable" sender:self];
    
}

- (void)goToWorkTableList {
    DLog(@"%s", __FUNCTION__);
}

-(void)goToSendDailyMail {
    DLog(@"%s", __FUNCTION__);
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = @"MenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    // セルの内容はNSArray型の「items」にセットされているものとする
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"%@ tableCell Selected.", [_items objectAtIndex:indexPath.row]);
    
    switch (indexPath.row) {
        case menuTitleMonthWorkingTable:
            //今月の勤務表
            [self goToMonthWorkingTable];
            break;
            
        case menuTitleWorkTableList:
            //勤務表リスト
            [self goToWorkTableList];
            break;
            
        case menuTitleSendDailyMail:
            //日報メール送信
            [self goToSendDailyMail];
            break;
            
        default:
            break;
    }
}


@end
