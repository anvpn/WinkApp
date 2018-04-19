//
//  NotificationListViewController.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "NotificationListViewController.h"
#import "ProfileLikesViewController.h"
@interface NotificationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrNotificationList;
@property (weak, nonatomic) IBOutlet UITableView *tblvNotification;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@end

@implementation NotificationListViewController
@synthesize arrNotificationList,sideMenu,vwAd,tblvNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    //ana
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationList) name:@"updateNotifications" object:self];

    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    arrNotificationList = [[NSMutableArray alloc]init];
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        tblvNotification.height = tblvNotification.height + vwAd.height;
        vwAd.hidden = YES;
    }
    [_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
   if([WinkUtil reachable])
   {
       [self getNotificationList];
   }
   else
   {
        [self showAlertWithMessage:WinkNoInternet];
   }
}

-(void)viewWillAppear:(BOOL)animated
{
    tblvNotification.delegate = self;
    tblvNotification.dataSource = self;
}
-(void)viewDidAppear:(BOOL)animated
{
    //ana
    if(AppDeleObj.isDeleteFeed)
    {
        [self getNotificationList];
        AppDeleObj.isDeleteFeed = false;
    }
    
}



-(void)getNotificationList
{
    
    NSLog(@"Calling Notification List :----------");
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    [WinkWebServiceAPI getNotificationList:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrNotification)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [arrNotificationList removeAllObjects];
                arrNotificationList = [[NSMutableArray alloc]init];
                arrNotificationList = arrNotification.mutableCopy;
                [tblvNotification reloadData];
                [self.tblvNotification reloadData];
            });
            
          
        }
        else if(response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:response.error.localizedDescription];
        }
        
        //ana changes
        
        [self.tblvNotification reloadData];

        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnMenuTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - UItableview delegate & datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (arrNotificationList.count > 0)
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
    return arrNotificationList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    WinkNotification *noti = arrNotificationList[indexPath.row];
    [cell setNotificationCellData:noti];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WinkNotification *noti = arrNotificationList[indexPath.row];
    
    ProfileLikesViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileLikesViewController"];
    ProfileGiftsViewController *pgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileGiftsViewController"];
    GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
    
    switch ([noti.nType intValue])
    {
        case WinkNotificationLike:
            pvc.isMenu = NO;
            pvc.profileId = WinkGlobalObject.user.ID;
            [self presentViewController:pvc animated:YES completion:nil];
            break;
            
        case WinkNotificationComment:
            NSLog(@"WinkNotificationComment");
            break;
            
        case WinkNotificationCommentReply:
            NSLog(@"WinkNotificationCommentReply");
            break;
            
        case WinkNotificationGift:
            pgvc.profileId = [WinkGlobalObject.user.ID intValue];
            [self presentViewController:pgvc animated:YES completion:nil];
            break;
            
        case WinkNotificationImageComment:
            NSLog(@"WinkNotificationImageComment");
            gvc.ItemId = noti.iteamId;
            gvc.Isnotification = YES;
            [self presentViewController:gvc animated:YES completion:nil];
            break;
            
        case WinkNotificationImageCommentReply:
            NSLog(@"WinkNotificationImageCommentReply");
            break;
            
        case WinkNotificationImageLike:
            NSLog(@"Hi");
            NSLog(@"WinkNotificationImageLike");
            gvc.ItemId = noti.iteamId;
            gvc.Isnotification = YES;
            [self presentViewController:gvc animated:YES completion:nil];
            break;
            
        default:
            [self askToAcceptOrDelete:noti forTableIndex:indexPath];
            
            break;
            break;
    }
    /*GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
    gvc.selectedPhoto = photo;
    [self presentViewController:gvc animated:YES completion:nil];*/

}
-(void)askToAcceptOrDelete:(WinkNotification *)noti forTableIndex:(NSIndexPath *)indexpath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Friend Request" message:[NSString stringWithFormat:@"@%@",noti.message] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * _Nonnull action)
                             
    {
        [self acceptRequest:noti withTableIndex:indexpath];
    }];
    
    UIAlertAction *Reject = [UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                            
    {
        [self rejectRequest:noti withTableIndex:indexpath];
    }];
    
    [alert addAction:Accept];
    [alert addAction:Reject];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)acceptRequest:(WinkNotification *)noti withTableIndex:(NSIndexPath *)indexpath
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"friendId" : noti.userId
                               
                            };
        
        [WinkWebServiceAPI acceptFriendRequest:dict completionHAndler:^(WinkAPIResponse *response)
        {
            if(response.code == RCodeSuccess)
            {
                [self getNotificationList];
            }
            
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)rejectRequest:(WinkNotification *)noti withTableIndex:(NSIndexPath *)indexpath
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"friendId" : noti.userId
                               
                               };
        
        [WinkWebServiceAPI rejectFriendRequest:dict completionHandler:^(WinkAPIResponse *response)
        {
            if(response.code == RCodeSuccess)
             {
                 [self getNotificationList];
             }
             
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
@end
