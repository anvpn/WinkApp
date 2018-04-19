//
//  CashOutViewController.m
//  Wink
//
//  Created by Apple on 31/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "CashOutViewController.h"

@interface CashOutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UITableView *tblvHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnWithdraw;
@property (weak, nonatomic) IBOutlet PSProfileStepper *stepperView;
@property (strong, nonatomic) NSArray *arrData;
@property float cashOutBalance;

@end

@implementation CashOutViewController
@synthesize arrData,lblBalance,tblvHistory,btnWithdraw,stepperView,cashOutBalance,slider,lbl_balance;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [WinkUtil authorizeUser];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    float Balance;
    
    lblBalance.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance];
    Balance = [WinkGlobalObject.user.cashOutBalance floatValue];
    
    lbl_balance.text = [NSString stringWithFormat:@"%04f",Balance];
    
    
    cashOutBalance = Balance;
    
    if (cashOutBalance < 5)
    {
        NSLog(@"True");
        _lbl_startBal.text = @"0";
        _lbl_startEnd.text = @"5";
        [slider setMaximumValue:5];
        [slider setMinimumValue:0];
    }
    else
    {
        int Start = cashOutBalance -2;
        int End = cashOutBalance + 3;
        
        _lbl_startBal.text = [NSString stringWithFormat:@"%d",Start];
        _lbl_startEnd.text = [NSString stringWithFormat:@"%d",End];
        [slider setMaximumValue:End];
        [slider setMinimumValue:Start];
        NSLog(@"hi");
        
    }
    
    lbl_balance.text = [NSString stringWithFormat:@"%04f",Balance];
    [slider setValue:cashOutBalance animated:YES];
    
    if(cashOutBalance >= 100)
    {
        btnWithdraw.hidden = NO;
    }
    else
    {
         btnWithdraw.hidden = YES;
    }
    if([WinkUtil reachable])
    {
        [self getCashoutHistory];
    }
    else
    {
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
- (IBAction)btnWithdrawTap:(id)sender
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"withdrawPoints" : lbl_balance.text
                           };
    [WinkWebServiceAPI Cashout:dict completionHandler:^(WinkAPIResponse *response)
     {
         [SVProgressHUD dismiss];
         if (response.code == RCodeSuccess)
         {
             //[self showAlertWithMessage:response.message];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:response.message preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
             {
                 //WinkGlobalObject.cashoutBalance = 0;
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
             }]];
             [self presentViewController:alertController animated:YES completion:nil];
             [WinkUtil authorizeUser];
             //[self dismissViewControllerAnimated:YES completion:nil];
             self.btnWithdraw.hidden=YES;
             lblBalance.text = [NSString stringWithFormat:@"%@",response.cashoutBalance];
             cashOutBalance = [response.cashoutBalance floatValue];
             lbl_balance.text = [NSString stringWithFormat:@"%f",cashOutBalance];
             [slider setValue:cashOutBalance animated:YES];
             _lbl_startBal.text = @"0";
             _lbl_startEnd.text = @"5";
             [slider setMaximumValue:5];
             [slider setMinimumValue:0];
             
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

#pragma mark - Webservice Method
-(void)getCashoutHistory
{
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    [WinkWebServiceAPI getCashOutHistory:dict completionHandler:^(WinkAPIResponse *response, NSArray *arrValue)
    {
        if(response.code == RCodeSuccess)
        {
            arrData = arrValue;
            [tblvHistory reloadData];
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
-(void)withdrawPoints
{
    int roundedDown = floor(cashOutBalance);
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"withdrawPoints" :[NSString stringWithFormat:@"%d",roundedDown]                           };
    
    [WinkWebServiceAPI accountWithdraw:dict completionHandler:^(WinkAPIResponse *response)
    {
        if(response.code == RCodeSuccess)
        {
            [self showAlertWithMessage:@"Cashout Balance Withdraw Successfully" andHandler:^(UIAlertAction * _Nullable action)
            {
                [self getCashoutHistory];
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
#pragma mark - UITableViewDelegate & DataSource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return arrData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CashOutCell"];
    [cell setCashoutData:arrData[indexPath.section]];
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    return cell;
}
@end
