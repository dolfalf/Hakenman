//
//  OpenSourceLicenseViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/04.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "OpenSourceLicenseViewController.h"

@interface OpenSourceLicenseViewController () <UIWebViewDelegate> {
     IBOutlet UIWebView *licenseWebview;
}

@end

@implementation OpenSourceLicenseViewController

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
    
    self.title = LOCALIZE(@"OpenSourceLicenseViewController_navi_title");
    HKM_INIT_NAVI_TITLE([UIFont nanumFontOfSize:16.f]);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"html"];
    [licenseWebview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
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
