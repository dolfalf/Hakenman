//
//  AppInformationViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/04.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "AppInformationViewController.h"

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

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"kjcodeInfo" ofType:@"html"];
//    [descriptionWebview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewWillAppear:(BOOL)animated {

    [indicator startAnimating];
    
    [descriptionWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://kj-code.com"]]];
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
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
    
    [indicator stopAnimating];
    
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [indicator stopAnimating];
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:[error description]
                               delegate:nil
                      cancelButtonTitle:LOCALIZE(@"Common_alert_button_ok")
                      otherButtonTitles:nil] show];
    
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
