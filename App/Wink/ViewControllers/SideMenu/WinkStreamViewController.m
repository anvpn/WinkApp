//
//  WinkStreamViewController.m
//  Wink
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkStreamViewController.h"
#import "cell_winkStream.h"

@interface WinkStreamViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *clcvStream;
@property (weak, nonatomic) IBOutlet UITableView *tbl_Photostream;

@property (strong, nonatomic) NSMutableArray *arrStreamList;
@property (strong, nonatomic) NSMutableArray *arrFeedList;

@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnWinkStream;
@property (weak, nonatomic) IBOutlet UIView *vwSlider;
@property (weak, nonatomic) IBOutlet UIButton *btnFrndFeed;

@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (weak, nonatomic) IBOutlet UIView *vwAdView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@property BOOL isStream;
@property CGFloat sliderY;
@property NSString *pageNO;
@property BOOL isViewDidLoadCall;
@property (strong,nonatomic) UIRefreshControl *refreshControl;


@end

@implementation WinkStreamViewController
@synthesize clcvStream,arrStreamList,sideMenu,isStream,btnWinkStream,btnFrndFeed,vwSlider,arrFeedList,sliderY,pageNO,btnUpload,vwAdView,tbl_Photostream,refreshControl;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //ana
    _isViewDidLoadCall = true;
    arrStreamList = [[NSMutableArray alloc]init];
   // isStream = YES;
//---ana---
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;

    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];

    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;

 if([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
     {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
     }
   // clcvStream.hidden=YES;
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];

    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tbl_Photostream addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getWinkStreamData) forControlEvents:UIControlEventValueChanged];

}
-(void)viewDidAppear:(BOOL)animated
{
    //arrFeedList = [[NSMutableArray alloc]init];
    pageNO = @"0";
//    isStream = false;
    sliderY = vwSlider.y;

    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAdView addSubview:[self setUpAdvertisement]];
    }
    else
    {
        //clcvStream.height = clcvStream.height + vwAdView.height;
        tbl_Photostream.height = tbl_Photostream.height + vwAdView.height;
        vwAdView.hidden = YES;
    }

    
    if(arrStreamList.count <= 20)
    {
        [self btnWinkStreamTap:btnWinkStream];
    }
    else
    {
        [tbl_Photostream reloadData];
    }
    //[self getWinkStreamData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapToDismiss:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];

    _lbl_Notificationcount.layer.cornerRadius = _lbl_Notificationcount.frame.size.width/2;
    _lbl_Notificationcount.clipsToBounds = true;
    _lbl_Notificationcount.layer.masksToBounds = true;
    
    [tbl_Photostream reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isViewDidLoadCall = false;
}

-(void)getWinkStreamData
{
    if(!isStream)
    {
        [self getFriendsFeedData];
        return;
    }
    
    if([WinkUtil reachable])
    {
        if (_isViewDidLoadCall) {
            [SVProgressHUD show];

        }
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               };
        
        [WinkWebServiceAPI getWinkStream:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId)
         {
            [SVProgressHUD dismiss];
             [refreshControl endRefreshing];
           if(response.code == RCodeSuccess)
           {
               arrStreamList = [[NSMutableArray alloc]init];
               arrStreamList = arrPhotos.mutableCopy;
               pageNO = [NSString stringWithFormat:@"%d",iteamId];
               [tbl_Photostream reloadData];
               
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
-(void)getWinkStreamDataOfOtherPage
{
    if([WinkUtil reachable] && pageNO != 0)
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"itemId" : [NSString stringWithFormat:@"%@",pageNO]

                               };
        
        [WinkWebServiceAPI getWinkStream:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 //ana
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [arrStreamList addObjectsFromArray:arrPhotos];
                     pageNO = [NSString stringWithFormat:@"%d",iteamId];
                     NSLog(@"pageNO -----> %@",pageNO);
                     //[clcvStream reloadData];
                     [tbl_Photostream reloadData];
                     //[clcvStream reloadData];
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
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }

}
-(void)getFriendsFeedData
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        
        [WinkWebServiceAPI getFriendsFeed:dict completionHAndler:^(WinkAPIResponse *response, NSMutableArray *arrPhotos)
        {
             [SVProgressHUD dismiss];
            [refreshControl endRefreshing];
             if(response.code == RCodeSuccess)
             {
                 arrFeedList = arrPhotos.mutableCopy;
                 [tbl_Photostream reloadData];
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
- (IBAction)btnMenuTap:(id)sender
{
    sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    [self.view addSubview:sideMenu.view];
    [sideMenu showMenu];
}
- (IBAction)btnWinkStreamTap:(id)sender
{
    [tbl_Photostream setContentOffset:tbl_Photostream.contentOffset animated:NO];
    if(!isStream)
    {
        isStream = YES;
        
        [UIView animateWithDuration:0.5 animations:^
        {
            vwSlider.center = CGPointMake(btnWinkStream.center.x,vwSlider.y);
            vwSlider.y = sliderY;
        }];
        btnUpload.hidden = NO;
        //tbl_Photostream.hidden=NO;
        //clcvStream.hidden=YES;
        pageNO=@"0";
        [self getWinkStreamData];
    }
}
- (IBAction)btnFrndFeedTap:(id)sender
{
    [tbl_Photostream setContentOffset:tbl_Photostream.contentOffset animated:NO];
    if(isStream)
    {
        isStream = NO;
        [UIView animateWithDuration:0.5 animations:^
         {
             vwSlider.center = CGPointMake(btnFrndFeed.center.x,vwSlider.y);
             vwSlider.y = sliderY;
         }];
        arrFeedList = [[NSMutableArray alloc]init];
        btnUpload.hidden = YES;
        //tbl_Photostream.hidden=YES;
        //clcvStream.hidden=NO;
        [self getFriendsFeedData];
        
    }
}
- (IBAction)btnUploadTap:(id)sender
{
    UploadGallaryIteamViewController *igvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"UploadGallaryIteamViewController"];
    
    [self presentViewController:igvc animated:YES completion:nil];
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - collection view code is commented by ana

#pragma mark - UICollectionView Datasource & Delegate Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)];
    if(isStream)
    {
        if(arrStreamList.count > 0)
        {
            noDataLabel.hidden=YES;
            return arrStreamList.count;
            
        }
        else
        {
            noDataLabel.hidden=NO;
            //noDataLabel.text             = @"No data available";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            collectionView.backgroundView = noDataLabel;
        }
    }
    else
    {
        if(arrFeedList.count > 0)
        {
            noDataLabel.hidden=YES;
             return arrFeedList.count;
        }
        else
        {
            noDataLabel.hidden=NO;
            //noDataLabel.text             = @"No data available";
            noDataLabel.textColor         = [UIColor blackColor];
            noDataLabel.textAlignment      = NSTextAlignmentCenter;
            collectionView.backgroundView  = noDataLabel;

        }
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StreamCell" forIndexPath:indexPath];
    WinkPhotos *photo;
    
    if(isStream)
    {
        photo = arrStreamList[indexPath.row];
    }
    else
    {
        photo = arrFeedList[indexPath.row];
    }
    
    [cell.imgvProfilePic setImageWithURL:photo.gallaryNormalPhotoURL];
    if(photo.isVideo)
    {
        cell.imgvvideoLayer.hidden = NO;
    }
    else
    {
        cell.imgvvideoLayer.hidden = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WinkPhotos *photo;
    if(isStream)
    {
        photo = arrStreamList[indexPath.row];
    }
    else
    {
        photo = arrFeedList[indexPath.row];
    }
    GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
    
    gvc.selectedPhoto = photo;
    
    [self presentViewController:gvc animated:YES completion:nil];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"SETTING SIZE FOR ITEM AT INDEX %ld", (long)indexPath.row);
    CGSize mElementSize = CGSizeMake(100, 106);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isStream)
    {
//        [self getWinkStreamDataOfOtherPage];
    }
    else
    {
        
    }

}
#pragma mark - UITableview delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    if(isStream)
    {
        if(arrStreamList.count > 0)
        {
            noDataLabel.hidden=YES;
            tableView.backgroundView = noDataLabel;
            return arrStreamList.count;
        }
        else
        {
            noDataLabel.hidden=NO;
            //noDataLabel.text             = @"No data available";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
        }
    }
    else
    {
        if(arrFeedList.count > 0)
        {
            noDataLabel.hidden=YES;
            tableView.backgroundView = noDataLabel;
            return arrFeedList.count;
        }
        else
        {
            noDataLabel.hidden=NO;
            //noDataLabel.text             = @"No data available";
            noDataLabel.textColor         = [UIColor blackColor];
            noDataLabel.textAlignment      = NSTextAlignmentCenter;
            tableView.backgroundView  = noDataLabel;
            
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 350;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    cell_winkStream *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[cell_winkStream alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    //NSMutableDictionary *Dict = [arrStreamList objectAtIndex:indexPath.row];
    WinkPhotos *Photos;
    if(isStream)
    {
        Photos = arrStreamList[indexPath.row];
    }
    else
    {
        //ana
        if(arrFeedList != nil && arrFeedList.count > 0 && arrFeedList.count > indexPath.row)
        Photos = arrFeedList[indexPath.row];
    }
    
    cell.user_profile_img.layer.cornerRadius = cell.user_profile_img.layer.frame.size.width/2;
    cell.user_profile_img.layer.borderWidth = 1;
    cell.user_profile_img.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.user_profile_img.layer.masksToBounds = YES;
    [cell.user_profile_img setImageWithURL:Photos.userPhotoURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
   
    
    if (Photos.isUserVerify)
    {
        if ([Photos.fullName isKindOfClass:[NSNull class]])
        {
            cell.lbl_user_fullname.text = @"";
        }
        else
        {
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
            
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            //NSString *Namestr = Photos.fullName;
            NSString *Namestr = [NSString stringWithFormat:@"%@ ",Photos.fullName];
            NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Namestr];
            [myString appendAttributedString:attachmentString];
            //lblFullName.attributedText  = myString;
            //Name.attributedText = myString;
            cell.lbl_user_fullname.attributedText = myString;
        }
    }
    else
    {
        if ([Photos.fullName isKindOfClass:[NSNull class]])
        {
            cell.lbl_user_fullname.text = @"";
        }
        else
        {
            
            cell.lbl_user_fullname.text = Photos.fullName;
        }
    }
    
    
    
  //  NSLog(@"fullName:-%@",Name.text);
    //
//    UILabel *UserName = (UILabel *)[cell viewWithTag:102];
    //UserName.text = Photos.userName;
    if ([Photos.userName isKindOfClass:[NSNull class]])
    {
        cell.lbl_user_userName.text = @"";
    }
    else
    {
        cell.lbl_user_userName.text =[NSString stringWithFormat:@"@%@",Photos.userName];
    }
    NSLog(@"userName:-%@",cell.lbl_user_userName.text);
    //
    NSString *s;
    if (Photos.isAccessMode)
    {
        s=@"Friends";
    }
    else
    {
        s=@"Public";
    }
   // UILabel *Status = (UILabel *)[cell viewWithTag:103];
    cell.lbl_user_activation_time .text = [NSString stringWithFormat:@"%@ - %@",Photos.timeAgo,s];
    NSLog(@"Status:-%@",cell.lbl_user_activation_time.text);
    //
//    UIImageView *DataImage = (UIImageView *)[cell viewWithTag:104];
    //DataImage.layer.borderWidth = 1;
    //DataImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    ///DataImage.layer.masksToBounds = YES;
    //defaultthumbnail.jpg
    //[DataImage setImageWithURL:Photos.gallaryNormalPhotoURL];
    //
    [cell.img_user_postItem setImageWithURL:Photos.gallaryNormalPhotoURL placeholderImage:[UIImage imageNamed:@"defaultthumbnail.jpg"]];
    
    
    
    //UILabel *Message = (UILabel *)[cell viewWithTag:106];
    cell.lbl_commentCount.text = Photos.commentCount;
   // NSLog(@"Message:-%@",Message.text);
    //
   // UILabel *Like = (UILabel *)[cell viewWithTag:107];
    cell.lbl_likeCount.text = Photos.likesCount;
  //  NSLog(@"Like:-%@",Like.text);
    //
   // UIButton *Btn_Message = (UIButton *)[cell viewWithTag:105];
    [cell.btnComment addTarget:self action:@selector(MessageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //
    cell.btnComment.tag = indexPath.row;
    //UIButton *Btn_Like = (UIButton *)[cell viewWithTag:108];
    if (Photos.isMyLike)
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"perk_active.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"perk.png"] forState:UIControlStateNormal];
    }
    [cell.btnLike addTarget:self action:@selector(LikeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
   // UIImageView *imgvPlay = (UIImageView *) [cell viewWithTag:109];
    if(Photos.isVideo)
    {
        cell.imgVideo.hidden = NO;
    }
    else
    {
        cell.imgVideo.hidden = YES;
    }
    
    
    UIView* shadowView = cell.vwContainer;

    shadowView.backgroundColor=[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:0.5];
   // [shadowView.layer setCornerRadius:5.0f];
    [shadowView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [shadowView.layer setBorderWidth:1.0f];
    [shadowView.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [shadowView.layer setShadowOpacity:1.0];
    [shadowView.layer setShadowRadius:5.0];
    [shadowView.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrStreamList.count > 0)
    {
        WinkPhotos *photo;
        if(isStream)
        {
            photo = arrStreamList[indexPath.row];
        }
        else
        {
            photo = arrFeedList[indexPath.row];
        }
        
        GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
        //gvc.selectedPhoto = photo;
        gvc.selectedPhoto = photo;
        gvc.ItemId = photo.photoId;
        [self presentViewController:gvc animated:YES completion:nil];
    }
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld",(long)indexPath.row);
   
    //ana 
    if(isStream)
    {
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
            // This is the last cell
            [self getWinkStreamDataOfOtherPage];
        }
        
    }
    
    
    
}
-(void)MessageButtonClicked:(UIButton*)sender
{
    //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tbl_Photostream];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        WinkPhotos *Photos = arrStreamList[indexPath.row];
        NSLog(@"%@",Photos.fullName);
        GallaryIteamViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"GallaryIteamViewController"];
        gvc.selectedPhoto = Photos;
        gvc.ItemId = Photos.photoId;
        [self presentViewController:gvc animated:YES completion:nil];
    
}
-(void)LikeButtonClicked:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tbl_Photostream];
    NSIndexPath *indexPath = [self.tbl_Photostream indexPathForRowAtPoint:buttonPosition];
    WinkPhotos *Photos = arrStreamList[indexPath.row];
    NSLog(@"%@",Photos.fullName);
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"itemId" : Photos.photoId
                               };
        [WinkWebServiceAPI likeGallaryIteam:dict completionHandler:^(WinkAPIResponse *response, int Likes , BOOL isMyLike)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 //ana changes :----
                 
                 WinkPhotos *photo = [arrStreamList objectAtIndex:indexPath.row];
                 
                 cell_winkStream *cell = [tbl_Photostream cellForRowAtIndexPath:indexPath];
                 cell.lbl_likeCount.text = [NSString stringWithFormat:@"%d",Likes];
                 photo.likesCount = [NSString stringWithFormat:@"%d",Likes];
                 photo.isMyLike = isMyLike;

                 if (isMyLike)
                 {
                     [cell.btnLike setImage:[UIImage imageNamed:@"perk_active.png"] forState:UIControlStateNormal];
                 }
                 else
                 {
                     [cell.btnLike setImage:[UIImage imageNamed:@"perk.png"] forState:UIControlStateNormal];
                 }
                 
                 [tbl_Photostream reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                 
                 
                 
//                 [self getWinkStreamData];
                 //[self setLikesView:Likes andIsMyLike:isMyLike];
             }
             else
             {
                 [self showAlertWithMessage:@"Something went wrong,Please try again later"];
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];

}

//-(void)tapToDismiss:(NSNotification *)notification{
//    [SVProgressHUD dismiss];
//    //maybe other code to stop whatever your progress is
//}

@end
