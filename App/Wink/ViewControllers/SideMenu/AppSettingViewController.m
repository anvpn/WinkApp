//
//  AppSettingViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "AppSettingViewController.h"

@interface AppSettingViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;
@property (weak, nonatomic) IBOutlet UIImageView *imgvAllowMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgvAllowComment;
@property (weak, nonatomic) IBOutlet UIButton *btnWinkVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *vwGeneral;
@property (weak, nonatomic) IBOutlet UIView *vwAbout;
@property (weak, nonatomic) IBOutlet UIView *vwOthers;
@property (weak, nonatomic) IBOutlet UIView *vwBG;

@property (weak, nonatomic) IBOutlet UIView *View_About;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Version;



@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property BOOL isAllowMessage;
@property BOOL isAllowComment;


@end

@implementation AppSettingViewController
@synthesize sideMenu,scrlvBG,imgvAllowMsg,imgvAllowComment,btnWinkVersion,lblUserName,isAllowMessage,isAllowComment,vwGeneral,vwAbout,vwOthers,vwBG,btnBalance;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WinkUser *user = WinkGlobalObject.user;
    
    
//    NSLog(@"WinkGlobalObject.user.isAllowMessage :-%@",WinkGlobalObject.user.isAllowMessage);
    
    
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    _lbl_Version.text = [NSString stringWithFormat:@"Version %@",version];
    _View_About.hidden=YES;

    [btnWinkVersion setTitle:[NSString stringWithFormat:@"Wink v%@",version] forState:UIControlStateNormal];
    
    if(WinkGlobalObject.user.isAllowMessage)
    {
        [imgvAllowMsg setImage:[UIImage imageNamed:@"checked.png"]];
        isAllowMessage = true;
    }
    else
    {
        [imgvAllowMsg setImage:[UIImage imageNamed:@"checkbox.png"]];
        isAllowMessage = false;
    }
    if(WinkGlobalObject.user.isAllowComment)
    {
        [imgvAllowComment setImage:[UIImage imageNamed:@"checked.png"]];
        isAllowMessage = true;
    }
    else
    {
        [imgvAllowComment setImage:[UIImage imageNamed:@"checkbox.png"]];
        isAllowMessage = false;
    }
    lblUserName.text = WinkGlobalObject.user.userName;
    vwBG.frame = CGRectMake(vwBG.x, vwBG.y, vwBG.width, vwOthers.y+vwOthers.height);
    [scrlvBG setContentSize:CGSizeMake(scrlvBG.width, vwBG.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
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
- (IBAction)btnBalanceTap:(id)sender
{
    BuyCreditViewController *bvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"BuyCreditViewController"];
    bvc.creditBalance = WinkGlobalObject.user.balance;
    [self presentViewController:bvc animated:YES completion:nil];
}
- (IBAction)btnAllowMessageTap:(UIButton *)sender
{
    
    isAllowMessage = !isAllowMessage;
    
    [self setAllowMessage];
}
- (IBAction)btnAllowCommentTap:(id)sender
{
    isAllowComment = !isAllowComment;
    [self setAllowComment];
}
- (IBAction)btnPushNotifcationTap:(id)sender
{
    PushNotificationSettingsViewController *vc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"PushNotificationSettingsViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)btnChangePasswordTap:(id)sender
{
    ChangePasswordViewController *cpvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    
    [self presentViewController:cpvc animated:YES completion:nil];
}
- (IBAction)btnDeactivateAccTap:(id)sender
{
    ILikedViewController *ivc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ILikedViewController"];
    [self presentViewController:ivc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:ivc animated:NO];
//    DeactiveAccountViewController *davc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"DeactiveAccountViewController"];
//    
//    [self presentViewController:davc animated:YES completion:nil];
}
- (IBAction)btnBlockedListTap:(id)sender
{
    BlockedListViewController *bvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"BlockedListViewController"];
    
    [self presentViewController:bvc animated:YES completion:nil];
}
- (IBAction)btnSocialServiceTap:(id)sender
{
    ConnectWithFBViewController *fbvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"ConnectWithFBViewController"];
    
    [self presentViewController:fbvc animated:YES completion:nil];

}
- (IBAction)btnTermsOfUseTap:(id)sender
{
    TermsNConditionViewController *tvc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"TermsNConditionViewController"];
    
    [self presentViewController:tvc animated:YES completion:nil];

}
- (IBAction)btnAcknowledgementTap:(id)sender
{
    AcknowledgementViewController *avc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"AcknowledgementViewController"];
    
    [self presentViewController:avc animated:YES completion:nil];
    
}
- (IBAction)btnWinkVersionTap:(id)sender
{
    _View_About.hidden = NO;
}
- (IBAction)btnLogoutTap:(id)sender
{
    [WinkUtil logoutUser];
}
- (IBAction)btnContactUsTap:(id)sender
{
    ContactUsViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}
- (IBAction)btn_ok:(id)sender
{
    _View_About.hidden=YES;
}
#pragma Mark - Webservice Method
-(void)setAllowMessage
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowMessages" : [NSNumber numberWithBool:isAllowMessage]
                               };
        [WinkWebServiceAPI setAllowMessage:dict completionHAndler:^(WinkAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                WinkGlobalObject.user.isAllowMessage = isAllowMessage;
                if(isAllowMessage)
                {
                    [imgvAllowMsg setImage:[UIImage imageNamed:@"checked.png"]];
                }
                else
                {
                    [imgvAllowMsg setImage:[UIImage imageNamed:@"checkbox.png"]];
                }
            }
            else
            {
                [self showAlertWithMessage:response.message];
                isAllowMessage = !isAllowMessage;
            }
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)setAllowComment
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowPhotosComments" : [NSNumber numberWithBool:isAllowComment]
                               };
        [WinkWebServiceAPI setAllowPhotosComment:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.isAllowComment = isAllowComment;
                 if(isAllowComment)
                 {
                     [imgvAllowComment setImage:[UIImage imageNamed:@"checked.png"]];
                 }
                 else
                 {
                     [imgvAllowComment setImage:[UIImage imageNamed:@"checkbox.png"]];
                 }
             }
             else
             {
                 [self showAlertWithMessage:response.message];
                 isAllowComment = !isAllowComment;
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
@end
