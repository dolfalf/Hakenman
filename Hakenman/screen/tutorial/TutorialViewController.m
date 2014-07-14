//
//  TutorialViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/03.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TutorialViewController.h"
#import "UIColor+Helper.h"

#define NUMBER_OF_PAGES 4

#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))

@interface TutorialViewController ()

@property (nonatomic, strong) IFTTTAnimator *animator;

//page01
@property (nonatomic, strong) UILabel *page01WelcomeLabel;
@property (nonatomic, strong) UILabel *page01WriteTimeLabel;
@property (nonatomic, strong) UILabel *page01SendReportLabel;
@property (nonatomic, strong) UILabel *page01MakeCsvLabel;
@property (nonatomic, strong) UIImageView *page01LogoImage;

//page02
@property (nonatomic, strong) UILabel *page02TitleLabel;
@property (nonatomic, strong) UIImageView *page02ScreenShotImage1;
@property (nonatomic, strong) UIImageView *page02DescImage1;
@property (nonatomic, strong) UILabel *page02DescLabel1;
@property (nonatomic, strong) UIImageView *page02ScreenShotImage2;
@property (nonatomic, strong) UIImageView *page02DescImage2;
@property (nonatomic, strong) UILabel *page02DescLabel2;


@property (strong, nonatomic) UIImageView *wordmark;
@property (strong, nonatomic) UIImageView *unicorn;
@property (strong, nonatomic) UILabel *lastLabel;
@property (strong, nonatomic) UILabel *firstLabel;

@end

@implementation TutorialViewController

- (void)dealloc {
    DLog(@"%s",__FUNCTION__);
}
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
    
    self.animator = [IFTTTAnimator new];
    
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self placeViews];
    [self configureAnimation];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - pravate methods
- (void)addPageLabel:(UILabel *)lbl text:(NSString *)text fontSize:(float)sz movePoint:(CGPoint)pt {
    
    lbl.text = text;
    lbl.font = [UIFont fontWithName:@"Helvetica-Light" size:sz];
    [lbl sizeToFit];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.center = self.view.center;
    lbl.backgroundColor = [UIColor yellowColor];//test
    lbl.frame = CGRectOffset(lbl.frame, pt.x, pt.y);
    [self.scrollView addSubview:lbl];
}

-(void)addPageImage:(UIImageView *)imageView size:(CGSize)sz movePoint:(CGPoint)pt {
    
    imageView.center = self.view.center;
    imageView.frame = CGRectOffset(CGRectInset(imageView.frame, sz.width, sz.height),pt.x,pt.y);
    [self.scrollView addSubview:imageView];
}

#pragma mark Animation page01
- (void)page01Animation {
    
    IFTTTAlphaAnimation *welcomeFrameAnimation = [IFTTTAlphaAnimation animationWithView:_page01WelcomeLabel];
    [self.animator addAnimation:welcomeFrameAnimation];
    
    [welcomeFrameAnimation addKeyFrames:@[
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                          ]];
    
    IFTTTFrameAnimation *welcomeFrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page01WelcomeLabel];
    [self.animator addAnimation:welcomeFrameAnimation1];
    
    [welcomeFrameAnimation1 addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WelcomeLabel.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WelcomeLabel.frame, timeForPage(2), 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)],
                                           ]];
    
    
    IFTTTAlphaAnimation *writeFrameAnimation = [IFTTTAlphaAnimation animationWithView:_page01WriteTimeLabel];
    [self.animator addAnimation:writeFrameAnimation];
    
    [writeFrameAnimation addKeyFrames:@[
                                        [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f],
                                        [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f],
                                        [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                        [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                        ]];
    
    IFTTTFrameAnimation *writeFrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page01WriteTimeLabel];
    [self.animator addAnimation:writeFrameAnimation1];
    
    [writeFrameAnimation1 addKeyFrames:@[
                                         [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, 0, 0)],
                                         [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, timeForPage(2), 0)],
                                         [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                                         [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                                         ]];
    
    IFTTTAlphaAnimation *sendReportFrameAnimation = [IFTTTAlphaAnimation animationWithView:_page01SendReportLabel];
    [self.animator addAnimation:sendReportFrameAnimation];
    
    [sendReportFrameAnimation addKeyFrames:@[
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f],
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f],
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                             [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                             ]];
    
    IFTTTFrameAnimation *sendReportFrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page01SendReportLabel];
    [self.animator addAnimation:sendReportFrameAnimation1];
    
    [sendReportFrameAnimation1 addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01SendReportLabel.frame, 0, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01SendReportLabel.frame, timeForPage(2), 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01SendReportLabel.frame,0,0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01SendReportLabel.frame,0,0)],
                                              ]];
    
    IFTTTAlphaAnimation *csvMakeFrameAnimation = [IFTTTAlphaAnimation animationWithView:_page01MakeCsvLabel];
    [self.animator addAnimation:csvMakeFrameAnimation];
    
    [csvMakeFrameAnimation addKeyFrames:@[
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                          ]];
    
    IFTTTFrameAnimation *csvMakeFrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page01MakeCsvLabel];
    [self.animator addAnimation:csvMakeFrameAnimation1];
    
    [csvMakeFrameAnimation1 addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01MakeCsvLabel.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01MakeCsvLabel.frame, timeForPage(2), 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01MakeCsvLabel.frame,0,0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01MakeCsvLabel.frame,0,0)],
                                           ]];
    
    
    
    
    IFTTTAlphaAnimation *logoAlphaAnimation = [IFTTTAlphaAnimation animationWithView:_page01LogoImage];
    [self.animator addAnimation:logoAlphaAnimation];
    
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];
    
    
    IFTTTFrameAnimation *logoAnimation = [IFTTTFrameAnimation animationWithView:_page01LogoImage];
    [self.animator addAnimation:logoAnimation];
    
    [logoAnimation addKeyFrames:@[
                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01LogoImage.frame, 0, 0)],
                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01LogoImage.frame, timeForPage(2), 0)],
                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01LogoImage.frame,0,0)],
                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01LogoImage.frame,0,0)],
                                  ]];
    
    
    
}

- (void)page02Animation {
    
    IFTTTAlphaAnimation *page02TitleFrameAnimation = [IFTTTAlphaAnimation animationWithView:_page02TitleLabel];
    [self.animator addAnimation:page02TitleFrameAnimation];
    
    [page02TitleFrameAnimation addKeyFrames:@[
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                          ]];
    
    IFTTTFrameAnimation *page02TitleFrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page02TitleLabel];
    [self.animator addAnimation:page02TitleFrameAnimation1];
    
    [page02TitleFrameAnimation1 addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02TitleLabel.frame, timeForPage(3), 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02TitleLabel.frame, timeForPage(1) *-1, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02TitleLabel.frame,0,0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02TitleLabel.frame,0,0)],
                                           ]];
    
    
    
    
    
    IFTTTAlphaAnimation *page02Image01FrameAnimation = [IFTTTAlphaAnimation animationWithView:_page02ScreenShotImage1];
    [self.animator addAnimation:page02Image01FrameAnimation];
    
    [page02Image01FrameAnimation addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                              ]];
    
    IFTTTFrameAnimation *page02Image01FrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page02ScreenShotImage1];
    [self.animator addAnimation:page02Image01FrameAnimation1];
    
    [page02Image01FrameAnimation1 addKeyFrames:@[
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02ScreenShotImage1.frame, timeForPage(3), 0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02ScreenShotImage1.frame, timeForPage(1) *-1, 0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02ScreenShotImage1.frame,0,0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02ScreenShotImage1.frame,0,0)],
                                               ]];
    
    
    
    IFTTTAlphaAnimation *page02DescImage01FrameAnimation = [IFTTTAlphaAnimation animationWithView:_page02DescImage1];
    [self.animator addAnimation:page02DescImage01FrameAnimation];
    
    [page02DescImage01FrameAnimation addKeyFrames:@[
                                                [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f],
                                                [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f],
                                                [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                                [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                                ]];
    
    IFTTTFrameAnimation *page02DescImage01FrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page02DescImage1];
    [self.animator addAnimation:page02DescImage01FrameAnimation1];
    
    [page02DescImage01FrameAnimation1 addKeyFrames:@[
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescImage1.frame, timeForPage(3), 0)],
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescImage1.frame, timeForPage(1) *-1, 0)],
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescImage1.frame,0,0)],
                                                 [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescImage1.frame,0,0)],
                                                 ]];
    
    
    
    IFTTTAlphaAnimation *page02DescImage02FrameAnimation = [IFTTTAlphaAnimation animationWithView:_page02DescImage2];
    [self.animator addAnimation:page02DescImage02FrameAnimation];
    
    [page02DescImage02FrameAnimation addKeyFrames:@[
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                                    ]];
    
    IFTTTFrameAnimation *page02DescImage02FrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page02DescImage2];
    [self.animator addAnimation:page02DescImage02FrameAnimation1];
    
    [page02DescImage02FrameAnimation1 addKeyFrames:@[
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescImage2.frame, timeForPage(3), 0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescImage2.frame, timeForPage(1) *-1, 0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescImage2.frame,0,0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescImage2.frame,0,0)],
                                                     ]];
    
    

    IFTTTAlphaAnimation *page02DescLabel01FrameAnimation = [IFTTTAlphaAnimation animationWithView:_page02DescLabel1];
    [self.animator addAnimation:page02DescLabel01FrameAnimation];
    
    [page02DescLabel01FrameAnimation addKeyFrames:@[
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f],
                                                    [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f],
                                                    ]];
    
    IFTTTFrameAnimation *page02DescLabel01FrameAnimation1 = [IFTTTFrameAnimation animationWithView:_page02DescLabel1];
    [self.animator addAnimation:page02DescLabel01FrameAnimation1];
    
    [page02DescLabel01FrameAnimation1 addKeyFrames:@[
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescLabel1.frame, timeForPage(3), 0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescLabel1.frame, timeForPage(1) *-1, 0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescLabel1.frame,0,0)],
                                                     [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescLabel1.frame,0,0)],
                                                     ]];
    

    //TODO:
//    
//    self.page02ScreenShotImage2
//    self.page02DescImage2
//    self.page02DescLabel2
    
}

#pragma mark - animation methods
- (void)placeViews
{
    //Page01
    self.page01WelcomeLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01WelcomeLabel text:@"Welcome" fontSize:40.f movePoint:CGPointMake(0, -200)];
    
    self.page01WriteTimeLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01WriteTimeLabel text:@"Easy manage\n worktime." fontSize:20.f movePoint:CGPointMake(0, -150)];

    self.page01SendReportLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01SendReportLabel text:@"Send today Report Mail." fontSize:20.f movePoint:CGPointMake(0, -120)];

    self.page01MakeCsvLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01MakeCsvLabel text:@"Export CSV file." fontSize:20.f movePoint:CGPointMake(0, -90)];
    
    self.page01LogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self addPageImage:_page01LogoImage size:CGSizeMake(50, 50) movePoint:CGPointMake(0, 100)];
    
    
    //Page02
    self.page02TitleLabel = [[UILabel alloc] init];
    _page02TitleLabel.numberOfLines = 2;
    [self addPageLabel:_page02TitleLabel text:@"Easy\n manage worktime!" fontSize:30.f movePoint:CGPointMake(timeForPage(2), -190)];
    
    self.page02ScreenShotImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page02_screenshot01"]];
    [self addPageImage:_page02ScreenShotImage1 size:CGSizeMake(-20, -20) movePoint:CGPointMake(timeForPage(2)-10, 0)];
    
    self.page02DescImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yajirusi01"]];
    [self addPageImage:_page02DescImage1 size:CGSizeMake(0, 0) movePoint:CGPointMake(timeForPage(2)+40, -15)];
    
    self.page02DescImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru01"]];
    [self addPageImage:_page02DescImage2 size:CGSizeMake(-10, -10) movePoint:CGPointMake(timeForPage(2)+30, 40)];
    
    self.page02DescLabel1 = [[UILabel alloc] init];
    _page02DescLabel1.numberOfLines = 2;
    _page02DescLabel1.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page02DescLabel1 text:@"月の勤怠が\nすぐわかる!" fontSize:13.f movePoint:CGPointMake(timeForPage(2)+110, -50)];
    
    self.page02ScreenShotImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page02_screenshot02"]];
    [self addPageImage:_page02ScreenShotImage2 size:CGSizeMake(-20, -20) movePoint:CGPointMake(timeForPage(2)-5, 140)];
    
    self.page02DescImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru01"]];
    [self addPageImage:_page02DescImage2 size:CGSizeMake(-10, -10) movePoint:CGPointMake(timeForPage(2)+70, 190)];
    
    self.page02DescLabel2 = [[UILabel alloc] init];
    _page02DescLabel2.numberOfLines = 2;
    _page02DescLabel2.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page02DescLabel2 text:@"簡単に勤怠を\n入力します！" fontSize:13.f movePoint:CGPointMake(timeForPage(2)+90, 140)];
    
    //Page03
    
    
    
}

- (void)configureAnimation
{
    
    //page01
    [self page01Animation];
    
    //page02
    [self page02Animation];
    
    
    
    
    CGFloat dy = 240;
    
    // apply a 3D zoom animation to the first label
    IFTTTTransform3DAnimation * labelTransform = [IFTTTTransform3DAnimation animationWithView:self.firstLabel];
    IFTTTTransform3D *tt1 = [IFTTTTransform3D transformWithM34:0.03f];
    IFTTTTransform3D *tt2 = [IFTTTTransform3D transformWithM34:0.3f];
    tt2.rotate = (IFTTTTransform3DRotate){ -(CGFloat)(M_PI), 1, 0, 0 };
    tt2.translate = (IFTTTTransform3DTranslate){ 0, 0, 50 };
    tt2.scale = (IFTTTTransform3DScale){ 1.f, 2.f, 1.f };
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0)
                                                                andAlpha:1.0f]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1)
                                                          andTransform3D:tt1]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5)
                                                          andTransform3D:tt2]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5) + 1
                                                                andAlpha:0.0f]];
    [self.animator addAnimation:labelTransform];
    
    // let's animate the wordmark
    IFTTTFrameAnimation *wordmarkFrameAnimation = [IFTTTFrameAnimation animationWithView:self.wordmark];
    [self.animator addAnimation:wordmarkFrameAnimation];
    
    [wordmarkFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(self.wordmark.frame, 200, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:self.wordmark.frame],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.wordmark.frame, self.view.frame.size.width, dy)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.wordmark.frame, 0, dy)],
                                           ]];
    
    // Rotate a full circle from page 2 to 3
    IFTTTAngleAnimation *wordmarkRotationAnimation = [IFTTTAngleAnimation animationWithView:self.wordmark];
    [self.animator addAnimation:wordmarkRotationAnimation];
    [wordmarkRotationAnimation addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAngle:0.0f],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAngle:(CGFloat)(2 * M_PI)],
                                              ]];
    
    // now, we animate the unicorn
    IFTTTFrameAnimation *unicornFrameAnimation = [IFTTTFrameAnimation animationWithView:self.unicorn];
    [self.animator addAnimation:unicornFrameAnimation];
    
    CGFloat ds = 50;
    
    // move down and to the right, and shrink between pages 2 and 3
    [unicornFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:self.unicorn.frame]];
    [unicornFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3)
                                                                       andFrame:CGRectOffset(CGRectInset(self.unicorn.frame, ds, ds), timeForPage(2), dy)]];
    // fade the unicorn in on page 2 and out on page 4
    IFTTTAlphaAnimation *unicornAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.unicorn];
    [self.animator addAnimation:unicornAlphaAnimation];
    
    [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f]];
    [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f]];
    [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:1.0f]];
    [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];
    
    // Fade out the label by dragging on the last page
    IFTTTAlphaAnimation *labelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.lastLabel];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:labelAlphaAnimation];
}

#pragma mark - IFTTTAnimatedScrollViewControllerDelegate

- (void)animatedScrollViewControllerDidScrollToEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Scrolled to end of scrollview!");
}

- (void)animatedScrollViewControllerDidEndDraggingAtEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Ended dragging at end of scrollview!");
}

-(IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
