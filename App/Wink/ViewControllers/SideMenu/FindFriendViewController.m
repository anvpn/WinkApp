//
//  FindFriendViewController.m
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "FindFriendViewController.h"
#import "CCTextFieldEffects.h"

@interface FindFriendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,SearchSettingViewControllerDelegate>
{
    int click;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
//@property (weak, nonatomic) IBOutlet HoshiTextField *txtSearch;



@property (weak, nonatomic) IBOutlet UILabel *lblTotalFound;
@property (weak, nonatomic) IBOutlet UICollectionView *clcvFrnd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (strong, nonatomic) NSMutableArray *arrFrndList;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;
@property int gender;
@property int online;
@property int ageFrom;
@property int ageTo;
@property (weak, nonatomic) IBOutlet UIButton *btn_notification;

@property (strong, nonatomic) NSString *searchText;
@property NSString *selectedKM;

@property NSString *sIteamId;
@property NSString *fIteamId;
@property NSString *nIteamId;

@property BOOL isFilter;
@property BOOL islocation;

@end

@implementation FindFriendViewController

@synthesize txtSearch,lblTotalFound,clcvFrnd,sideMenu,arrFrndList,gender,online,ageFrom,ageTo,searchText,selectedKM,vwAd,sIteamId,isFilter,islocation,fIteamId,nIteamId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    click = 1;
    UIColor *color = [UIColor whiteColor];
    txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    
    txtSearch.hidden=YES;
    [_btn_search setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    [_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    arrFrndList = [[NSMutableArray alloc]init];
    gender = -1;
    online = -1;
    ageFrom = 13;
    ageTo = 110;
    selectedKM = @"80 Kilometers";
    sIteamId = @"0";
    nIteamId = @"0";
    fIteamId = @"0";
    
    isFilter = NO;
    islocation = NO;
    
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
    
    clcvFrnd.collectionViewLayout = layout;
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        clcvFrnd.height = clcvFrnd.height + vwAd.height;
        vwAd.hidden = YES;
    }
    
    if([WinkUtil reachable])
    {
        //[self getFrndList];
        //Note : the Above method is commented as it is no use according to me
        [self getNearbyList];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.btnNearBy.layer.cornerRadius = 8;
    _btnNearBy.clipsToBounds = true;
    _btnNearBy.layer.borderColor = [UIColor purpleColor].CGColor;
    _btnNearBy.layer.borderWidth = 1;
    
    self.btnFilter.layer.cornerRadius = 8;
    _btnFilter.clipsToBounds = true;
    _btnFilter.layer.borderColor = [UIColor purpleColor].CGColor;
    _btnFilter.layer.borderWidth = 1;
    
}


- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)getFrndList
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"gender" : [NSNumber numberWithInt:gender],
                           @"online" : [NSNumber numberWithInt:online],
                           @"ageFrom" :[NSNumber numberWithInt:ageFrom],
                           @"ageTo" : [NSNumber numberWithInt:ageTo],
                           @"itemId" : sIteamId,
                           };
    [WinkWebServiceAPI searchFriendsList:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrFriends, NSString *iteamId1)
     {
         [SVProgressHUD dismiss];
         sIteamId = iteamId1;
         if(response.code == RCodeSuccess)
         {
             [arrFrndList addObjectsFromArray:arrFriends];
             [clcvFrnd reloadData];
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
-(void)getFilterFrndList
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"gender" : [NSNumber numberWithInt:gender],
                               @"online" : [NSNumber numberWithInt:online],
                               @"ageFrom" :[NSNumber numberWithInt:ageFrom],
                               @"ageTo" : [NSNumber numberWithInt:ageTo],
                               @"query" : searchText.length> 0 ? searchText:@"",
                               @"itemId" : fIteamId
                               };
        [WinkWebServiceAPI searchFriendsListWithFilter:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *arrFriends, int friendCount, NSString *item)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 fIteamId = item;
                 [arrFrndList addObjectsFromArray:arrFriends];
                 if(friendCount > 0)
                 {
                     lblTotalFound.text = [NSString stringWithFormat:@"Find People: %lu",(unsigned long)arrFrndList.count];
                 }
                 else
                 {
                      lblTotalFound.text = @"";
                     UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, clcvFrnd.bounds.size.width, clcvFrnd.bounds.size.height)];
                     //noDataLabel.text             = @"No data available";
                     noDataLabel.textColor        = [UIColor blackColor];
                     noDataLabel.textAlignment    = NSTextAlignmentCenter;
                     clcvFrnd.backgroundView = noDataLabel;
                 }
                 [clcvFrnd reloadData];
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
-(void)getNearbyList
{
    
    //ana
    if(WinkGlobalObject.currentLattitude == nil && WinkGlobalObject.currentLongitude == nil)
    {
        WinkGlobalObject.currentLattitude = @"0.0";
        WinkGlobalObject.currentLongitude = @"0.0";
    }
    
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"distance" : selectedKM,
                           @"lat" : WinkGlobalObject.currentLattitude,
                           @"lng" : WinkGlobalObject.currentLongitude,
                           //@"itemId" : [NSString stringWithFormat:@"%@",nIteamId]
                           };
    
    NSLog(@"dict send for getting near by friends are %@",dict);
    [WinkWebServiceAPI getNearByFriendsList:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrFriends, int iteamId)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             nIteamId = [NSString stringWithFormat:@"%d",iteamId];
             // arrNerabyList = arrFriends.mutableCopy;
             
             NSLog(@" --------- count of near by friends %lu",(unsigned long)arrFriends.count);
             
             [arrFrndList addObjectsFromArray:arrFriends];
             
             [clcvFrnd reloadData];
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

- (IBAction)btnMenuTap:(id)sender
{
    if(!sideMenu)
    {
        sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideMenu.view];
    }
    [sideMenu showMenu];
}
- (IBAction)btn_Location:(id)sender
{
   
    
    NSString *Lat = WinkGlobalObject.currentLattitude;
    if (Lat.length==0)
    {
        [self showAlertWithMessage:@"Please give location permission from setting > Wink > Location"];
    }
    else
    {
        arrFrndList = [[NSMutableArray alloc]init];
        isFilter = NO;
        islocation = YES;
        [self getNearbyList];
    }
    
//    if ([WinkGlobalObject.currentLattitude isEqualToString:@""])
//    {
//        [self showAlertWithMessage:@"Please give location permission from setting > Wink > Location"];
//    }
//    else
//    {
//        [self getNearbyList];
//    }
}

- (IBAction)btnFilterTap:(id)sender
{
    SearchSettingViewController *picker = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SearchSettingViewController"];
    picker.delegate = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    picker.gender = gender;
    picker.online = online;
    
    picker.AgeTo = ageTo;
    picker.AgeFrom = ageFrom;
    
    [picker setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:picker animated:NO completion:nil];
}
#pragma mark - UIColeectionview Delegate & Datasource method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrFrndList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindFriendCell" forIndexPath:indexPath];
    WinkUser *user = arrFrndList[indexPath.row];
    [cell setSearchFrndData:user];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 3;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WinkUser *user = arrFrndList[indexPath.row];
    
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    
    fvc.profileId = [user.ID intValue];
    
    FriendsCollectionCell *cell = (FriendsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    fvc.tempName = user.name;
    fvc.tempUserName = [NSString stringWithFormat:@"@%@",user.userName];
    fvc.tempImgProfile = cell.imgvProfilePic.image;
    [self.navigationController presentViewController:fvc animated:YES completion:nil];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2.2, clcvFrnd.layer.frame.size.height/2.2);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(isFilter)
    {
        //[self getFilterFrndList];
        
    }
    else if(islocation)
    {
        //[self getNearbyList];
    }
    else
    {
        //[self getFrndList];
    }
    
}
#pragma mark - UITextfield delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    click =1;
    [_btn_search setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    
    txtSearch.hidden=YES;
    _btnBalance.hidden=NO;
    _btn_notification.hidden=NO;
    lblTotalFound.hidden=NO;
    searchText = [textField.text stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
    [textField resignFirstResponder];
    
    
    if(searchText.length > 0)
    {
        if([WinkUtil reachable])
        {
            fIteamId = @"0";
            arrFrndList = [[NSMutableArray alloc]init];
            isFilter = YES;
            islocation = NO;
            [self getFilterFrndList];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
    
    txtSearch.text = @"";
    
    return YES;
}
#pragma mark - SearchSettingViewControllerDelegate method
-(void)selectedData:(NSDictionary *)dict
{
    gender = [dict[@"gender"]intValue];
    online = [dict[@"online"]intValue];
    ageFrom = [dict[@"agefrom"]intValue];
    ageTo = [dict[@"ageto"]intValue];
    isFilter = YES;
    islocation = NO;
    fIteamId = @"0";
    arrFrndList = [[NSMutableArray alloc]init];
    [self getFilterFrndList];
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}
- (IBAction)btn_search:(id)sender
{
    if (click == 1)
    {
        click =2;
        [_btn_search setImage:[UIImage imageNamed:@"btn_closesearch.png"] forState:UIControlStateNormal];
        txtSearch.hidden=NO;
        [txtSearch becomeFirstResponder];
        [[UITextField appearance] setTintColor:[UIColor whiteColor]];

        _btnBalance.hidden=YES;
        _btn_notification.hidden=YES;
        lblTotalFound.hidden=YES;
    }
    else
    {
        click =1;
        txtSearch.text = @"";
        [_btn_search setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
        txtSearch.hidden=YES;
        _btnBalance.hidden=NO;
        _btn_notification.hidden=NO;
        lblTotalFound.hidden=NO;
    }
    
}
@end
