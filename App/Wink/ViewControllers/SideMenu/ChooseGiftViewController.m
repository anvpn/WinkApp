//
//  ChooseGiftViewController.m
//  Wink
//
//  Created by Apple on 14/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ChooseGiftViewController.h"

@interface ChooseGiftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *clcvGift;
@property (strong, nonatomic) NSArray *arrGiftList;

@end

@implementation ChooseGiftViewController
@synthesize arrGiftList,clcvGift;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.minimumInteritemSpacing = 0.0f;
    //layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(8.0f,8.0f,8.0f,8.0f);
    clcvGift.collectionViewLayout = layout;
    if([WinkUtil reachable])
    {
        [self getGiftList];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getGiftList
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken: WinkGlobalObject.accessToken
                           };
    
    [WinkWebServiceAPI getCommonGiftList:dict completionHAndler:^(WinkAPIResponse *response, NSArray *arrGifts)
    {
        [SVProgressHUD dismiss];
        arrGiftList = arrGifts;
        [clcvGift reloadData];
        if(response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:response.error.localizedDescription];
        }
    }];
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  arrGiftList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftSendCell" forIndexPath:indexPath];
    
    NSDictionary *dict = arrGiftList[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:dict[@"imgUrl"]];
    NSString *lastComponent;
    NSURL *giftURL;
    
    if([url isKindOfClass:[NSURL class]])
    {
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            giftURL = [WinkWebservice URLForGiftImage:lastComponent];
        }
        
    }

    
    [cell.imgvProfilePic setImageWithURL:giftURL placeholderImage:[UIImage imageNamed:@"profile_default_photo"]];
    cell.lblCredit.text = [NSString stringWithFormat:@"%@ Credits",dict[@"cost"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = arrGiftList[indexPath.row];
    
    int cost = [dict[@"cost"]intValue];
    if(WinkGlobalObject.user.balance > cost)
    {
        SendGiftViewController *svc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"SendGiftViewController"];
        
        svc.selectedProfileId = _selectedProfileId;
        svc.selectedDict = dict;
        
        [self presentViewController:svc animated:YES completion:nil];

    }
    else
    {
        [self showAlertWithMessage:@"Not enough credit"];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2.2, clcvGift.layer.frame.size.height/2.2);
}
@end
