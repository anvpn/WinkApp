//
//  MyGallaryViewController.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "MyGallaryViewController.h"

@interface MyGallaryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *clvFriends;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (strong, nonatomic) NSMutableArray *arrGallaryPhotos;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@end

@implementation MyGallaryViewController
@synthesize sideMenu,arrGallaryPhotos,clvFriends,profileId,btnBack,vwAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    arrGallaryPhotos = [[NSMutableArray alloc]init];
    
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
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    [self PrepareView];
}
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
}
-(void)viewDidAppear:(BOOL)animated
{
    [self PrepareView];

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
- (IBAction)btnPlusTap:(id)sender
{
    UploadGallaryIteamViewController *igvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"UploadGallaryIteamViewController"];
    
    [self presentViewController:igvc animated:YES completion:nil];
    
}

-(void)PrepareView
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *userInfo = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   UKeyProfileId : profileId
                                   };
        
        [WinkWebServiceAPI getGallaryList:userInfo completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrPhotos)
        {
            [SVProgressHUD dismiss];
            
            if(response.code == RCodeSuccess)
            {
                arrGallaryPhotos = arrPhotos;
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


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   NSInteger numOfSections = 0;
    if (arrGallaryPhotos.count > 0)
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
    return arrGallaryPhotos.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCollectionCell" forIndexPath:indexPath];
    ;
    [cell setGallaryPhoto:arrGallaryPhotos[indexPath.row]];
    
    
    return  cell;
    
}
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    /*int padding;
//     
//     if(WinkGlobalObject.screenSizeType == WinkScreenSizeType3_5)
//     {
//     padding =  0;
//     }
//     else if((WinkGlobalObject.screenSizeType == WinkScreenSizeType3_5))
//     {
//     padding =  5;
//     }
//     else if (WinkGlobalObject.screenSizeType == WinkScreenSizeType4_7)
//     {
//     padding = 20;
//     }
//     else if(WinkGlobalObject.screenSizeType == WinkScreenSizeType5_5)
//     {
//     padding = 30;
//     }*/
//    float collectionViewSize = collectionView.frame.size.width ;//- padding;
//    
//    return CGSizeMake(collectionViewSize/3.5, collectionViewSize/3.5);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20)/2, ([UIScreen mainScreen].bounds.size.width - 20)/2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
    WinkPhotos *photo = arrGallaryPhotos[indexPath.row];
    gvc.selectedPhoto = photo;
    
    [self presentViewController:gvc animated:YES completion:nil];
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

@end
