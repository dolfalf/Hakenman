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
#import <PBFlatUI/PBFlatButton.h>


#define NUMBER_OF_PAGES 5

#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))

@interface TutorialViewController ()  <UIScrollViewDelegate> {
    
    UIPageControl *pageControl;
}

@property (nonatomic, strong) IFTTTAnimator *animator;

//page01
@property (nonatomic, strong) UIImageView *page01LogoImage;
@property (nonatomic, strong) UILabel *page01TitleLabel;
@property (nonatomic, strong) UILabel *page01SubtitleLabel;

//page02
@property (nonatomic, strong) UILabel *page02TitleLabel;
@property (nonatomic, strong) UILabel *page02DescLabel;
@property (nonatomic, strong) UIImageView *page02ScreenShotImage;

//page03
@property (nonatomic, strong) UILabel *page03TitleLabel;
@property (nonatomic, strong) UILabel *page03DescLabel;
@property (nonatomic, strong) UIImageView *page03ScreenShotImage;

//page04
@property (nonatomic, strong) UILabel *page04TitleLabel;
@property (nonatomic, strong) UILabel *page04DescLabel;
@property (nonatomic, strong) UIImageView *page04ScreenShotImage;

//page05(last page)
@property (nonatomic, strong) UILabel *page05TitleLabel;
@property (nonatomic, strong) UILabel *page05DescLabel;

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
    
    // ページコントロールのインスタンス化
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 300) / 2,
                                                                 CGRectGetHeight(self.view.frame) - 50,
                                                                 300, 50)];
    
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    // ページ数を設定
    pageControl.numberOfPages = NUMBER_OF_PAGES;
    
    // 現在のページを設定
    pageControl.currentPage = 0;
    
    // ページコントロールをタップされたときに呼ばれるメソッドを設定
    pageControl.userInteractionEnabled = YES;
//    [pageControl addTarget:self
//                    action:@selector(pageControl_Tapped:)
//          forControlEvents:UIControlEventValueChanged];
    
    // ページコントロールを貼付ける
    [self.view addSubview:pageControl];
    
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

#pragma mark - UIScroll delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    if ((NSInteger)fmod(self.scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        pageControl.currentPage = self.scrollView.contentOffset.x / pageWidth;
    }
}

#pragma mark - pravate methods
- (void)addPageLabel:(UILabel *)lbl text:(NSString *)text fontSize:(float)sz point:(CGPoint)pt {
    
    lbl.text = text;
    lbl.font = [UIFont fontWithName:@"Helvetica-Light" size:sz];
    [lbl sizeToFit];
    lbl.textAlignment = NSTextAlignmentLeft;
//    lbl.backgroundColor = [UIColor yellowColor];//test
    lbl.frame = CGRectMake(pt.x, pt.y, lbl.frame.size.width, lbl.frame.size.height);
    [self.scrollView addSubview:lbl];
    
}

- (void)addPageCenterLabel:(UILabel *)lbl text:(NSString *)text fontSize:(float)sz {
    
    lbl.text = text;
    lbl.font = [UIFont fontWithName:@"Helvetica-Light" size:sz];
    [lbl sizeToFit];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.backgroundColor = [UIColor yellowColor];//test
    lbl.center = self.view.center;
    
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
    
    [self alphaEffect:1 control:_page01TitleLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01TitleLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01TitleLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01TitleLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01TitleLabel.frame,0,0)]
                       ]
             control:_page01TitleLabel];
    
    
    [self alphaEffect:1 control:_page01SubtitleLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page01SubtitleLabel.frame, 0, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page01SubtitleLabel.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page01SubtitleLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page01SubtitleLabel.frame,0,0)],
                       ]
             control:_page01SubtitleLabel];
    
    
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
    
    
    [self alphaEffect:2 control:_page02ScreenShotImage];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02ScreenShotImage.frame, timeForPage(2), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02ScreenShotImage.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02ScreenShotImage.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02ScreenShotImage.frame,0,0)],
                       ]
             control:_page02ScreenShotImage];
    
    
    [self alphaEffect:2 control:_page02DescLabel];
    
    [self moveEffect:@[
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(_page02DescLabel.frame, timeForPage(4), 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(_page02DescLabel.frame, timeForPage(1) *-1, 0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(_page02DescLabel.frame,0,0)],
                       [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(_page02DescLabel.frame,0,0)],
                       ]
             control:_page02DescLabel];
    
}

- (void)page03Animation {

}

- (void)page04Animation {
    
}

- (void)page05Animation {
    
}

#pragma mark - animation methods
- (void)placeViews
{
    //Page01
    self.page01LogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _page01LogoImage.layer.cornerRadius = 10.0f;
    _page01LogoImage.layer.shadowOpacity = 0.8;
    _page01LogoImage.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self addPageImage:_page01LogoImage size:CGSizeMake(80, 80) movePoint:CGPointMake(0, -100)];
    
    self.page01TitleLabel = [[UILabel alloc] init];
    
    [self addPageCenterLabel:_page01TitleLabel
                  text:LOCALIZE(@"TutorialViewController_page1_title")
              fontSize:28.f];
    
    self.page01SubtitleLabel = [[UILabel alloc] init];
    _page01SubtitleLabel.textColor = [UIColor grayColor];
    [self addPageCenterLabel:_page01SubtitleLabel
                  text:LOCALIZE(@"TutorialViewController_page1_sub_title")
              fontSize:15.f];

    _page01SubtitleLabel.frame = CGRectMake(_page01SubtitleLabel.frame.origin.x,
                                            _page01TitleLabel.frame.origin.y + 40.f,
                                            _page01SubtitleLabel.frame.size.width,
                                            _page01SubtitleLabel.frame.size.height);
    
    
    //Page02
    self.page02TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page02TitleLabel.numberOfLines = 1;
    [self addPageCenterLabel:_page02TitleLabel
                        text:LOCALIZE(@"TutorialViewController_page2_title")
                    fontSize:25.f];
    
    _page02TitleLabel.frame = CGRectMake(timeForPage(2) + _page02TitleLabel.frame.origin.x,
                                            30.f,
                                            _page02TitleLabel.frame.size.width,
                                            _page02TitleLabel.frame.size.height);
    
    self.page02DescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page02DescLabel.numberOfLines = 10;
    _page02DescLabel.textColor = [UIColor grayColor];
    [self addPageLabel:_page02DescLabel
                  text:LOCALIZE(@"TutorialViewController_page2_desc_label")
              fontSize:15.f
                 point:CGPointMake(timeForPage(2)+10.f, 70.f)];
    
    self.page02ScreenShotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page02_screenshot"]];
    [_page02ScreenShotImage.layer setBorderColor:[UIColor grayColor].CGColor];
    [_page02ScreenShotImage.layer setBorderWidth:1.0];
    [self addPageImage:_page02ScreenShotImage size:CGSizeMake(20, 20) movePoint:CGPointMake(timeForPage(2), 20)];
    
    
    
    //Page03
    self.page03TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page03TitleLabel.numberOfLines = 1;
    [self addPageCenterLabel:_page03TitleLabel
                        text:LOCALIZE(@"TutorialViewController_page3_title")
                    fontSize:25.f];

    _page03TitleLabel.frame = CGRectMake(timeForPage(3) + _page03TitleLabel.frame.origin.x,
                                         30.f,
                                         _page03TitleLabel.frame.size.width,
                                         _page03TitleLabel.frame.size.height);
    
    self.page03DescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page03DescLabel.numberOfLines = 10;
    _page03DescLabel.textColor = [UIColor grayColor];
    [self addPageLabel:_page03DescLabel
                  text:LOCALIZE(@"TutorialViewController_page3_desc_label")
              fontSize:13.f
                 point:CGPointMake(timeForPage(3)+10.f, 70.f)];

    
    self.page03ScreenShotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page03_screenshot"]];
    [_page03ScreenShotImage.layer setBorderColor:[UIColor grayColor].CGColor];
    [_page03ScreenShotImage.layer setBorderWidth:1.0];
    [self addPageImage:_page03ScreenShotImage size:CGSizeMake(20, 20) movePoint:CGPointMake(timeForPage(3), 20)];
    
    //Page04
    self.page04TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page04TitleLabel.numberOfLines = 2;
    [self addPageCenterLabel:_page04TitleLabel
                        text:LOCALIZE(@"TutorialViewController_page4_title")
                    fontSize:25.f];
    
    _page04TitleLabel.frame = CGRectMake(timeForPage(4) + _page04TitleLabel.frame.origin.x,
                                         25.f,
                                         _page04TitleLabel.frame.size.width,
                                         _page04TitleLabel.frame.size.height);
    
    self.page04DescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page04DescLabel.numberOfLines = 10;
    _page04DescLabel.textColor = [UIColor grayColor];
    [self addPageLabel:_page04DescLabel
                  text:LOCALIZE(@"TutorialViewController_page4_desc_label")
              fontSize:15.f
            point:CGPointMake(timeForPage(4)+10.f, 70.f)];

    
    self.page04ScreenShotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page04_screenshot"]];
    [_page04ScreenShotImage.layer setBorderColor:[UIColor grayColor].CGColor];
    [_page04ScreenShotImage.layer setBorderWidth:1.0];
    [self addPageImage:_page04ScreenShotImage size:CGSizeMake(20, 20) movePoint:CGPointMake(timeForPage(4), 20)];
    
    //Page05
    self.page05TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page05TitleLabel.numberOfLines = 2;
    [self addPageCenterLabel:_page05TitleLabel
                        text:LOCALIZE(@"TutorialViewController_page5_title")
                    fontSize:25.f];
    
    _page05TitleLabel.frame = CGRectMake(timeForPage(5) + _page05TitleLabel.frame.origin.x,
                                         _page05TitleLabel.frame.origin.y-100.f,
                                         _page05TitleLabel.frame.size.width,
                                         _page05TitleLabel.frame.size.height);
    
    self.page05DescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _page05DescLabel.numberOfLines = 10;
    _page05DescLabel.textColor = [UIColor grayColor];
    [self addPageLabel:_page05DescLabel
                  text:LOCALIZE(@"TutorialViewController_page5_desc_label")
              fontSize:15.f
                 point:CGPointMake(timeForPage(5)+10.f, _page05TitleLabel.frame.origin.y + 50.f)];
    
    PBFlatButton *startButton = [[PBFlatButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    startButton.mainColor = [UIColor HKMBlueColor];
    [startButton setTitleColor:[UIColor HKMBlueColor] forState:UIControlStateNormal];
    [startButton setTitle:LOCALIZE(@"TutorialViewController_page5_start_button") forState:UIControlStateNormal];
    startButton.center = self.view.center;
    startButton.frame = CGRectOffset(startButton.frame,timeForPage(5), 50);
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
