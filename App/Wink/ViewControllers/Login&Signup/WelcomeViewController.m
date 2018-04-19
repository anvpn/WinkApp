//
//  WelcomeViewController.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    int Index;
    UIScrollView * bgScrollView;
    NSArray *Img_Arr;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *img_Logo;
@property (weak, nonatomic) IBOutlet UIPageControl *Page;
- (IBAction)PageChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img_back;

@end

@implementation WelcomeViewController

@synthesize btnSignUp,btnLogin;

- (void)viewDidLoad
{
    [super viewDidLoad];
    btnSignUp.layer.cornerRadius = 10.0;
    btnSignUp.clipsToBounds = YES;
    btnSignUp.layer.borderWidth = 3;
    btnSignUp.layer.borderColor = [UIColor whiteColor].CGColor;
    btnLogin.layer.cornerRadius = 10.0;
    btnLogin.clipsToBounds = YES;
    btnLogin.layer.borderWidth = 3;
    btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    //btnLogin.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    [self popUpZoomIn];
    //Page control
    Img_Arr = @[@"img_1.png", @"img_2.png", @"img_3.png"];
    self.Page.numberOfPages = Img_Arr.count;
    self.Page.currentPage = 0;
    _img_back.image = [UIImage imageNamed:[Img_Arr objectAtIndex:self.Page.currentPage]];
    Index = 0;
    //Swipe Left
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    //Swipe Right
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(methodB:) userInfo:nil repeats:YES];
}
- (void) methodB:(NSTimer *)timer
{
    if (Index < 2)
    {
        self.Page.currentPage ++;
        Index = Index+1;
        [UIView transitionWithView:_img_back
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _img_back.image = [UIImage imageNamed:[Img_Arr objectAtIndex:self.Page.currentPage]];
                        } completion:^(BOOL finished) {
                            
                        }];
    }
}
- (void)popUpZoomIn{
    _img_Logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:1.0
                     animations:^{
                         _img_Logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         [self popZoomOut];
                     }];
}
- (void)popZoomOut
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         _img_Logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                     } completion:^(BOOL finished){
                         //_img_Logo.hidden = TRUE;
                         [self popUpZoomIn];
                     }];
}
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (Index < 2)
    {
        self.Page.currentPage ++;
        Index = Index+1;
        [UIView transitionWithView:_img_back
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _img_back.image = [UIImage imageNamed:[Img_Arr objectAtIndex:self.Page.currentPage]];
                        } completion:^(BOOL finished) {
                            
                        }];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (Index > 0 )
    {
        Index = Index-1;
        self.Page.currentPage --;
        [UIView transitionWithView:_img_back
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _img_back.image = [UIImage imageNamed:[Img_Arr objectAtIndex:self.Page.currentPage]];
                        } completion:^(BOOL finished) {
                            
                        }];
    }
}

- (IBAction)PageChange:(id)sender
{
    _img_back.image = [UIImage imageNamed:[Img_Arr objectAtIndex:self.Page.currentPage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)btnSignUpTap:(id)sender
{
    RootSignupViewController *svc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"RootSignupViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)btnLoginTap:(id)sender
{
    LoginViewController *lvc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController pushViewController:lvc animated:YES];
}
@end
