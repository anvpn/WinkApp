//
//  FriendsViewController.m
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *clvFriends;
@property NSMutableArray *arrFriendsList;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@end

@implementation FriendsViewController
@synthesize arrFriendsList,clvFriends,sideMenu,btnBack,profileId,vwAd,btnBalance;

-(void)viewWillAppear:(BOOL)animated
{
    if(_isMenu)
    {
        [btnBack setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnBack setImage:[UIImage imageNamed:@"Back white.png"] forState:UIControlStateNormal];
    }
    
    
    _lbl_Notificationcount.layer.cornerRadius = _lbl_Notificationcount.frame.size.width/2;
    _lbl_Notificationcount.clipsToBounds = true;
    _lbl_Notificationcount.layer.masksToBounds = true;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }

    //[btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.minimumInteritemSpacing = 0.0f;
    //layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(8.0f,8.0f,8.0f,8.0f);
    
    clvFriends.collectionViewLayout = layout;
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        clvFriends.height = clvFriends.height + vwAd.height;
        vwAd.hidden = YES;
    }

    
    [self getFriendsList];
    
}
- (IBAction)btnBackTap:(id)sender
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
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}

-(void)getFriendsList
{
    
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId :WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyProfileId : profileId
                               };
        [WinkWebServiceAPI getFriendsList:dict completionHandler:^(WinkAPIResponse *response, NSArray *arrFriends)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 arrFriendsList = arrFriends.mutableCopy;
                 [clvFriends reloadData];
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
#pragma mark - UICollectoin datasource & delegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numOfSections = 0;
    if (arrFriendsList.count > 0)
    {
        numOfSections                = 1;
        collectionView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)];
        //noDataLabel.text             = @"No data available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        collectionView.backgroundView = noDataLabel;
    }
    return numOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrFriendsList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCollectionCell" forIndexPath:indexPath];
    [cell setCellData:arrFriendsList[indexPath.row]];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WinkFriend *frnd = arrFriendsList[indexPath.row];
    
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    
    FriendsCollectionCell *cell = (FriendsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    fvc.profileId = [frnd.userId intValue];
    fvc.tempName = frnd.fullname;
    fvc.tempUserName = [NSString stringWithFormat:@"@%@",frnd.userName];
    fvc.tempImgProfile = cell.imgvProfilePic.image;
    [self presentViewController:fvc animated:YES completion:nil];
}
/*- (CGSize)collectionView:(UICollectionView *)collectionView
 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 int padding;
 
 if(WinkGlobalObject.screenSizeType == WinkScreenSizeType3_5)
 {
 padding =  0;
 }
 else if((WinkGlobalObject.screenSizeType == WinkScreenSizeType3_5))
 {
 padding =  5;
 }
 else if (WinkGlobalObject.screenSizeType == WinkScreenSizeType4_7)
 {
 padding = 20;
 }
 else if(WinkGlobalObject.screenSizeType == WinkScreenSizeType5_5)
 {
 padding = 30;
 }
 float collectionViewSize = collectionView.frame.size.width ;//- padding;
 
 return CGSizeMake(collectionViewSize/2.5, collectionView.cel);
 }*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2.2, clvFriends.layer.frame.size.height/2.5);
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

@end
