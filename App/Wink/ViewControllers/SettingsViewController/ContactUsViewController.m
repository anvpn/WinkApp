//
//  ContactUsViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;

@end

@implementation ContactUsViewController
@synthesize txtEmail,txtSubject,txtMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    UIColor *color = [UIColor whiteColor];
    txtEmail.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Email"
     attributes:@{NSForegroundColorAttributeName:color}];
    txtSubject.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Subject"
     attributes:@{NSForegroundColorAttributeName:color}];
    txtMessage.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Your message"
     attributes:@{NSForegroundColorAttributeName:color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankEmail belowView:txtEmail];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:WinkInvalidMail belowView:txtEmail];
        
        return NO;
    }
    result = [txtSubject validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankSubject belowView:txtSubject];
        
        return NO;
    }
    result = [txtMessage validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankMessage belowView:txtMessage];
        
        return NO;
    }

    return YES;
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnSendTap:(id)sender
{
    if([self isDetailValid])
    {
        if([WinkUtil reachable])
        {
            [SVProgressHUD show];
            NSDictionary *dict = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   @"email" : txtEmail.text,
                                   @"subject" : txtSubject.text,
                                   @"detail" : txtMessage.text
                                   };
            [WinkWebServiceAPI contactUs:dict completionHandler:^(WinkAPIResponse *response)
            {
                [SVProgressHUD dismiss];
                if(response.code == RCodeSuccess)
                {
                    [self showAlertWithMessage:@"Querry sent successfully" andHandler:^(UIAlertAction * _Nullable action)
                     {
                         [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
                else
                {
                    [self showAlertWithMessage:response.message];
                }
            }];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    return YES;
}

@end
