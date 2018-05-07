//
//  ProfileLikesViewController.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ProfileLikesViewController.h"

@interface ProfileLikesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblvProfileLikes;
@property (strong, nonatomic) NSMutableArray *arrProfileLikes;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@end

@implementation ProfileLikesViewController
@synthesize arrProfileLikes,tblvProfileLikes,btnMenu,sideMenu,profileId,vwAd,btnBalance;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    arrProfileLikes = [[NSMutableArray alloc]init];
    
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    
    //[btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        tblvProfileLikes.height = tblvProfileLikes.height + vwAd.height;
        vwAd.hidden = YES;
    }

    
    [self prepareView];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(_isMenu)
    {
        [btnMenu setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnMenu setImage:[UIImage imageNamed:@"Back white.png"] forState:UIControlStateNormal];
    }
    
    _lbl_Notificationcount.layer.cornerRadius = _lbl_Notificationcount.frame.size.width/2;
    _lbl_Notificationcount.clipsToBounds = true;
    _lbl_Notificationcount.layer.masksToBounds = true;
    
}

-(void)prepareView
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyProfileId : profileId
                               };
        
        [WinkWebServiceAPI getProfileLikesList:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrLikes)
        {
            [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                arrProfileLikes = arrLikes.mutableCopy;
                [tblvProfileLikes reloadData];
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
        [self showAlertWithMessage:WinkNoInternet];
    }
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}

- (IBAction)btnMenuTap:(id)sender
{
    if(_isMenu)
    {
        if(!sideMenu)
        {
            sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
            [self.view addSubview:sideMenu.view];
        }
        [sideMenu showMenu];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableview delegate & datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (arrProfileLikes.count > 0)
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
    return arrProfileLikes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileLikeCell"];
    
    [cell setCellData:arrProfileLikes[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WinkUser *frnd = arrProfileLikes[indexPath.row];
    
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    
    fvc.profileId = [frnd.ID intValue];
    
    [self.navigationController presentViewController:fvc animated:YES completion:nil];
}
- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

@end
