//
//  UpgradesViewController.m
//  Wink
//
//  Created by Apple on 13/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "UpgradesViewController.h"

@interface UpgradesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblCredits;
@property (weak, nonatomic) IBOutlet UIButton *btnGhostMode;
@property (weak, nonatomic) IBOutlet UILabel *lblGhostMode;
@property (weak, nonatomic) IBOutlet UIButton *btnVerifiedBadge;
@property (weak, nonatomic) IBOutlet UILabel *lblVerifiedBadge;
@property (weak, nonatomic) IBOutlet UIButton *btndisableAds;
@property (weak, nonatomic) IBOutlet UILabel *lblDisableAds;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBg;
@property (weak, nonatomic) IBOutlet UIView *vwCredits;
@property (weak, nonatomic) IBOutlet UIView *vwGhostMode;
@property (weak, nonatomic) IBOutlet UIView *vwVarifiedBadge;
@property (weak, nonatomic) IBOutlet UIView *vwDisableAd;
@property (weak, nonatomic) IBOutlet UILabel *lblGhostModeExpire;
@property (weak, nonatomic) IBOutlet UILabel *lblVarifiedExpire;
@property (weak, nonatomic) IBOutlet UILabel *lblDisableAdExpire;
@property (weak, nonatomic) IBOutlet UIView *vwFame;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;
@property (strong, nonatomic) NSDictionary *adsDetail;
@property (strong, nonatomic) NSDictionary *vBadgeDetail;
@property (strong, nonatomic) NSDictionary *ghostModeDetail;

@end

@implementation UpgradesViewController

@synthesize sideMenu,btnGhostMode,lblGhostMode,btnVerifiedBadge,lblVerifiedBadge,btndisableAds,lblDisableAds,scrlvBg,vwCredits,vwGhostMode,vwVarifiedBadge,vwDisableAd,lblCredits,adsDetail,vBadgeDetail,ghostModeDetail,btnBalance;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    //[btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwDisableAd.y + vwDisableAd.height)];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if([WinkUtil reachable])
    {
        [self getUpgradeDetail];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
    
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    [self presentViewController:cvc animated:YES completion:nil];

}

-(void)prepareView
{
    lblCredits.text = [NSString stringWithFormat:@"Credits (%d)",WinkGlobalObject.user.balance];
    
    if(WinkGlobalObject.user.isGhost)
    {
        btnGhostMode.hidden = YES;
        lblGhostMode.text = @"Ghost Mode Enabled!";
        lblGhostMode.textColor = [UIColor greenColor];
    }
    if(WinkGlobalObject.user.verify)
    {
        btnVerifiedBadge.hidden = YES;
        lblVerifiedBadge.text = @"Verified Badge Enabled!";
        lblVerifiedBadge.textColor = [UIColor greenColor];
    }
    if(!WinkGlobalObject.user.isAdmob) // 1 - display ad 0- don't display
    {
        btndisableAds.hidden = YES;
        lblDisableAds.text = @"Ads disabled!";
        lblDisableAds.textColor = [UIColor greenColor];
    }

    if([ghostModeDetail isKindOfClass:[NSDictionary class]])
    {
        _lblGhostModeExpire.hidden = NO;
        if([ghostModeDetail[@"status"]isEqualToString:@"active"])
        {
            _lblGhostModeExpire.text = [NSString stringWithFormat:@"Expire on : %@",ghostModeDetail[@"expire_date"]];
            _lblGhostModeExpire.textColor = [UIColor greenColor];
            
        }
        else if ([ghostModeDetail[@"status"]isEqualToString:@"expired"])
        {
            _lblGhostModeExpire.text = [NSString stringWithFormat:@"Expired on : %@",ghostModeDetail[@"expire_date"]];
            _lblGhostModeExpire.textColor = [UIColor redColor];
        }
    }
    else
    {
        _lblGhostModeExpire.hidden = YES;
    }
    if([adsDetail isKindOfClass:[NSDictionary class]])
    {
        _lblDisableAdExpire.hidden = NO;

        if([adsDetail[@"status"]isEqualToString:@"active"])
        {
            _lblDisableAdExpire.text = [NSString stringWithFormat:@"Expire on : %@",adsDetail[@"expire_date"]];
            _lblDisableAdExpire.textColor = [UIColor greenColor];
            
        }
        else if ([adsDetail[@"status"]isEqualToString:@"expired"])
        {
            _lblDisableAdExpire.text = [NSString stringWithFormat:@"Expired on : %@",adsDetail[@"expire_date"]];
            _lblDisableAdExpire.textColor = [UIColor redColor];
        }
    }
    else
    {
         _lblDisableAdExpire.hidden = YES;
    }
    if([vBadgeDetail isKindOfClass:[NSDictionary class]])
    {
        _lblVarifiedExpire.hidden = NO;
        if([vBadgeDetail[@"status"]isEqualToString:@"active"])
        {
            _lblVarifiedExpire.text = [NSString stringWithFormat:@"Expire on : %@",vBadgeDetail[@"expire_date"]];
            _lblVarifiedExpire.textColor = [UIColor greenColor];
            
        }
        else if ([vBadgeDetail[@"status"]isEqualToString:@"expired"])
        {
            _lblVarifiedExpire.text = [NSString stringWithFormat:@"Expired on : %@",vBadgeDetail[@"expire_date"]];
            _lblVarifiedExpire.textColor = [UIColor redColor];
        }
    }
    else
    {
        _lblVarifiedExpire.hidden = YES;
    }
}
-(void)getUpgradeDetail
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken: WinkGlobalObject.accessToken
                           };
    [WinkWebServiceAPI getUpgradeDetail:dict completionHAndler:^(WinkAPIResponse *response, NSDictionary *dict)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            ghostModeDetail = dict[@"ghostModeDetails"];
            adsDetail = dict[@"disabledAdsDetails"];
            vBadgeDetail = dict[@"verifiedBadgeDetails"];
            [self prepareView];
        }
        else if(response.message)
        {
            [self showAlertWithMessage:response.message];
            [self prepareView];
        }
        else
        {
            [self showAlertWithMessage:response.error.localizedDescription];
            [self prepareView];
        }
        
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [WinkGlobalObject.user saveInUserDefaults];
}
- (IBAction)btnMenuTap:(id)sender
{
    if(!sideMenu)
    {
        sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideMenu.view];
    }
    [sideMenu showMenu];
}

- (IBAction)BtnBuyCreditTap:(id)sender
{
    BuyCreditViewController *bcvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"BuyCreditViewController"];
    
    bcvc.creditBalance = WinkGlobalObject.user.balance;
    
    [self presentViewController:bcvc animated:YES completion:nil];
}
- (IBAction)btnGhostModeTap:(id)sender
{
    if(WinkGlobalObject.user.balance < WinkGlobalObject.Ghost_Mode_Cost)
    {
        [self showAlertWithMessage:@"Not enough credits"];
    }
    else
    {
        if([WinkUtil reachable])
        {
            [self setGhostMode];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
}
- (IBAction)btnVerifiedTap:(id)sender
{
    if(WinkGlobalObject.user.balance < WinkGlobalObject.Verified_Badge_Cost)
    {
        [self showAlertWithMessage:@"Not enough credits"];
    }
    else
    {
        if([WinkUtil reachable])
        {
            [self setVarifiedBadge];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
}
- (IBAction)btnFameTap:(id)sender
{
    FameViewController *bcvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"FameViewController"];
    
    [self presentViewController:bcvc animated:YES completion:nil];
}

- (IBAction)btnDisableAdTap:(id)sender
{
    if(WinkGlobalObject.user.balance < WinkGlobalObject.Disable_Ad_Cost)
    {
        [self showAlertWithMessage:@"Not enough credits"];
    }
    else
    {
        if([WinkUtil reachable])
        {
            [self disableAd];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
}

-(void)setGhostMode
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"cost" : [NSNumber numberWithInt:WinkGlobalObject.Ghost_Mode_Cost]
                           };
    [WinkWebServiceAPI setGhostMode:dict completionHAndler:^(WinkAPIResponse *response)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             [self showAlertWithMessage:@"Ghost mode enabled successfuly"];
             WinkGlobalObject.user.isGhost = YES;
             WinkGlobalObject.user.balance -= WinkGlobalObject.Ghost_Mode_Cost;
             [WinkGlobalObject.user saveInUserDefaults];
             //btnGhostMode.hidden = YES;
             //lblGhostMode.text = @"Ghost Mode Enabled!";
             //lblGhostMode.textColor = [UIColor greenColor];
             [self getUpgradeDetail];
         }
         else if(response.message)
         {
             [self showAlertWithMessage:response.message];
         }
        
    }];
}
-(void)setVarifiedBadge
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"cost" : [NSNumber numberWithInt:WinkGlobalObject.Verified_Badge_Cost]
                           };
    [WinkWebServiceAPI setVerifiedBadge:dict completionHAndler:^(WinkAPIResponse *response)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             [self showAlertWithMessage:@"Varified badge enabled successfuly"];
             WinkGlobalObject.user.verify = YES;
             WinkGlobalObject.user.balance -= WinkGlobalObject.Verified_Badge_Cost;
              [WinkGlobalObject.user saveInUserDefaults];
             //btnVerifiedBadge.hidden = YES;
             //lblVerifiedBadge.text = @"Verified Badge Enabled!";
             //lblVerifiedBadge.textColor = [UIColor greenColor];
              [self getUpgradeDetail];
         }
         else
         {
             [self showAlertWithMessage:response.message];
         }
         
     }];
}
-(void)disableAd
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"cost" : [NSNumber numberWithInt:WinkGlobalObject.Disable_Ad_Cost]
                           };
    [WinkWebServiceAPI disabledAd:dict completionHAndler:^(WinkAPIResponse *response)
     {
         if(response.code == RCodeSuccess)
         {
             [SVProgressHUD dismiss];
             [self showAlertWithMessage:@"Ads disabled successfuly"];
             
             WinkGlobalObject.user.isAdmob = NO;
             WinkGlobalObject.user.balance -= WinkGlobalObject.Disable_Ad_Cost;
             
             [WinkGlobalObject.user saveInUserDefaults];
            // btndisableAds.hidden = YES;
             //lblDisableAds.text = @"Ads disabled!";
             //lblDisableAds.textColor = [UIColor greenColor];
             [self getUpgradeDetail];
         }
         else if(response.message)
         {
             [self showAlertWithMessage:response.message];
         }
         else
         {
             [self showAlertWithMessage:response.error.localizedDescription];
         }
         
     }];
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
