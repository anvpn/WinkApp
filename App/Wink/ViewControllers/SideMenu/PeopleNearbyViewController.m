//
//  PeopleNearbyViewController.m
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "PeopleNearbyViewController.h"

@interface PeopleNearbyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SettingOptionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *clcvNearByList;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (strong, nonatomic) NSMutableArray *arrNerabyList;
@property int selectedIndex;
@property NSString *selectedKM;
@property NSString *pageNo;


@end

@implementation PeopleNearbyViewController
@synthesize clcvNearByList,lblHeaderTitle,arrNerabyList,sideMenu,selectedIndex,selectedKM,vwAd,pageNo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    arrNerabyList = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.minimumInteritemSpacing = 0.0f;
    //layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(8.0f,8.0f,8.0f,8.0f);
    
    clcvNearByList.collectionViewLayout = layout;
    
    pageNo = @"0";
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        clcvNearByList.height = clcvNearByList.height + vwAd.height;
        vwAd.hidden = YES;
    }
    
    
    if(WinkGlobalObject.currentCity == nil)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied)
        {
            NSString *title;
            
            title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
            
            NSString *message = @"To see nearby friends you must turn on 'Always' in the Location Services Settings";
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:ok];
            
            UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                          [[UIApplication sharedApplication] openURL:settingsURL];
                                      }];
            
            [alert addAction:setting];
            [self presentViewController:alert animated:YES completion:nil];
            
        }

    }
    else
    {
        lblHeaderTitle.text = WinkGlobalObject.currentCity;
        selectedIndex = 0;
        selectedKM = @"80 Kilometers";
        if([WinkUtil reachable])
        {
            [self getNearbyListWithPage];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
    
   
}
-(void)getNearbyListWithPage
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"distance" : selectedKM,
                           @"lat" : WinkGlobalObject.currentLattitude,
                           @"lng" : WinkGlobalObject.currentLongitude,
                           @"itemId" : [NSString stringWithFormat:@"%@",pageNo]
                           };
    [WinkWebServiceAPI getNearByFriendsList:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             pageNo = [NSString stringWithFormat:@"%d",iteamId];
             // arrNerabyList = arrFriends.mutableCopy;
             NSSortDescriptor *sortDescriptor;
             sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
             
             NSArray *sortedArray = [arrPhotos sortedArrayUsingDescriptors:@[sortDescriptor]];
             
             //arrNerabyList = sortedArray.mutableCopy;
             [arrNerabyList addObjectsFromArray:sortedArray];
             [clcvNearByList reloadData];
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
- (IBAction)btnMenuTap:(id)sender
{
    if(!sideMenu)
    {
        sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideMenu.view];
    }
    [sideMenu showMenu];
}
- (IBAction)btnSortTap:(id)sender
{
    SettingOptionViewController *svc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SettingOptionViewController"];
    svc.titleLable = @"Select a Distance";
    svc.arrOptions = @[@"80 Kilometers",@"160 Kilometers",@"400 Kilometers",@"800 Kilometers",@"1,600 Kilometers"];
    svc.selectedIndex = selectedIndex;
    svc.delegate = self;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [svc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:svc animated:NO completion:nil];

}

#pragma mark - UICollectionview delegate & Datasource Method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrNerabyList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PeopleNearbyCell" forIndexPath:indexPath];
    WinkUser *user = arrNerabyList[indexPath.row];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    [cell setNearbyFriends:user];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     WinkUser *user = arrNerabyList[indexPath.row];
    FriendProfileViewController *vc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    vc.profileId = [user.ID intValue];
    [self presentViewController:vc animated:YES completion:nil];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2.2, clcvNearByList.layer.frame.size.height/2.2);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self getNearbyListWithPage];
    NSLog(@"is scroll");
}
#pragma mark - SettingOptionViewControllerDelegate method
-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label
{
    selectedIndex = selectedId;
    selectedKM = arrOptions[selectedId];
    if([WinkUtil reachable])
    {
        [self getNearbyListWithPage];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
@end
