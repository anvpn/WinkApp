//
//  LoginViewController.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface LoginViewController () <UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate,FBSDKLoginButtonDelegate>
{
    int Isshow;

}

@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPswd;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;

//Login button
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

//Check Un Check
@property (weak, nonatomic) IBOutlet UIImageView *img_check;

@property (strong,nonatomic) ZWTTextboxToolbarHandler *handler;
@property (strong, nonatomic)  FBSDKLoginButton *btnFBLogin;
@end

@implementation LoginViewController
@synthesize btnFBLogin,handler,scrlvBG,txtUserName,txtPswd,btn_login;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    if([WinkUtil reachable]){
        btnFBLogin = [[FBSDKLoginButton alloc]init];
        
        btnFBLogin.readPermissions =
        @[@"public_profile", @"email", @"user_friends"];
        btnFBLogin.delegate = self;
        btnFBLogin.width = 200;
        
        btnFBLogin.frame = CGRectMake(self.view.frame.size.width/2 - btnFBLogin.frame.size.width/2,self.view.height - 115 , 200, 40);
        
        [self.view addSubview:btnFBLogin];
    }
     [scrlvBG setContentSize:CGSizeMake(scrlvBG.width, scrlvBG.height)];
    txtPswd.textColor = [UIColor whiteColor];
    txtUserName.textColor = [UIColor whiteColor];
    UIColor *color = [UIColor whiteColor];
    txtPswd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtUserName,txtPswd] andScroll:scrlvBG];
    handler.delegate = self;
    
    btn_login.layer.cornerRadius= 2;
    btn_login.layer.borderWidth = 2;
    btn_login.layer.borderColor = [UIColor whiteColor].CGColor;
    
    Isshow=1;
    _img_check.image= [UIImage imageNamed:@"hide.png"];
    [self popUpZoomIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper Method
-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtUserName validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankUserName belowView:txtUserName];
        
        return NO;
    }
    else if (txtUserName.text.length  < 5)
    {
        [self showErrorMessage:WinkEnterMinChar belowView:txtUserName];
        
        return NO;
    }
    [txtUserName resignFirstResponder];
    result = [txtPswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtPswd];
        
        return NO;
    }
    else if([txtPswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtPswd];
        
        return NO;
    }
    [txtPswd resignFirstResponder];
    /*else if(result == ZWTValidationResultLessLength || result == ZWTValidationResultMoreLength)
    {
        [self showErrorMessage:KZMPasswordLength belowView:txtPassword];
        
        return NO;
    }*/
    
    return YES;
}
#pragma mark - Webservice Method
-(void)login
{
    if([WinkUtil reachable]){
        [SVProgressHUD show];
        NSDictionary *userDict = @{
                                   @"username": txtUserName.text,
                                   @"password" : txtPswd.text,
                                   @"clientId" : [NSNumber numberWithInt:1]
                                   };
        
        
        [WinkWebServiceAPI loginWithUserDetail:userDict completionHandler:^(WinkAPIResponse *response, WinkUser *user)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 [user login];
                 
                 UINavigationController *sbvc = [WinkGlobalObject.storyboardMenubar instantiateInitialViewController];
                 
                 AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                 
                 delegate.window.rootViewController = sbvc;
                 WinkGlobalObject.rootNavigationController = sbvc;
             }
             else if (response.code == 1)
             {
                 [self showAlertWithMessage:@"Incorrect username or password"];
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
    else
    {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
}
#pragma mark - UIViewEvent
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnLoginTap:(id)sender
{
    if([self isDetailValid])
    {
       if([WinkUtil reachable])
        {
            [self login];
        }
       else
        {
           [self showAlertWithMessage:WinkNoInternet];
        }
    }
    
}
- (IBAction)fbLoginTap:(id)sender
{
   
    
   
}
- (IBAction)btn_signup:(id)sender
{
    RootSignupViewController *svc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"RootSignupViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)popUpZoomIn{
    _img_logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:1.0
                     animations:^{
                         _img_logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         [self popZoomOut];
                     }];
}
- (void)popZoomOut
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         _img_logo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                     } completion:^(BOOL finished){
                         //_img_Logo.hidden = TRUE;
                         [self popUpZoomIn];
                     }];
}


- (IBAction)btnShowpassword:(id)sender
{
    if (Isshow == 1)
    {
        Isshow = 2;
        txtPswd.secureTextEntry = NO;
        _img_check.image= [UIImage imageNamed:@"show.png"];
    }
    else
    {
        Isshow = 1;
        txtPswd.secureTextEntry=YES;
        _img_check.image= [UIImage imageNamed:@"hide.png"];
    }
}
- (IBAction)btnForgotPswdTap:(id)sender
{
    ForgotPasswordViewController *fvc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    [self.navigationController presentViewController:fvc animated:YES completion:nil];
}

#pragma mark - FBSDKLoginButtonDelegate  Method
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,id,last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             NSLog(@"fetched user:%@", result);
             NSLog(@"%@",result[@"email"]);
             [self loginwithFacebook:result[@"email"] FirstNAme:result[@"name"] andId:result[@"id"]];
         }
     }];
    
    
    
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

-(void)loginwithFacebook:(NSString *)email FirstNAme:(NSString *)fname andId:(NSString *)fbId
{
    NSDictionary *userDict = @{
                               @"facebookId": fbId,
                               @"facebookName" :fname,
                               @"facebookEmail" : email
                               };
    
    
    [WinkWebServiceAPI loginWithFacebook:userDict completionHAndler:^(WinkAPIResponse *response, WinkUser *user)
     {
        [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             [user login];
             
             UINavigationController *sbvc = [WinkGlobalObject.storyboardMenubar instantiateInitialViewController];
             
             AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
             
             delegate.window.rootViewController = sbvc;
             WinkGlobalObject.rootNavigationController = sbvc;
         }
         else if (response.code == 1)
         {
             RootSignupViewController *svc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"RootSignupViewController"];
             svc.fbId = fbId;
             svc.firstname = fname;
             svc.email = email;
             [self.navigationController pushViewController:svc animated:YES];
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
@end
