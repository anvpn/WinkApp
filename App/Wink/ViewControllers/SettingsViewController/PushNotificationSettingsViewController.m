//
//  PushNotificationSettingsViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "PushNotificationSettingsViewController.h"

@interface PushNotificationSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvLikes;
@property (weak, nonatomic) IBOutlet UIImageView *imgvFriendRequest;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPrivateMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgvGifts;

@property BOOL isLikes;
@property BOOL isFriendRequest;
@property BOOL isPrivateMessage;
@property BOOL isGifts;

@end

@implementation PushNotificationSettingsViewController
@synthesize isLikes,isFriendRequest,isPrivateMessage,isGifts,imgvLikes,imgvFriendRequest,imgvPrivateMessage,imgvGifts;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    if(WinkGlobalObject.user.isAllowLikesGCM)
    {
        [imgvLikes setImage:[UIImage imageNamed:@"checked.png"]];
        isLikes = true;
    }
    else
    {
        [imgvLikes setImage:[UIImage imageNamed:@"checkbox.png"]];
        isLikes = false;
    }
    if(WinkGlobalObject.user.isAllowFollowersGCM)
    {
        [imgvFriendRequest setImage:[UIImage imageNamed:@"checked.png"]];
        isFriendRequest = true;
    }
    else
    {
        [imgvFriendRequest setImage:[UIImage imageNamed:@"checkbox.png"]];
        isFriendRequest = false;
    }
    if(WinkGlobalObject.user.isAllowMessagesGCM)
    {
        [imgvPrivateMessage setImage:[UIImage imageNamed:@"checked.png"]];
        isPrivateMessage = true;
    }
    else
    {
        [imgvPrivateMessage setImage:[UIImage imageNamed:@"checkbox.png"]];
        isPrivateMessage = false;
    }
    if(WinkGlobalObject.user.isAllowGiftGCM)
    {
        [imgvGifts setImage:[UIImage imageNamed:@"checked.png"]];
        isGifts = true;
    }
    else
    {
        [imgvGifts setImage:[UIImage imageNamed:@"checkbox.png"]];
        isGifts = false;
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [WinkGlobalObject.user saveInUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnLikesTap:(id)sender
{
    isLikes = !isLikes;
    [self setLikesGCM];
}
- (IBAction)btnFrndRequestTap:(id)sender
{
    isFriendRequest = !isFriendRequest;
    [self setFriendRequestGCM];
}
- (IBAction)btnPrivateMsgTap:(id)sender
{
    isPrivateMessage = !isPrivateMessage;
    [self setPrivateMsgGCM];
}
- (IBAction)btnGFiftsTap:(id)sender
{
    isGifts = !isGifts;
    [self setGiftGCM];
}

-(void)setLikesGCM
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowLikesGCM" : [NSNumber numberWithBool:isLikes]
                               };
        [WinkWebServiceAPI setAllowLikeGCM:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.isAllowLikesGCM = isLikes;
                 [WinkGlobalObject.user saveInUserDefaults];

                 if(isLikes)
                 {
                     [imgvLikes setImage:[UIImage imageNamed:@"checked.png"]];
                 }
                 else
                 {
                     [imgvLikes setImage:[UIImage imageNamed:@"checkbox.png"]];
                 }
             }
             else if(response.message)
             {
                 [self showAlertWithMessage:response.message];
                 isLikes = !isLikes;
             }
             else
             {
                 [self showAlertWithMessage:response.error.localizedDescription];
             }
         }];
        
        

    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }

}
-(void)setFriendRequestGCM
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowFollowersGCM" : [NSNumber numberWithBool:isFriendRequest]
                               };
        [WinkWebServiceAPI setAllowFriendRequestGCM:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.isAllowFollowersGCM = isFriendRequest;
                 [WinkGlobalObject.user saveInUserDefaults];

                 if(isFriendRequest)
                 {
                     [imgvFriendRequest setImage:[UIImage imageNamed:@"checked.png"]];
                 }
                 else
                 {
                     [imgvFriendRequest setImage:[UIImage imageNamed:@"checkbox.png"]];
                 }
             }
             else
             {
                 [self showAlertWithMessage:response.message];
                 isFriendRequest = !isFriendRequest;
             }
             
             [WinkGlobalObject.user saveInUserDefaults];

         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}
-(void)setPrivateMsgGCM
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowMessagesGCM" : [NSNumber numberWithBool:isPrivateMessage]
                               };
        [WinkWebServiceAPI setAllowPrivateMsgGCM:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.isAllowMessagesGCM = isPrivateMessage;
                 [WinkGlobalObject.user saveInUserDefaults];

                 if(isPrivateMessage)
                 {
                     [imgvPrivateMessage setImage:[UIImage imageNamed:@"checked.png"]];
                 }
                 else
                 {
                     [imgvPrivateMessage setImage:[UIImage imageNamed:@"checkbox.png"]];
                 }
             }
             else
             {
                 [self showAlertWithMessage:response.message];
                 isPrivateMessage = !isPrivateMessage;
             }
             
             [WinkGlobalObject.user saveInUserDefaults];

         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}
-(void)setGiftGCM
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyClientId : WinkGlobalObject.user.ID,
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"allowGiftsGCM" : [NSNumber numberWithBool:isGifts]
                               };
        [WinkWebServiceAPI setAllowPrivateMsgGCM:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.isAllowGiftGCM = isGifts;
                 [WinkGlobalObject.user saveInUserDefaults];

                 if(isGifts)
                 {
                     [imgvGifts setImage:[UIImage imageNamed:@"checked.png"]];
                 }
                 else
                 {
                     [imgvGifts setImage:[UIImage imageNamed:@"checkbox.png"]];
                 }
             }
             else
             {
                 [self showAlertWithMessage:response.message];
                 isGifts = !isGifts;
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}



@end
