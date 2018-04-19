//
//  ConnectWithFBViewController.m
//  Wink
//
//  Created by Apple on 24/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ConnectWithFBViewController.h"

@interface ConnectWithFBViewController ()<FBSDKGraphRequestConnectionDelegate,FBSDKLoginButtonDelegate>


@property BOOL isConnected;
@property UIColor *normalColor;
@property (weak, nonatomic) IBOutlet UILabel *lblText;

@property (strong, nonatomic) FBSDKLoginButton *btnFBConnect;
@end

@implementation ConnectWithFBViewController
@synthesize isConnected,lblText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    if([WinkUtil reachable]){
        _btnFBConnect = [[FBSDKLoginButton alloc]init];
        
        _btnFBConnect.readPermissions =
        @[@"public_profile", @"email", @"user_friends"];
        
        _btnFBConnect.width = 200;
        
        _btnFBConnect.frame = CGRectMake(self.view.frame.size.width/2 - _btnFBConnect.frame.size.width/2-30,lblText.y + lblText.height + 40 , 260, 40);
        _btnFBConnect.delegate = self;
        
        [self.view addSubview:_btnFBConnect];
        
        if([WinkGlobalObject.user.fb_id isEqualToString:@""])
        {
            isConnected = YES;
            //[_btnFBConnect setTitle:@"REMOVE CONNECTION" forState:UIControlStateNormal];
            //_btnFBConnect.backgroundColor = [UIColor redColor];
        }
        else
        {
            isConnected = NO;
            //[_btnFBConnect setTitle:@"Connect with facebook" forState:UIControlStateNormal];
        }
        _btnFBConnect.layer.cornerRadius = 5.0;
        _btnFBConnect.clipsToBounds = YES;
    }
    else{
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnFBConnectTap:(id)sender
{
    /*if(isConnected)
    {
        if([WinkUtil reachable])
        {
            [self disconnectToFacebbok];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
    else
    {
        if([WinkUtil reachable])
        {
            NSString *access_token=[FBSDKAccessToken currentAccessToken].tokenString;
        
            [[[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:@{ @"fields": @"id,picture"} tokenString:access_token version:nil HTTPMethod:@"GET"]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
             {
                 
             }];
            
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,id,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"%@",result[@"email"]);
                // [self connectToFacebook:result[@"email"] FirstNAme:result[@"name"] andId:result[@"id"]];
                 [self connectToFacebook:result[@"email"] FirstName:result[@"name"] adID:result[@"id"]];
             }
         }];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }*/
}
-(void)disconnectToFacebbok
{
    if([WinkUtil reachable]){
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyClientId : @"1"
                               };
        
        [WinkWebServiceAPI disconnectFromFacebook:dict completionHandler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if(response.code == RCodeSuccess)
             {
                 //[_btnFBConnect setTitle:@"Connect with facebook" forState:UIControlStateNormal];
                 //_btnFBConnect.backgroundColor = _normalColor;
                 isConnected = NO;
                 WinkGlobalObject.user.fb_id = @"";
                 [WinkGlobalObject.user saveInUserDefaults];
                 lblText.text = @"Connect this account with social network";
             }
             else if(response.message)
             {
                 [self showAlertWithMessage:response.message];
             }
             
         }];
    }
    else {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
//    [SVProgressHUD show];
//    NSDictionary *dict = @{
//                           UKeyAccountId : WinkGlobalObject.user.ID,
//                           UKeyAccessToken : WinkGlobalObject.accessToken,
//                           UKeyClientId : @"1"
//                           };
//    
//    [WinkWebServiceAPI disconnectFromFacebook:dict completionHandler:^(WinkAPIResponse *response)
//    {
//        [SVProgressHUD dismiss];
//        
//        if(response.code == RCodeSuccess)
//        {
//            //[_btnFBConnect setTitle:@"Connect with facebook" forState:UIControlStateNormal];
//            //_btnFBConnect.backgroundColor = _normalColor;
//            isConnected = NO;
//            WinkGlobalObject.user.fb_id = @"";
//            [WinkGlobalObject.user saveInUserDefaults];
//            lblText.text = @"Connect this account with social network";
//        }
//        else if(response.message)
//        {
//            [self showAlertWithMessage:response.message];
//        }
//            
//    }];
    
}
-(void)connectToFacebook:(NSString *)email FirstName:(NSString *)name adID:(NSString *)fbid
{
    if([WinkUtil reachable]){
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyClientId : @"1",
                               @"facebookId" : fbid
                               };
        [WinkWebServiceAPI connectToFacebook:dict completionHandler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess){
                 //[_btnFBConnect setTitle:@"REMOVE CONNECTION" forState:UIControlStateNormal];
                 //_btnFBConnect.backgroundColor = [UIColor redColor];
                 // isConnected = YES;
                 WinkGlobalObject.user.fb_id =fbid;
                 [WinkGlobalObject.user saveInUserDefaults];
                 lblText.text = @"your account is connected sucessfully";
             }
             else if(response.message)
             {
                 [self showAlertWithMessage:response.message];
             }
             
         }];
    }
    else {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
//    [SVProgressHUD show];
//    NSDictionary *dict = @{
//                           UKeyAccountId : WinkGlobalObject.user.ID,
//                           UKeyAccessToken : WinkGlobalObject.accessToken,
//                           UKeyClientId : @"1",
//                           @"facebookId" : fbid
//                           };
//    [WinkWebServiceAPI connectToFacebook:dict completionHandler:^(WinkAPIResponse *response)
//    {
//        [SVProgressHUD dismiss];
//        if(response.code == RCodeSuccess)
//        {
//            //[_btnFBConnect setTitle:@"REMOVE CONNECTION" forState:UIControlStateNormal];
//            //_btnFBConnect.backgroundColor = [UIColor redColor];
//           // isConnected = YES;
//            WinkGlobalObject.user.fb_id =fbid;
//            [WinkGlobalObject.user saveInUserDefaults];
//            lblText.text = @"your account is connected sucessfully";
//
//        }
//        else if(response.message)
//        {
//            [self showAlertWithMessage:response.message];
//        }
//        
//    }];
}
#pragma mark - FBSDKLoginButtonDelegate  Method
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if([WinkUtil reachable]){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,id,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"%@",result[@"email"]);
                 [self connectToFacebook:result[@"email"] FirstName:result[@"name"] adID:result[@"id"]];
             }
         }];
    }
    else {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,id,last_name"}]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
//     {
//         if (!error)
//         {
//             NSLog(@"fetched user:%@", result);
//             NSLog(@"%@",result[@"email"]);
//             [self connectToFacebook:result[@"email"] FirstName:result[@"name"] adID:result[@"id"]];
//         }
//     }];
    
    
    
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    if([WinkUtil reachable]){
        [self disconnectToFacebbok];
    }
    else {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
//    [self disconnectToFacebbok];
}
@end
