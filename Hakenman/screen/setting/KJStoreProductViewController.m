//
//  KJStoreProductViewController.m
//  Hakenman
//
//  Created by YONGSUK KIM on 2014. 9. 20..
//  Copyright (c) 2014년 KJ-CODE. All rights reserved.
//

#import "KJStoreProductViewController.h"
#import "const.h"


@implementation KJStoreProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCALIZE(@"KJStoreProductViewController_title");
    
/*
    // ⌄ 의 이미지를 불러와서 왼쪽 바 버튼에 붙임
    UIImage *image = [UIImage imageNamed:@"ArrowDown"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(dismissViewController)];
    [item setImageInsets:UIEdgeInsetsMake(2, -9, 0, 0)];    // 바 버튼 위치 설정
    item.tintColor = [UIColor redColor];                    // ⌄ 의 색을 결정
    self.navigationItem.leftBarButtonItem = item;
*/
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
}

@end
