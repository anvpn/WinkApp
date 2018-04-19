//
//  ForgotPasswordViewController.m
//  Wink
//
//  Created by Apple on 16/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btn_continue;

@end

@implementation ForgotPasswordViewController
@synthesize txtEmail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    self.btn_continue.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btn_continue.layer.borderWidth=0.3;
    self.btn_continue.layer.cornerRadius=5;
    self.btn_continue.layer.masksToBounds=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnContinueTap:(id)sender
{
    if([WinkUtil reachable])
    {
        if([self isDetailValid])
        {
            [SVProgressHUD show];
            NSDictionary *dict = @{
                                   @"clientId" : @"1",
                                   @"email" : txtEmail.text
                                   };
            
            [WinkWebServiceAPI ForgotPassword:dict completionHandler:^(WinkAPIResponse *response)
            {
                [SVProgressHUD dismiss];
                
                if(response.code == 1)
                {
                   
                    [self showAlertWithMessage:@"Email is not registered"];
                }
                else if (response.code == RCodeSuccess)
                {
                    [self showAlertWithMessage:@"Email sent successfully" andHandler:^(UIAlertAction * _Nullable action)
                     {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }];
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
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

-(BOOL)isDetailValid
{
     ZWTValidationResult result;
   
    result = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if(result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankEmail belowView:txtEmail];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:WinkInvalidMail belowView:txtEmail];
        return NO;
    }

    return YES;
}
@end
