//
//  MessageViewController.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) SideBarViewController *sideMenu;

@property (weak, nonatomic) IBOutlet UITableView *tblvMessgeList;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@property (strong, nonatomic) NSMutableArray *arrMessagesList;

@end

@implementation MessageViewController
@synthesize sideMenu,arrMessagesList,vwAd,tblvMessgeList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    arrMessagesList = [[NSMutableArray alloc]init];
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        tblvMessgeList.height = tblvMessgeList.height + vwAd.height;
        vwAd.hidden = YES;
    }
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getMessageList];
    _lbl_Notificationcount.layer.cornerRadius = _lbl_Notificationcount.frame.size.width/2;
    _lbl_Notificationcount.clipsToBounds = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)getMessageList
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        
        [WinkWebServiceAPI getMessageList:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrMessages)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 arrMessagesList = arrMessages.mutableCopy;
                 [tblvMessgeList reloadData];
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
    if(!sideMenu)
    {
        sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideMenu.view];
    }
    [sideMenu showMenu];
}

#pragma mark - UITableview Delegate & DataSorce Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (arrMessagesList.count > 0)
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
    return arrMessagesList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    WinkChat * chat = arrMessagesList[indexPath.row];
    [cell setMessageCellData:chat];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WinkChat * chat = arrMessagesList[indexPath.row];
    ChatViewController *cvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chat.msgCount = @"";
    cvc.chat = chat;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
