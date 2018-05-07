//
//  ProfileGiftsViewController.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ProfileGiftsViewController.h"

@interface ProfileGiftsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblvGifts;
@property (strong, nonatomic) NSMutableArray *arrGiftsList;

@end

@implementation ProfileGiftsViewController
@synthesize arrGiftsList,profileId,tblvGifts;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    arrGiftsList = [[NSMutableArray alloc]init];
    if([WinkUtil reachable])
    {
        [self getGifts];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

-(void)getGifts
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           UKeyProfileId : [NSNumber numberWithInt:profileId]
                           
                        };
    
    [WinkWebServiceAPI getGiftsList:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrGifts)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            arrGiftsList = arrGifts.mutableCopy;
            
            if(arrGiftsList.count == 0)
                tblvGifts.hidden = true;
            
            [tblvGifts reloadData];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableview delegate & datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrGiftsList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftCell"];
    WinkGift *gift = arrGiftsList[indexPath.section];
    [cell setGiftCellData:gift];
    [cell.btn_Giftcancel addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!_isUserProfile)
        cell.btn_Giftcancel.hidden = true;
    
    [tableView setSeparatorColor:[UIColor clearColor]];
    return cell;
}

- (IBAction)btn_giftdel:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvGifts];
    NSIndexPath *indexPath = [tblvGifts indexPathForRowAtPoint:buttonPosition];
    WinkGift *gift = arrGiftsList[indexPath.section];
    NSLog(@"id:-%@",gift.ID);
    
    //NSDictionary  *contact = arrContacts[indexPath.row];
}


- (void)checkButtonTapped:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvGifts];
    NSIndexPath *indexPath = [tblvGifts indexPathForRowAtPoint:buttonPosition];
    WinkGift *gift = arrGiftsList[indexPath.section];
    NSLog(@"id:-%@",gift.ID);
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"itemId" : gift.ID
                           };
    [WinkWebServiceAPI DeleteGift:dict completionHandler:^(WinkAPIResponse *response)
     {
         [SVProgressHUD dismiss];
         if (response.code == RCodeSuccess)
         {
             arrGiftsList = [[NSMutableArray alloc]init];
             [self getGifts];
             [self showAlertWithMessage:@"Gift delete successfully"];
             //lblBalance.text = [NSString stringWithFormat:@"%@",response.cashoutBalance];
             //cashOutBalance = [response.cashoutBalance floatValue];
             //lbl_balance.text = [NSString stringWithFormat:@"%f",cashOutBalance];
             //[slider setValue:cashOutBalance animated:YES];
         }
         else if(response.message)
         {
             [self showAlertWithMessage:@"oops something went wrong please try again"];
         }
         else
         {
             [self showAlertWithMessage:@"oops something went wrong please try again"];
         }
     }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    else
        return 10;
}
@end
