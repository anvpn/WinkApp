//
//  BlockedListViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "BlockedListViewController.h"

@interface BlockedListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblvBlockedList;
@property (strong, nonatomic) NSMutableArray *arrBlockedList;

@end

@implementation BlockedListViewController
@synthesize tblvBlockedList,arrBlockedList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    //8F4BF8
    
    arrBlockedList = [[NSMutableArray alloc]init];
    tblvBlockedList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getBlockedList];
}

-(void)getBlockedList
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        [WinkWebServiceAPI getBlockedList:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrBlocked)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 arrBlockedList = arrBlocked.mutableCopy;
                 [tblvBlockedList reloadData];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnUnblockTap:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvBlockedList];
    NSIndexPath *indexPath = [tblvBlockedList indexPathForRowAtPoint:buttonPosition];
    NSDictionary *dict1 = arrBlockedList[indexPath.row];
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyProfileId : dict1[@"blockedUserId"]
                               };
        [WinkWebServiceAPI removeFromBlackList:dict completionHandler:^(WinkAPIResponse *response)
        {
            if(response.code == RCodeSuccess)
            {
                [self getBlockedList];
                
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
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableview delegate & datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrBlockedList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockedCell"];
    NSDictionary *dict = arrBlockedList[indexPath.row];
    [cell setBlockedPeopleData:dict];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = arrBlockedList[indexPath.row];
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    fvc.profileId = (int)dict[@"blockedUserId"];
    [self presentViewController:fvc animated:YES completion:nil];
    
}
@end
