//
//  TutorialViewController.m
//  Hakenman
//
//  Created by kjcode on 2014/07/03.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "TutorialViewController.h"
#import "UIColor+Helper.h"
#import "const.h"


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
@property (nonatomic, strong) UIImageView *page02DescImage3;
@property (nonatomic, strong) UILabel *page02DescLabel2;

//page03
@property (nonatomic, strong) UILabel *page03TitleLabel1;
@property (nonatomic, strong) UIImageView *page03ScreenShotImage1;
@property (nonatomic, strong) UIImageView *page03DescImage1;
@property (nonatomic, strong) UILabel *page03DescLabel1;
@property (nonatomic, strong) UILabel *page03TitleLabel2;
@property (nonatomic, strong) UIImageView *page03ScreenShotImage2;
@property (nonatomic, strong) UIImageView *page03DescImage2;
@property (nonatomic, strong) UILabel *page03DescLabel2;

//page04
@property (nonatomic, strong) UILabel *page04TitleLabel;
@property (nonatomic, strong) UILabel *page04DescLabel;

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
//    lbl.backgroundColor = [UIColor yellowColor];//test
    lbl.frame = CGRectOffset(lbl.frame, pt.x, pt.y);
    [self.scrollView addSubview:lbl];
}

-(void)addPageImage:(UIImageView *)imageView size:(CGSize)sz movePoint:(CGPoint)pt {
    
    imageView.center = self.view.center;
    imageView.frame = CGRectOffset(CGRectInset(imageView.frame, sz.width, sz.height),pt.x,pt.y);
    [self.scrollView addSubview:imageView];
}

- (void)alphaEffect:(NSInteger)page control:(id)sender {
    
    IFTTTAlphaAnimation *frameAnimation = [IFTTTAlphaAnimation animationWithView:sender];
    [self.animator addAnimation:frameAnimation];
    
    NSMutableArray *effectFrame = [NSMutableArray new];
    //page4
    for (int i=1; i<= 4; i++) {
        [effectFrame addObject:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(i)
                                                               andAlpha:(i==page)?page:0.f]];
    }
    
    [frameAnimation addKeyFrames:effectFrame];
    
}

- (void)moveEffect:(NSArray *)animationFrames control:(id)sender {
    
    IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation animationWithView:sender];
    [self.animator addAnimation:frameAnimation];
    [frameAnimation addKeyFrames:animationFrames];
}

#pragma mark Animation page01
- (void)page01Animation {
    
    [self alphaEffect:1 control:_page01WelcomeLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WelcomeLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WelcomeLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WelcomeLabel.frame,0,0)]
                       ]
             control:_page01WelcomeLabel];
    
    
    [self alphaEffect:1 control:_page01WriteTimeLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01WriteTimeLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01WriteTimeLabel.frame,0,0)],
                       ]
             control:_page01WriteTimeLabel];
    
    [self alphaEffect:1 control:_page01SendReportLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01SendReportLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01SendReportLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01SendReportLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01SendReportLabel.frame,0,0)],
                       ]
             control:_page01SendReportLabel];
    
    
    [self alphaEffect:1 control:_page01MakeCsvLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01MakeCsvLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01MakeCsvLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01MakeCsvLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01MakeCsvLabel.frame,0,0)],
                       ]
             control:_page01MakeCsvLabel];
    

    
    [self alphaEffect:1 control:_page01LogoImage];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01LogoImage.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01LogoImage.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01LogoImage.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01LogoImage.frame,0,0)],
                       ]
             control:_page01LogoImage];
    
    
}

- (void)page02Animation {
    
    
    [self alphaEffect:2 control:_page02TitleLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02TitleLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02TitleLabel.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02TitleLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02TitleLabel.frame,0,0)],
                       ]
             control:_page02TitleLabel];
    
    
    [self alphaEffect:2 control:_page02ScreenShotImage1];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02ScreenShotImage1.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02ScreenShotImage1.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02ScreenShotImage1.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02ScreenShotImage1.frame,0,0)],
                       ]
             control:_page02ScreenShotImage1];
    
    

    [self alphaEffect:2 control:_page02DescImage1];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescImage1.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescImage1.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescImage1.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescImage1.frame,0,0)],
                       ]
             control:_page02DescImage1];
    
    
    
    
    
    [self alphaEffect:2 control:_page02DescImage2];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescImage2.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescImage2.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescImage2.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescImage2.frame,0,0)],
                       ]
             control:_page02DescImage2];
    
    
    
    [self alphaEffect:2 control:_page02DescLabel1];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescLabel1.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescLabel1.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescLabel1.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescLabel1.frame,0,0)],
                       ]
             control:_page02DescLabel1];
    
    
    
    [self alphaEffect:2 control:_page02ScreenShotImage2];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02ScreenShotImage2.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02ScreenShotImage2.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02ScreenShotImage2.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02ScreenShotImage2.frame,0,0)],
                       ]
             control:_page02ScreenShotImage2];

    
    
    [self alphaEffect:2 control:_page02DescImage3];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescImage3.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescImage3.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescImage3.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescImage3.frame,0,0)],
                       ]
             control:_page02DescImage3];
    
    
    [self alphaEffect:2 control:_page02DescLabel2];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescLabel2.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescLabel2.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescLabel2.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescLabel2.frame,0,0)],
                       ]
             control:_page02DescLabel2];

    
}

- (void)page03Animation {
//    _page03TitleLabel1;
//    _page03ScreenShotImage1;
//    _page03DescImage1;
//    _page03DescLabel1;
//    _page03TitleLabel2;
//    _page03ScreenShotImage2;
//    _page03DescImage2;
//    _page03DescLabel2;
}

#pragma mark - animation methods
- (void)placeViews
{
    //Page01
    self.page01WelcomeLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01WelcomeLabel text:LOCALIZE(@"TutorialViewController_page1_title") fontSize:40.f movePoint:CGPointMake(0, -200)];
    
    self.page01WriteTimeLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01WriteTimeLabel text:LOCALIZE(@"TutorialViewController_page1_label1") fontSize:20.f movePoint:CGPointMake(0, -150)];

    self.page01SendReportLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01SendReportLabel text:LOCALIZE(@"TutorialViewController_page1_label2") fontSize:20.f movePoint:CGPointMake(0, -120)];

    self.page01MakeCsvLabel = [[UILabel alloc] init];
    [self addPageLabel:_page01MakeCsvLabel text:LOCALIZE(@"TutorialViewController_page1_label3") fontSize:20.f movePoint:CGPointMake(0, -90)];
    
    self.page01LogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self addPageImage:_page01LogoImage size:CGSizeMake(50, 50) movePoint:CGPointMake(0, 100)];
    
    
    //Page02
    self.page02TitleLabel = [[UILabel alloc] init];
    _page02TitleLabel.numberOfLines = 2;
    [self addPageLabel:_page02TitleLabel text:LOCALIZE(@"TutorialViewController_page2_title") fontSize:30.f movePoint:CGPointMake(timeForPage(2), -190)];
    
    self.page02ScreenShotImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page02_screenshot01"]];
    [self addPageImage:_page02ScreenShotImage1 size:CGSizeMake(-20, -20) movePoint:CGPointMake(timeForPage(2)-10, 0)];
    
    self.page02DescImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yajirusi01"]];
    [self addPageImage:_page02DescImage1 size:CGSizeMake(0, 0) movePoint:CGPointMake(timeForPage(2)+40, -15)];
    
    self.page02DescImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru01"]];
    [self addPageImage:_page02DescImage2 size:CGSizeMake(-10, -10) movePoint:CGPointMake(timeForPage(2)+30, 40)];
    
    self.page02DescLabel1 = [[UILabel alloc] init];
    _page02DescLabel1.numberOfLines = 2;
    _page02DescLabel1.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page02DescLabel1 text:LOCALIZE(@"TutorialViewController_page2_label1") fontSize:13.f movePoint:CGPointMake(timeForPage(2)+110, -50)];
    
    self.page02ScreenShotImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page02_screenshot02"]];
    [self addPageImage:_page02ScreenShotImage2 size:CGSizeMake(-20, -20) movePoint:CGPointMake(timeForPage(2)-5, 140)];
    
    self.page02DescImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru01"]];
    [self addPageImage:_page02DescImage3 size:CGSizeMake(-10, -10) movePoint:CGPointMake(timeForPage(2)+70, 190)];
    
    self.page02DescLabel2 = [[UILabel alloc] init];
    _page02DescLabel2.numberOfLines = 2;
    _page02DescLabel2.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page02DescLabel2 text:LOCALIZE(@"TutorialViewController_page2_label2") fontSize:13.f movePoint:CGPointMake(timeForPage(2)+90, 140)];
    
    //Page03
    self.page03TitleLabel1 = [[UILabel alloc] init];
    _page03TitleLabel1.numberOfLines = 1;
    [self addPageLabel:_page03TitleLabel1 text:LOCALIZE(@"TutorialViewController_page3_title1") fontSize:25.f movePoint:CGPointMake(timeForPage(3), -200)];

    self.page03ScreenShotImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page03_screenshot01"]];
    [self addPageImage:_page03ScreenShotImage1 size:CGSizeMake(-30, -30) movePoint:CGPointMake(timeForPage(3)-10, -70)];
    
    self.page03DescImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru02"]];
    [self addPageImage:_page03DescImage1 size:CGSizeMake(-10, -10) movePoint:CGPointMake(timeForPage(3)-10, -90)];
    self.page03DescLabel1 = [[UILabel alloc] init];
    _page03DescLabel1.numberOfLines = 2;
    _page03DescLabel1.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page03DescLabel1 text:LOCALIZE(@"TutorialViewController_page3_label1") fontSize:13.f movePoint:CGPointMake(timeForPage(3)+60, -150)];
    
    self.page03TitleLabel2 = [[UILabel alloc] init];
    _page03TitleLabel2.numberOfLines = 1;
    [self addPageLabel:_page03TitleLabel2 text:LOCALIZE(@"TutorialViewController_page3_title2") fontSize:25.f movePoint:CGPointMake(timeForPage(3), 60)];
    
    self.page03ScreenShotImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page03_screenshot02"]];
    [self addPageImage:_page03ScreenShotImage2 size:CGSizeMake(-30, -20) movePoint:CGPointMake(timeForPage(3)-10, 150)];
    
    self.page03DescImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maru01"]];
    [self addPageImage:_page03DescImage2 size:CGSizeMake(0, 0) movePoint:CGPointMake(timeForPage(3)+80, 140)];
    self.page03DescLabel2 = [[UILabel alloc] init];
    _page03DescLabel2.numberOfLines = 2;
    _page03DescLabel2.textColor = [UIColor HKMDarkOrangeColor];
    [self addPageLabel:_page03DescLabel2 text:LOCALIZE(@"TutorialViewController_page3_label2") fontSize:13.f movePoint:CGPointMake(timeForPage(3)+60, 170)];

    //Page04
    self.page04TitleLabel = [[UILabel alloc] init];
    _page04TitleLabel.numberOfLines = 1;
    [self addPageLabel:_page04TitleLabel text:LOCALIZE(@"TutorialViewController_page4_title") fontSize:25.f movePoint:CGPointMake(timeForPage(4), -100)];
    
    self.page04DescLabel = [[UILabel alloc] init];
    _page04DescLabel.numberOfLines = 0;
    [self addPageLabel:_page04DescLabel text:LOCALIZE(@"TutorialViewController_page4_label") fontSize:15.f movePoint:CGPointMake(timeForPage(4), 0)];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setTitle:LOCALIZE(@"TutorialViewController_page4_button") forState:UIControlStateNormal];
    startButton.frame = CGRectMake(0, 0, 100, 50);
    startButton.center = self.view.center;
    startButton.frame = CGRectOffset(startButton.frame,timeForPage(4), 50);
    [startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:startButton];
    
}

- (void)configureAnimation
{
    
    //page01
    [self page01Animation];
    
    //page02
    [self page02Animation];
    
    
    
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

- (IBAction)startButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
