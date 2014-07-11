//
//  TutorialViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/03.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TutorialViewController.h"

#define NUMBER_OF_PAGES 4

#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))

@interface TutorialViewController ()

@property (nonatomic, strong) IFTTTAnimator *animator;

@property (nonatomic, strong) UILabel *page01WelcomeLabel;
@property (nonatomic, strong) UILabel *page01WriteTimeLabel;
@property (nonatomic, strong) UILabel *page01SendReportLabel;
@property (nonatomic, strong) UILabel *page01MakeCsvLabel;
@property (nonatomic, strong) UIImageView *page01LogoImage;

@property (nonatomic, strong) UILabel *page02TitleLabel;
@property (nonatomic, strong) UIImageView *page02ScreenShotImage;
@property (nonatomic, strong) UIImageView *page02ScreenShotsubImage;
@property (nonatomic, strong) UIImageView *page02DescImage;

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
- (void)addLabel {
    
}


#pragma mark - animation methods
- (void)placeViews
{
    
    //Page01
    self.page01WelcomeLabel = [[UILabel alloc] init];
    self.page01WelcomeLabel.text = @"Welcome";
    self.page01WelcomeLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:40];
    [self.page01WelcomeLabel sizeToFit];
    self.page01WelcomeLabel.center = self.view.center;
    self.page01WelcomeLabel.frame = CGRectOffset(_page01WelcomeLabel.frame, 0, -150);
    [self.scrollView addSubview:self.page01WelcomeLabel];
    
    self.page01WriteTimeLabel = [[UILabel alloc] init];
    self.page01WriteTimeLabel.text = @"Easy Write time.";
    self.page01WriteTimeLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    [self.page01WriteTimeLabel sizeToFit];
    self.page01WriteTimeLabel.center = _page01WelcomeLabel.center;
    self.page01WriteTimeLabel.frame = CGRectOffset(_page01WriteTimeLabel.frame, 0, 60);
    [self.scrollView addSubview:self.page01WriteTimeLabel];

    self.page01SendReportLabel = [[UILabel alloc] init];
    self.page01SendReportLabel.text = @"Send today Report Mail.";
    self.page01SendReportLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    [self.page01SendReportLabel sizeToFit];
    self.page01SendReportLabel.center = _page01WriteTimeLabel.center;
    self.page01SendReportLabel.frame = CGRectOffset(_page01SendReportLabel.frame, 0, 30);
    [self.scrollView addSubview:self.page01SendReportLabel];

    self.page01MakeCsvLabel = [[UILabel alloc] init];
    _page01MakeCsvLabel.text = @"Export CSV file.";
    _page01MakeCsvLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    [_page01MakeCsvLabel sizeToFit];
    _page01MakeCsvLabel.center = _page01SendReportLabel.center;
    _page01MakeCsvLabel.frame = CGRectOffset(_page01MakeCsvLabel.frame, 0, 30);
    [self.scrollView addSubview:_page01MakeCsvLabel];
    
    
    self.page01LogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.page01LogoImage.center = self.view.center;
    self.page01LogoImage.frame = CGRectOffset(CGRectInset(_page01LogoImage.frame, 50, 50),0,100);
    [self.scrollView addSubview:_page01LogoImage];
    
    
    
    
    
    // put a unicorn in the middle of page two, hidden
    self.unicorn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unicorn"]];
    self.unicorn.center = self.view.center;
    self.unicorn.frame = CGRectOffset(
                                      self.unicorn.frame,
                                      self.view.frame.size.width,
                                      -100
                                      );
    self.unicorn.alpha = 0.0f;
    [self.scrollView addSubview:self.unicorn];
    
    // put a logo on top of it
    self.wordmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IFTTT"]];
    self.wordmark.center = self.view.center;
    self.wordmark.frame = CGRectOffset(
                                       self.wordmark.frame,
                                       self.view.frame.size.width,
                                       -100
                                       );
    [self.scrollView addSubview:self.wordmark];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.text = @"Introducing Jazz Hands";
    [self.firstLabel sizeToFit];
    self.firstLabel.center = self.view.center;
//    [self.scrollView addSubview:self.firstLabel];
    
    UILabel *secondPageText = [[UILabel alloc] init];
    secondPageText.text = @"Brought to you by IFTTT";
    [secondPageText sizeToFit];
    secondPageText.center = self.view.center;
    secondPageText.frame = CGRectOffset(secondPageText.frame, timeForPage(2), 180);
    [self.scrollView addSubview:secondPageText];
    
    UILabel *thirdPageText = [[UILabel alloc] init];
    thirdPageText.text = @"Simple keyframe animations";
    [thirdPageText sizeToFit];
    thirdPageText.center = self.view.center;
    thirdPageText.frame = CGRectOffset(thirdPageText.frame, timeForPage(3), -100);
    [self.scrollView addSubview:thirdPageText];
    
    UILabel *fourthPageText = [[UILabel alloc] init];
    fourthPageText.text = @"Optimized for scrolling intros";
    [fourthPageText sizeToFit];
    fourthPageText.center = self.view.center;
    fourthPageText.frame = CGRectOffset(fourthPageText.frame, timeForPage(4), 0);
    [self.scrollView addSubview:fourthPageText];
    
    self.lastLabel = fourthPageText;
}

- (void)configureAnimation
{
    
    //page01
    IFTTTFrameAnimation *welcomeFrameAnimation = [IFTTTFrameAnimation animationWithView:_page01WelcomeLabel];
    [self.animator addAnimation:welcomeFrameAnimation];
    
    [welcomeFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WelcomeLabel.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WelcomeLabel.frame, timeForPage(2), -200)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)],
                                           ]];
    
    
    IFTTTFrameAnimation *writeTimeFrameAnimation = [IFTTTFrameAnimation animationWithView:_page01WriteTimeLabel];
    [self.animator addAnimation:writeTimeFrameAnimation];
    
    [writeTimeFrameAnimation addKeyFrames:@[
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, 0, 0)],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, timeForPage(2), 200)],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                                          ]];
    
    
    IFTTTAlphaAnimation *logoAlphaAnimation = [IFTTTAlphaAnimation animationWithView:_page01LogoImage];
    [self.animator addAnimation:logoAlphaAnimation];

    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f]];
    [logoAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];
    
    
    
    
    
    
    
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
