//
//  ProfileGuestViewController.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ProfileGuestViewController.h"
#import "WinkGuestUser.h"

@interface ProfileGuestViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *clcvGuest;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (strong, nonatomic) NSMutableArray *arrGuestList;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@end

@implementation ProfileGuestViewController
@synthesize clcvGuest,sideMenu,arrGuestList,vwAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.minimumInteritemSpacing = 0.0f;
    //layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(8.0f,8.0f,8.0f,8.0f);
    
    clcvGuest.collectionViewLayout = layout;
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        clcvGuest.height = clcvGuest.height + vwAd.height;
        vwAd.hidden = YES;
    }
    
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    [self getGuestDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)getGuestDetail
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        [WinkWebServiceAPI getProfileGuestList:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrGuest)
        {
            [SVProgressHUD dismiss];
            
            if(response.code == RCodeSuccess)
            {
                arrGuestList = arrGuest.mutableCopy;
                [clcvGuest reloadData];
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
    sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    [self.view addSubview:sideMenu.view];

    [sideMenu showMenu];
}
#pragma mark - collectionView delegate & datasource method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
        NSInteger numOfSections = 0;
        if (arrGuestList.count > 0)
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
    return arrGuestList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuestCell" forIndexPath:indexPath];
    
    NSDictionary *frnd = arrGuestList[indexPath.row];
    
    //cell.lblFullName.text = frnd[@"guestUserFullname"];
    cell.lblStatus.text = frnd[@"timeAgo"];
    
    if([frnd[@"guestUserOnline"]boolValue])
    {
        [cell.imgvOnline setImage:[UIImage imageNamed:@"online.png"]];
        cell.lblFullName.textColor = [UIColor greenColor];
        cell.lblStatus.text = @"Online";
    }
    else
    {
        [cell.imgvOnline setImage:[UIImage imageNamed:@"offline.png"]];
        cell.lblFullName.textColor = [UIColor whiteColor];
        cell.lblStatus.text = frnd[@"timeAgo"];
    }
    if ([frnd[@"guestUserVerify"]boolValue])
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        //NSString *Name = frnd[@"guestUserFullname"];
        NSString *Name = [NSString stringWithFormat:@"%@ ",frnd[@"guestUserFullname"]];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        cell.lblFullName.attributedText  = myString;
    }
    else
    {
        cell.lblFullName.text = frnd[@"guestUserFullname"];
    }
    NSURL *url = [NSURL URLWithString:frnd[@"guestUserPhoto"]];
    NSString *lastComponent;
    NSURL *photourl;
    if(url != nil && url != NULL && (url.absoluteString.length != 0))
    {
        lastComponent = [url lastPathComponent];
        photourl = [WinkWebservice URLForProfileImage:lastComponent];
//        [cell.imgvProfilePic setImageWithURL:photourl];
//        [cell.imgvProfilePic setImageWithURL:photourl placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
//
    
        [cell.imgvProfilePic sd_setImageWithURL:photourl placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"] options:SDWebImageRefreshCached];
        
        
    }
    else
    {
        cell.imgvProfilePic.image = [UIImage imageNamed:@"profile_default_photo.png"];
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    return  cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *frnd = arrGuestList[indexPath.row];
    
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    WinkGuestUser *userGuest = [[WinkGuestUser alloc]initWithDictionary:frnd];

    WinkUser *user = [[WinkUser alloc]init];
    user.userName = userGuest.guestUserUsername;
    user.name = userGuest.guestUserFullname;
    user.isOnline = userGuest.guestUserOnline;
    user.ID = userGuest.guestUserId;
    user.verify = userGuest.guestUserVerify;
    user.isVIP = userGuest.guestUserVip;
    user.createdDate = userGuest.createAt;
    user.isBlocked = userGuest.blocked;
    user.name = userGuest.guestUserFullname;
    user.normalSizeProfURL = [NSURL URLWithString:userGuest.guestUserPhoto];

    
    FriendsCollectionCell *cell = (FriendsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    fvc.imgProfile = cell.imgvProfilePic.image;
    
    fvc.winkUser = user;
    fvc.profileId = [frnd[@"guestUserId"]intValue];
    fvc.dictFriend = frnd;
    
    fvc.tempName = user.name;
    fvc.tempUserName = [NSString stringWithFormat:@"@%@",user.userName];
    fvc.tempImgProfile = cell.imgvProfilePic.image;
    fvc.tempImgCover = user.originCoverURL;
    [self.navigationController presentViewController:fvc animated:YES completion:nil];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((([[UIScreen mainScreen] bounds].size.width) / 2) - 14, 240);
}
- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

@end
