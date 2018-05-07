//
//  ILikedViewController.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ILikedViewController.h"

@interface ILikedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblvLikedList;
@property (strong, nonatomic) NSMutableArray *arrLikedList;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@end

@implementation ILikedViewController
@synthesize tblvLikedList,arrLikedList,sideMenu,vwAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    arrLikedList = [[NSMutableArray alloc]init];
    
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        tblvLikedList.height = tblvLikedList.height + vwAd.height;
        vwAd.hidden = YES;
    }
    
    if([WinkUtil reachable])
    {
        [self getILikedList];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    _lbl_Notificationcount.layer.cornerRadius = _lbl_Notificationcount.frame.size.width/2;
    _lbl_Notificationcount.clipsToBounds = true;
    _lbl_Notificationcount.layer.masksToBounds = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}

- (IBAction)btnMenuTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    if(!sideMenu)
//    {
//        sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
//        [self.view addSubview:sideMenu.view];
//    }
//    [sideMenu showMenu];
}

-(void)getILikedList
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    [WinkWebServiceAPI getILikedList:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrILikes)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            arrLikedList = arrILikes.mutableCopy;
            [tblvLikedList reloadData];
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
#pragma Mark - UITableview delegate & datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (arrLikedList.count > 0)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        //noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrLikedList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ILikedCell"];
    WinkUser *user = arrLikedList[indexPath.row];
    
    [cell setCellData:user];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WinkUser *user = arrLikedList[indexPath.row];
    
    if([user.ID isEqualToString:WinkGlobalObject.user.ID])
    {
        ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        pvc.isMenu = NO;
        [self presentViewController:pvc animated:YES completion:nil];
    }
    else
    {
        FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
        fvc.profileId = [user.ID intValue];
        [self presentViewController:fvc animated:YES completion:nil];
    }
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

@end
