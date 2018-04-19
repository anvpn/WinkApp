//
//  ContainerViewController.m
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()<GADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *adView;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation ContainerViewController
@synthesize vwcontainer,adView,bannerView,childVc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!WinkGlobalObject.user.isAdmob)
    {
        [self setUpAdvertisement];
    }
    //[self setUpAdvertisement];
    /*if(!childVc)
    {
        childVc = (WinkStreamViewController *)[WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"WinkStreamViewController"];
    }
    [self addChildViewController:childVc];
    childVc.view.frame = CGRectMake(0, 0, vwcontainer.frame.size.width, vwcontainer.frame.size.height);
    [vwcontainer addSubview:childVc.view];
    [childVc didMoveToParentViewController:self];*/
    
}

- (void) displayContentController: (UIViewController*) content
{
    [self addChildViewController:content];
    content.view.frame = CGRectMake(0, 0, vwcontainer.frame.size.width, vwcontainer.frame.size.height);
    [vwcontainer addSubview:content.view];
    [content didMoveToParentViewController:self];
}

/*-(void)setUpAdvertisement
{
    bannerView = [[GADBannerView alloc]
                  initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.delegate = self;
    [adView addSubview:self.bannerView];
    //ca-app-pub-8111109588933645/5905217014 - Real
    //ca-app-pub-3940256099942544/6300978111 - Test
    bannerView.adUnitID = @"ca-app-pub-8111109588933645/5905217014";
    bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,                       // All simulators
                             @"AC98C820A50B4AD8A2106EDE96FB87D4" ];
    
    [bannerView loadRequest:[GADRequest request]];
    
    
    //UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    //[currentWindow addSubview:adView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

#pragma mark  - GADBannerViewDelegate method
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)GADadView {
    NSLog(@"adViewDidReceiveAd");
    GADadView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        GADadView.alpha = 1;
    }];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}


@end
