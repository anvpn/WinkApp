//
//  DeactiveAccountViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "DeactiveAccountViewController.h"

@interface DeactiveAccountViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnDeactivate;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentpswd;

@end

@implementation DeactiveAccountViewController
@synthesize txtCurrentpswd,btnDeactivate;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtCurrentpswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtCurrentpswd];
        
        return NO;
    }
    else if([txtCurrentpswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtCurrentpswd];
        
        return NO;
    }
    return YES;
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDeactivateTap:(id)sender
{
    if([self isDetailValid])
    {
        if([WinkUtil reachable])
        {
            [SVProgressHUD show];
            
            NSDictionary *dict = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   @"currentPassword" : txtCurrentpswd.text
                                   };
            [WinkWebServiceAPI DeactivateAccount:dict completionHandler:^(WinkAPIResponse *response)
            {
                [SVProgressHUD dismiss];
                if(response.code == RCodeSuccess)
                {
                    [self showAlertWithMessage:@"Account deactivated successfully" andHandler:^(UIAlertAction * _Nullable action)
                    {
                        [WinkUtil reachable];
                    }];
                }
                else
                {
                    [self showAlertWithMessage:@"Invalida password"];
                }
                
            }];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
}

@end
