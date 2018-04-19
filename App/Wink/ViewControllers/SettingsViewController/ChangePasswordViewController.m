//
//  ChangePasswordViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPswd;
@property (weak, nonatomic) IBOutlet UITextField *txtnewPswd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPswd;

@end

@implementation ChangePasswordViewController
@synthesize txtCurrentPswd,txtnewPswd,txtConfirmPswd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    UIColor *color = [UIColor whiteColor];
    txtCurrentPswd.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Current password"
     attributes:@{NSForegroundColorAttributeName:color}];
    txtnewPswd.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"New password"
     attributes:@{NSForegroundColorAttributeName:color}];
    txtConfirmPswd.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Confirm password"
     attributes:@{NSForegroundColorAttributeName:color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSaveTap:(id)sender
{
    if([self isDetailValid])
    {
        
        if([WinkUtil reachable])
        {
            [SVProgressHUD show];
            NSDictionary *dict = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   @"currentPassword" : txtCurrentPswd.text,
                                   @"newPassword" : txtnewPswd.text
                                   };
            [WinkWebServiceAPI ChangePassword:dict completionHandler:^(WinkAPIResponse *response)
            {
                [SVProgressHUD dismiss];
                if(response.code == RCodeSuccess)
                {
                    [self showAlertWithMessage:@"Password changed successfully" andHandler:^(UIAlertAction * _Nullable action)
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
                else if(response.code == 1)
                {
                    [self showAlertWithMessage:@"Invalid paswword"];
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
}

-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtCurrentPswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtCurrentPswd];
        
        return NO;
    }
    else if([txtCurrentPswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtCurrentPswd];
        
        return NO;
    }
    
    result = [txtnewPswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtnewPswd];
        
        return NO;
    }
    else if([txtnewPswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtnewPswd];
        
        return NO;
    }
    else if (![self isValidPassword:txtnewPswd.text])
    {
        [self showAlertWithMessage:WinkInvalidPswd];
        return NO;
    }
    result = [txtConfirmPswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtConfirmPswd];
        
        return NO;
    }
    else if([txtConfirmPswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtConfirmPswd];
        
        return NO;
    }
    if(![txtnewPswd.text isEqualToString:txtConfirmPswd.text])
    {
        [self showErrorMessage:WinkSamePswd belowView:txtConfirmPswd];
        return NO;
    }
    
    return YES;
}
-(BOOL)isValidPassword:(NSString *)checkString
{
    // NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}";
    //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}
    NSString *stricterFilterString =  @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$$";
    
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    BOOL ans =  [passwordTest evaluateWithObject:checkString];
    NSLog(@"%d",ans);
    return ans;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    return YES;
}
@end
