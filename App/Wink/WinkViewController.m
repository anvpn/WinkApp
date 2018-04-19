//
//  ViewController.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface WinkViewController ()<GADAdDelegate,GADBannerViewDelegate>

@property (strong, nonatomic) WinkMessageBar *messageBar;

@end

@implementation WinkViewController
@synthesize messageBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(GADBannerView *)setUpAdvertisement
{
    GADBannerView *bannerView = [[GADBannerView alloc]
                  initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.delegate = self;
    //ca-app-pub-8111109588933645/5905217014 - Real
    //ca-app-pub-3940256099942544/6300978111 - Test
    bannerView.adUnitID = @"ca-app-pub-8111109588933645/5905217014";
    bannerView.rootViewController = self;
    //GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID,                       // All simulators
                //             @"AC98C820A50B4AD8A2106EDE96FB87D4" ];
    
    [bannerView loadRequest:[GADRequest request]];
    //UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    //[currentWindow addSubview:adView];
    
    return bannerView;
}

#pragma mark - Emoji Method
-(NSString *)encodeEmojis:(NSString *)strText
{
    NSString *uniText = [NSString stringWithUTF8String:[strText UTF8String]];
    
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
    return goodMsg;
}
-(NSString *)decodeEmojis:(NSString *)strText
{
    const char *jsonString = [strText UTF8String];
    
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    return goodMsg;
}

#pragma mark - KZMMessage Bar Methods
- (WinkMessageBar *)messageBar
{
    if(!messageBar)
    {
        messageBar = [[WinkMessageBar alloc] init];
    }
    
    return messageBar;
}

- (void)showErrorMessage:(NSString *)message belowView:(UIView *)viewDisplay
{
    CGRect messageBarFrame = self.messageBar.frame;
    
    messageBarFrame.origin.x    = CGRectGetMinX(viewDisplay.frame);
    messageBarFrame.origin.y    = CGRectGetMaxY(viewDisplay.frame) + 5;
    messageBarFrame.size.width  = CGRectGetWidth(viewDisplay.frame);
    messageBarFrame.size.height = 0;
    
    self.messageBar.frame       = messageBarFrame;
    self.messageBar.message     = message;
    self.messageBar.relatedView = viewDisplay;
    
    [self.messageBar prepareForError];
    
    [viewDisplay.superview addSubview:self.messageBar];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.messageBar.height = WinkValidationMsgHeight;
     }];
}

- (void)removeErrorMessageBelowView:(UIView *)viewDisplay
{
    if (self.messageBar.relatedView == viewDisplay && viewDisplay)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             self.messageBar.height = 0;
         }
                         completion:^(BOOL finished)
         {
             [self.messageBar removeFromSuperview];
         }];
    }
    else if (viewDisplay == nil)
    {
        [self.messageBar removeFromSuperview];
    }
}

#pragma mark - Alert Methods
- (void)showAlertWithMessage:(NSString *)message
{
    [WinkUtil showAlertFromController:self withMessage:message];
}

- (void)showAlertWithMessage:(NSString *)message andHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    [WinkUtil showAlertFromController:self withMessage:message andHandler:handler];
}
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
