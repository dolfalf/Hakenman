//
//  AppInformationViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/04.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "AppInformationViewController.h"

#define ABOUT_URL   @"http://kj-code.com/?cat=3"

@interface AppInformationViewController () <UIWebViewDelegate> {
    IBOutlet UIWebView *descriptionWebview;
    IBOutlet UIActivityIndicatorView *indicator;
}

@end

@implementation AppInformationViewController

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
- (void)initControls {
    
    self.title = LOCALIZE(@"AppInformationViewController_navi_title");
    HKM_INIT_NAVI_TITLE([UIFont nanumFontOfSize:16.f]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [indicator startAnimating];
    
    [descriptionWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_URL]]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"kjcodeInfo" ofType:@"html"];
//    [descriptionWebview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [indicator stopAnimating];
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [indicator stopAnimating];
    
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL] options:@{} completionHandler:nil];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [indicator stopAnimating];
#if __LP64__
    NSInteger errorCode = error.code;
    NSString *errorMessage = [NSString stringWithFormat:@"(%ld)%@", errorCode, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
#else
    NSInteger errorCode = error.code;
    NSString *errorMessage = [NSString stringWithFormat:@"(%d)%@", errorCode, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
#endif
    [self _showAlertWithErrorDescription:errorMessage];
}

-(void)_showAlertWithErrorDescription:(NSString *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:error
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LOCALIZE(@"Common_alert_button_ok")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){
                                                             
                                                         }];
    
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
