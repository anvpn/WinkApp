//
//  FriendProfileViewController.m
//  Wink
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "FriendProfileViewController.h"

@interface FriendProfileViewController ()<SettingOptionViewControllerDelegate>

@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnFrndRequest;

@property (weak, nonatomic) IBOutlet UIImageView *imgvVover;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblJobProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblReligion;

@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblGallaryCount;
@property (weak, nonatomic) IBOutlet UILabel *lblLikesCount;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFrndsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOnlineStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblJoinDate;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblRelationStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployment;
@property (weak, nonatomic) IBOutlet UILabel *lblWorldView;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalPriority;
@property (weak, nonatomic) IBOutlet UILabel *lblImportantInOthers;
@property (weak, nonatomic) IBOutlet UILabel *lblViewsSmoking;
@property (weak, nonatomic) IBOutlet UILabel *lblViewsAlcohol;
@property (weak, nonatomic) IBOutlet UILabel *lblLookingFor;
@property (weak, nonatomic) IBOutlet UILabel *lblGenderLike;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;


@property (weak, nonatomic) IBOutlet UIButton *btnGiver;
@property (weak, nonatomic) IBOutlet UILabel *lblGiverName;
@property (weak, nonatomic) IBOutlet UIButton *btnReceiver;
@property (weak, nonatomic) IBOutlet UILabel *lblReceiverName;
@property (weak, nonatomic) IBOutlet UIButton *btnChatter;
@property (weak, nonatomic) IBOutlet UILabel *lblChatterName;
@property (weak, nonatomic) IBOutlet UILabel *lblBoujeeName;
@property (weak, nonatomic) IBOutlet UIButton *btnBoujee;
@property (weak, nonatomic) IBOutlet UILabel *lblFireName;
@property (weak, nonatomic) IBOutlet UIButton *btnFire;
@property (weak, nonatomic) IBOutlet UILabel *lblFameName;
@property (weak, nonatomic) IBOutlet UIButton *btnFame;


@property (strong, nonatomic) NSArray *arrDetail;

@property (strong, nonatomic) WinkUser *selectedUser;

@end

@implementation FriendProfileViewController
@synthesize sideMenu,imgvVover,lblProfileName,btnProfilePic,lblFullName,lblUserName,lblGallaryCount,lblLikesCount,lblGiftsCount,lblFrndsCount,lblOnlineStatus,lblJoinDate,lblBirthDate,lblLocation,lblGender,lblRelationStatus,lblEmployment,lblWorldView,lblPersonalPriority,lblImportantInOthers,lblViewsSmoking,lblViewsAlcohol,lblLookingFor,lblGenderLike,scrlvBG,selectedUser,lblAge,lblJobProfile,lblHeight,lblReligion;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    [self getProfile];
    [scrlvBG setContentSize:CGSizeMake(scrlvBG.width, 1100)];
    [self prepareView];
    [self setupBasicDetails];
    
}
-(void)prepareView
{
    _btnChatter.layer.cornerRadius = _btnChatter.width /2;
    _btnChatter.clipsToBounds = YES;
    _btnChatter.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnChatter.layer.borderWidth = 2.0;
    
    _btnFame.layer.cornerRadius = _btnFame.width /2;
    _btnFame.clipsToBounds = YES;
    _btnFame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnFame.layer.borderWidth = 2.0;
    
    
    _btnBoujee.layer.cornerRadius = _btnBoujee.width /2;
    _btnBoujee.clipsToBounds = YES;
    _btnBoujee.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnBoujee.layer.borderWidth = 2.0;
    
    _btnFire.layer.cornerRadius = _btnFire.width /2;
    _btnFire.clipsToBounds = YES;
    _btnFire.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnFire.layer.borderWidth = 2.0;
    
    _btnGiver.layer.cornerRadius = _btnGiver.width /2;
    _btnGiver.clipsToBounds = YES;
    _btnGiver.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnGiver.layer.borderWidth = 2.0;
    
    _btnReceiver.layer.cornerRadius = _btnReceiver.width /2;
    _btnReceiver.clipsToBounds = YES;
    _btnReceiver.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnReceiver.layer.borderWidth = 2.0;
    [self getPeopleOftheDay];
}
-(void)getPeopleOftheDay
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID
                               };
        [WinkWebServiceAPI getPeopleOfTheDay:dict completionHandler:^(WinkAPIResponse *response, NSArray *arrPeople)
         {
             [SVProgressHUD dismiss];
             if(arrPeople.count > 0)
             {
                 _arrDetail = arrPeople;
                 [self displayDetails];
             }
             
         }];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)displayDetails
{
    NSDictionary *dict = (NSDictionary *)_arrDetail[0];
    
    NSDictionary *chatter = dict[@"chatter"];
    NSDictionary *boujee = (NSDictionary *)dict[@"boujee"];
    NSDictionary *giver = dict[@"giftTo"];
    NSDictionary *receiver = dict[@"giftFrom"];
    NSDictionary *fame = dict[@"fameUserData"];
    NSDictionary *fire = dict[@"fireUserData"];
    
    if([chatter isKindOfClass:[NSDictionary class]])
    {
        if(chatter.count > 0)
        {
            NSURL *url = [NSURL URLWithString:chatter[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnChatter setImageForState:UIControlStateNormal withURL:photourl];
            //_lblChatterName.text = chatter[UKeyName];
            NSString *isonline = [chatter[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblChatterName.textColor = [UIColor darkGrayColor];
                _lblChatterName.text = chatter[UKeyName];
            }
            else
            {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = chatter[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblChatterName.textColor = [UIColor darkGrayColor];
                _lblChatterName.attributedText = myString;
                NSLog(@"on line");
            }
            _btnChatter.tag = [chatter[@"user_id"]integerValue];
        }
    }
    else
    {
        _btnChatter.enabled = false;
    }
    if([boujee isKindOfClass:[NSDictionary class]])
    {
        if(boujee.count > 0)
        {
            NSURL *url = [NSURL URLWithString:boujee[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnBoujee setImageForState:UIControlStateNormal withURL:photourl];
            //_lblBoujeeName.text = boujee[UKeyName];
            _btnBoujee.tag = [boujee[@"user_id"]integerValue];
            NSString *isonline = [boujee[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblBoujeeName.textColor = [UIColor darkGrayColor];
                _lblBoujeeName.text = boujee[UKeyName];
            }
            else
            {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = boujee[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblBoujeeName.textColor = [UIColor darkGrayColor];
                _lblBoujeeName.attributedText = myString;
            }
        }
    }
    else
    {
        _btnBoujee.enabled = false;
    }
    if([giver isKindOfClass:[NSDictionary class]])
    {
        if(giver.count > 0)
        {
            NSURL *url = [NSURL URLWithString:giver[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnGiver setImageForState:UIControlStateNormal withURL:photourl];
            //_lblGiverName.text = giver[UKeyName];
            _btnGiver.tag = [giver[@"user_id"]integerValue];
            NSString *isonline = [giver[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblGiverName.textColor = [UIColor darkGrayColor];
                _lblGiverName.text = giver[UKeyName];
            }
            else
            {
                NSLog(@"on line");
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = giver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblGiverName.textColor = [UIColor darkGrayColor];
                _lblGiverName.attributedText = myString;
            }
        }
    }
    else
    {
        _btnGiver.enabled = false;
    }
    if([receiver isKindOfClass:[NSDictionary class]])
    {
        if(receiver.count > 0)
        {
            NSURL *url = [NSURL URLWithString:receiver[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnReceiver setImageForState:UIControlStateNormal withURL:photourl];
            //_lblReceiverName.text = receiver[UKeyName];
            _btnReceiver.tag = [receiver[@"user_id"]integerValue];
            NSString *isonline = [receiver[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblReceiverName.textColor = [UIColor darkGrayColor];
                _lblReceiverName.text = receiver[UKeyName];
            }
            else
            {
                NSLog(@"on line");
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = receiver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblReceiverName.textColor = [UIColor darkGrayColor];
                _lblReceiverName.attributedText = myString;
            }
        }
    }
    else
    {
        _btnReceiver.enabled = false;
    }
    if([fame isKindOfClass:[NSDictionary class]])
    {
        if(fame.count > 0)
        {
            NSURL *url = [NSURL URLWithString:fame[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnFame setImageForState:UIControlStateNormal withURL:photourl];
            //_lblFameName.text = fame[UKeyName];
            _btnFame.tag = [fame[@"user_id"]integerValue];
            NSString *isonline = [fame[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblFameName.textColor = [UIColor darkGrayColor];
                _lblFameName.text = fame[UKeyName];
            }
            else
            {
                NSLog(@"on line");
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fame[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblFameName.textColor = [UIColor darkGrayColor];
                _lblFameName.attributedText = myString;
            }
        }
    }
    else
    {
        _btnFame.enabled = false;
    }
    if([fire isKindOfClass:[NSDictionary class]])
    {
        if(fire.count > 0)
        {
            NSURL *url = [NSURL URLWithString:fire[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            
            [_btnFire setImageForState:UIControlStateNormal withURL:photourl];
            //_lblFireName.text = fire[UKeyName];
            _btnFire.tag = [fire[@"user_id"]integerValue];
            NSString *isonline = [fame[UKeyIsOnline]stringValue];
            if ([isonline isEqualToString:@"0"])
            {
                NSLog(@"offline");
                _lblFireName.textColor = [UIColor darkGrayColor];
                _lblFireName.text = fire[UKeyName];
            }
            else
            {
                NSLog(@"on line");
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fire[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblFireName.textColor = [UIColor darkGrayColor];
                _lblFireName.attributedText = myString;
            }
        }
    }
    else
    {
        _btnFire.enabled = false;
    }
}
-(void)setupBasicDetails
{
    selectedUser = _winkUser;
    [self prepareProfile];
    selectedUser = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)prepareProfile
{
    if (selectedUser.follow)
    {
        [_btnFrndRequest setImage:[UIImage imageNamed:@"img_RequestPending.png"] forState:UIControlStateNormal];
    }
    else
    {
        if(!selectedUser.isFriend)
        {
            [_btnFrndRequest setImage:[UIImage imageNamed:@"userPlus.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnFrndRequest setImage:[UIImage imageNamed:@"userMinus.png"] forState:UIControlStateNormal];
        }
    }
    if(selectedUser.isMyLike)
    {
        _btnLike.hidden = YES;
    }
    else
    {
        _btnLike.hidden = NO;
    }
   // if()
    [imgvVover setImageWithURL:selectedUser.originCoverURL];
    //[imgvVover setImageWithURL:selectedUser.originCoverURL placeholderImage:[UIImage imageNamed:@"defaultthumbnail.jpg"]];
    // UIImage *img = [UIImage imageWithData:data];
    
    //imgvVover.image = img;
    lblProfileName.text = selectedUser.name;
    [btnProfilePic setImageForState:UIControlStateNormal withURL:selectedUser.normalSizeProfURL];
    
    btnProfilePic.layer.cornerRadius = btnProfilePic.width /2;
    btnProfilePic.clipsToBounds = YES;
    //lblUserName.text = selectedUser.userName;
    lblUserName.text = [NSString stringWithFormat:@"@%@",selectedUser.userName];
    lblFullName.text = selectedUser.name;
    lblGallaryCount.text = [NSString stringWithFormat:@"%d",
                            selectedUser.photosCount];
    lblLikesCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.likesCount];
    lblGiftsCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.giftsCount];
    lblFrndsCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.friendsCount];
    
    if(selectedUser.isOnline)
        lblOnlineStatus.text = @"Online";
    else
        lblOnlineStatus.text = @"Offline";
    
    lblJoinDate.text        = selectedUser.createdDate;
    lblBirthDate.text    = [NSString stringWithFormat:@"%d/%d/%d",selectedUser.bDay,selectedUser.bMonth,selectedUser.bYear];
    lblLocation.text     = selectedUser.location;
    lblAge.text = selectedUser.age;
    lblJobProfile.text = selectedUser.adding_job;
    lblReligion.text  = selectedUser.religion;
    float height = [selectedUser.height floatValue];
    lblHeight.text    = [NSString stringWithFormat:@"%.1f",height];
    
    if(selectedUser.gender == 1)
    {
        lblGender.text      = @"Female";
    }
    else
    {
        lblGender.text      = @"Male";
    }
    lblRelationStatus.text = WinkGlobalObject.arrRstatus[selectedUser.rStatus];
    lblEmployment.text   = WinkGlobalObject.arrTypeOfEmployment[selectedUser.politicalView];
    lblWorldView.text   = WinkGlobalObject.arrWorldView[selectedUser.worldView];
    lblPersonalPriority.text = WinkGlobalObject.arrPersonalPrio[selectedUser.personalView];
    lblImportantInOthers.text = WinkGlobalObject.arrImportantInOther[selectedUser.importantInOthers];
    lblViewsSmoking.text = WinkGlobalObject.arrViewOnSmoking[selectedUser.smokingViews];
    lblViewsAlcohol.text = WinkGlobalObject.arrViewOnAlcohol[selectedUser.alcoholView];
    lblLookingFor.text  = WinkGlobalObject.arrLookingFor[selectedUser.lookingFor];
    lblGenderLike.text = WinkGlobalObject.arrInterestedIn[selectedUser.interested];
    CGSize scrollableSize = CGSizeMake(scrlvBG.frame.size.width,1300);
    [scrlvBG setContentSize:scrollableSize];
    //[scrlvBG setContentSize:CGSizeMake(scrlvBG.width, scrlvBG.height)];
    [SVProgressHUD dismiss];
    
    
    float scrollDuration = 3.0;
    
    [UIView animateWithDuration:scrollDuration animations:^{
        self.scrlvBG.contentOffset = CGPointMake(0, 0);
    }];
    
}
-(void)getProfile
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *userInfo = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   UKeyProfileId : [NSNumber numberWithInt:_profileId]
                                   };
        [WinkWebServiceAPI getProfile:userInfo completionHandler:^(WinkAPIResponse *response, WinkUser *user)
         {
             if(response.code == RCodeSuccess)
             {
            dispatch_async(dispatch_get_main_queue(), ^{
                     selectedUser = user;
                     [self prepareProfile];
                 });
                 
                
             }
             else if(response.message)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                     [self showAlertWithMessage:response.message];
                 });
                
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                     [self showAlertWithMessage:response.error.localizedDescription];
                 });
             }

         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)blockUser
{
    if([WinkUtil reachable])
        {
            [SVProgressHUD show];
            NSDictionary *dict = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   UKeyProfileId : [NSNumber numberWithInt:_profileId]
                                   };
            [WinkWebServiceAPI blockUserProfile:dict completionHandler:^(WinkAPIResponse *response)
             {
                 [SVProgressHUD dismiss];
                 
                 if(response.code == RCodeSuccess)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showAlertWithMessage:@"The user is added to blocked list"];
                         [self getProfile];
                     });
                    
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     [self showAlertWithMessage:response.message];

                 });
                 }
             }];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }

    
}
-(void)unBlockUser
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyProfileId : [NSNumber numberWithInt:_profileId]
                               };
        [WinkWebServiceAPI removeFromBlackList:dict completionHandler:^(WinkAPIResponse *response)
         {
            [SVProgressHUD dismiss];
             
             if(response.code == RCodeSuccess)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self showAlertWithMessage:@"The user is removed from blocked list"];
                     [self getProfile];
                 });
                 
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self showAlertWithMessage:response.message];

                 });
             }
         }];
        
        
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }

}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnReportTap:(id)sender
{
    SettingOptionViewController *svc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SettingOptionViewController"];
    
    svc.titleLable = @"Abuse Report";
    svc.arrOptions = @[@"Spam",@"Hate speech or violence",@"Nudity or Pornography",@"Fake profile"];
    svc.selectedIndex = 0;
    //svc.buttonLabel = lblButton;
    svc.delegate = self;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [svc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:svc animated:NO completion:nil];
}
- (IBAction)btnBlockTap:(id)sender
{
    if(selectedUser.isBlocked)
    {
        [self unBlockUser];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Block @%@",selectedUser.userName] message:[NSString stringWithFormat:@"@%@ will not be able to send you gifts or messages, and you wont get anymore notifications from @%@",selectedUser.userName,selectedUser.userName] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *Block = [UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self blockUser];
                                }];
        
        [alert addAction:Cancel];
        [alert addAction:Block];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label
{
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           UKeyProfileId : [NSNumber numberWithInt:_profileId],
                           @"reason" :[NSNumber numberWithInt:selectedId]
                           };
    
    
    if([WinkUtil reachable])
    {
        [WinkWebServiceAPI reportUserProfile:dict completionHandler:^(WinkAPIResponse *response)
        {
            if(response.code == RCodeSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertWithMessage:@"Profile Reported"];

                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertWithMessage:response.message];

                });
            }
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

- (IBAction)btnGallaryTap:(id)sender
{
    if(selectedUser.photosCount > 0)
    {
        MyGallaryViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"MyGallaryViewController"];
        gvc.isMenu = NO;
        gvc.profileId = selectedUser.ID;
        [self presentViewController:gvc animated:YES completion:nil];
    }
}
- (IBAction)btnLikesTap:(id)sender
{
    if(selectedUser.likesCount > 0)
    {
        ProfileLikesViewController *plvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileLikesViewController"];
        plvc.isMenu = NO;
        plvc.profileId = selectedUser.ID;
        [self presentViewController:plvc animated:YES completion:nil];
        
    }
}
- (IBAction)btnGiftsTap:(id)sender
{
    if(selectedUser.giftsCount > 0)
    {
        ProfileGiftsViewController *pgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileGiftsViewController"];
        pgvc.profileId = _profileId;
        [self presentViewController:pgvc animated:YES completion:nil];
    }
    
}
- (IBAction)btnFrndsTap:(id)sender
{
    if(selectedUser.friendsCount > 0)
    {
        FriendsViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendsViewController"];
        fvc.isMenu = NO;
        fvc.profileId = selectedUser.ID;
        [self presentViewController:fvc animated:YES completion:nil];
    }
}

- (IBAction)btnFrndRequestTap:(id)sender
{
    
    if(selectedUser.isFriend)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"UnFriend" message:@"Are you sure want to unfriend?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *Unfriend = [UIAlertAction actionWithTitle:@"UNFRIEND" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self unfriendUser];
                                }];
        
        [alert addAction:Cancel];
        [alert addAction:Unfriend];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if (selectedUser.follow)
        {

        }
        else
        {
            [self SendFriendRequest];
        }
    }
    
}
- (IBAction)btnSendGiftsTap:(id)sender
{
    ChooseGiftViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"ChooseGiftViewController"];
    cvc.selectedProfileId = selectedUser.ID;
    [self presentViewController:cvc animated:YES completion:nil];
    
}

- (IBAction)btnChatTap:(id)sender
{
    ChatViewController *chatvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ChatViewController"];
    NSString *strURL = [NSString stringWithFormat:@"%@",selectedUser.lowSizeProfURL];
    NSDictionary *dict = @{
                           @"id" : @"0",
                           @"withUserId" : selectedUser.ID,
                           @"withUserUsername" : selectedUser.userName,
                           @"withUserFullname" : selectedUser.name,
                           @"withUserPhotoUrl" : strURL
                        };
    WinkChat *chat = [[WinkChat alloc]initWithDictionary:dict];
    chatvc.chat = chat;
    [self presentViewController:chatvc animated:YES completion:nil];
}
-(IBAction)btnLikeProfileTap:(id)sender
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyProfileId : selectedUser.ID
                               };
        [WinkWebServiceAPI likeFriendProfile:dict completionHandler:^(WinkAPIResponse *response, NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 _btnLike.hidden = YES;
                 selectedUser.isMyLike = YES;
             }
             else if (response.message)
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
-(void)SendFriendRequest
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary * dict = @{
                                UKeyAccountId : WinkGlobalObject.user.ID,
                                UKeyAccessToken : WinkGlobalObject.accessToken,
                                UKeyProfileId : [NSNumber numberWithInt:_profileId]
                                };
        [WinkWebServiceAPI sendFriendRequest:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 [self showAlertWithMessage:@"Friend request sent successfully"];
                 [self getProfile];
             }
             
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }

}
-(void)unfriendUser
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary * dict = @{
                                UKeyAccountId : WinkGlobalObject.user.ID,
                                UKeyAccessToken : WinkGlobalObject.accessToken,
                                @"friendId" : selectedUser.ID
                                };
        [WinkWebServiceAPI unFriendUser:dict completionHAndler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 [self showAlertWithMessage:@"User unfriended successfully"];
                 [self getProfile];
             }
             
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }

}
- (IBAction)btnPeopleTap:(UIButton *)people
{
    
    if(people.tag == [WinkGlobalObject.user.ID intValue])
    {
        ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        pvc.isMenu = NO;
        [self presentViewController:pvc animated:YES completion:nil];
    }
    else
    {
        FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
        
        fvc.profileId = (int)people.tag;
        
        
        [self presentViewController:fvc animated:YES completion:nil];
    }
}
@end
