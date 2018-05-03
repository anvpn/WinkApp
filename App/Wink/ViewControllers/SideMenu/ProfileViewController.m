//
//  ProfileViewController.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) SideBarViewController *sideMenu;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (weak, nonatomic) IBOutlet UIImageView *imgvVover;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblGallaryCount;
@property (weak, nonatomic) IBOutlet UILabel *lblLikesCount;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFrndsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOnlineStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblJoinDate;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblJobProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblReligion;
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
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) WinkUser *selectedUser;
@property (strong, nonatomic) UIImage *selectedProfilPic;
@property (strong, nonatomic) UIImage *selectedCoverPhoto;

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

@property BOOL isProfilePhoto;

@end

@implementation ProfileViewController
@synthesize sideMenu,imgvVover,btnProfilePic,lblFullName,lblUserName,lblGallaryCount,lblLikesCount,lblGiftsCount,lblFrndsCount,lblOnlineStatus,lblJoinDate,lblBirthDate,lblLocation,lblGender,lblRelationStatus,lblEmployment,lblWorldView,lblPersonalPriority,lblImportantInOthers,lblViewsSmoking,lblViewsAlcohol,lblLookingFor,lblGenderLike,scrlvBG,selectedUser,btnMenu,selectedProfilPic,selectedCoverPhoto,isProfilePhoto,lblJobProfile,lblHeight,lblReligion,lblAge,adView,lblStatus;

-(void)viewWillAppear:(BOOL)animated
{
    self.view_Activity.backgroundColor = [UIColor whiteColor];
    self.view_Information.backgroundColor = [UIColor whiteColor];
    if(_isMenu)
    {
        [btnMenu setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnMenu setImage:[UIImage imageNamed:@"Back white.png"] forState:UIControlStateNormal];
    }
    if(WinkGlobalObject.user.isAdmob)
    {
        [adView addSubview:[self setUpAdvertisement]];
    }
    else
    {
       self.view.height = self.view.height - adView.height;
        adView.hidden = YES;
    }
    CGSize scrollableSize = CGSizeMake(scrlvBG.frame.size.width,1400);
    [scrlvBG setContentSize:scrollableSize];
    //[scrlvBG setContentSize:CGSizeMake(scrlvBG.width, 1400)];
   
    //ana
    [self prepareView];

    if(_winkSelectedUser != nil)
    {
        selectedUser = _winkSelectedUser;
        [self prepareProfile];
    }
    [self getProfile];

    self.btnProfilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnProfilePic.layer.borderWidth = 2;
    self.btnProfilePic.layer.masksToBounds=YES;
    //self.scrlvBG.contentSize = CGSizeMake(self.scrlvBG.frame.size.width, 1400);
    
    //[scrlvBG setContentSize:CGSizeMake(self.scrlvBG.frame.size.width, 1400)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view_Activity.backgroundColor = [UIColor whiteColor];
    self.view_Information.backgroundColor = [UIColor whiteColor];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)prepareProfile
{
    [imgvVover setImageWithURL:selectedUser.originCoverURL];
    // UIImage *img = [UIImage imageWithData:data];
    
    //imgvVover.image = img;
    
    [btnProfilePic setImageForState:UIControlStateNormal withURL:selectedUser.lowSizeProfURL];
    
    btnProfilePic.layer.cornerRadius = btnProfilePic.width /2;
    btnProfilePic.clipsToBounds = YES;
    lblUserName.text = [NSString stringWithFormat:@"@%@",selectedUser.userName];
    //lblUserName.text = selectedUser.userName;
    if (WinkGlobalObject.user.verify)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        //NSString *Name = selectedUser.name;
        NSString *Name = [NSString stringWithFormat:@"%@ ",selectedUser.name];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblFullName.attributedText  = myString;
    }
    else
    {
        lblFullName.text  = selectedUser.name;
    }
    //lblFullName.text = selectedUser.name;
    lblGallaryCount.text = [NSString stringWithFormat:@"%d",
                            selectedUser.photosCount];
    lblLikesCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.likesCount];
    lblGiftsCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.giftsCount];
    lblFrndsCount.text = [NSString stringWithFormat:@"%d",
                          selectedUser.friendsCount];
    if ([selectedUser.status isEqualToString:@""])
    {
        lblStatus.text = [NSString stringWithFormat:@"%@",selectedUser.status];
    }
    else
    {
        lblStatus.text = [NSString stringWithFormat:@"'%@'",selectedUser.status];
    }
    //lblStatus.text = [NSString stringWithFormat:@"'%@'",selectedUser.status];
    if(selectedUser.isOnline)
        lblOnlineStatus.text = @"Online";
    else
        lblOnlineStatus.text = @"Offline";
    
    lblJoinDate.text        = selectedUser.createdDate;
    if(selectedUser.isAllowBirthday)
    {
        lblBirthDate.text    = [NSString stringWithFormat:@"%d/%d/%d",selectedUser.bDay,selectedUser.bMonth,selectedUser.bYear];
    }
    else
    {
        lblBirthDate.text    = @"";
    }
    
    lblLocation.text     = selectedUser.location;
    if(selectedUser.gender == 1)
    {
        lblGender.text      = @"Female";
    }
    else
    {
        lblGender.text      = @"Male";
    }
    lblHeight.text = selectedUser.height;
    lblJobProfile.text = selectedUser.adding_job;
    lblReligion.text = selectedUser.religion;
    lblAge.text = selectedUser.age;
    lblRelationStatus.text = WinkGlobalObject.arrRstatus[selectedUser.rStatus];
    //lblEmployment.text   = WinkGlobalObject.arrTypeOfEmployment[selectedUse];
    lblWorldView.text   = WinkGlobalObject.arrWorldView[selectedUser.worldView];
    lblPersonalPriority.text = WinkGlobalObject.arrPersonalPrio[selectedUser.personalView];
    lblImportantInOthers.text = WinkGlobalObject.arrImportantInOther[selectedUser.importantInOthers];
    lblViewsSmoking.text = WinkGlobalObject.arrViewOnSmoking[selectedUser.smokingViews];
    lblViewsAlcohol.text = WinkGlobalObject.arrViewOnAlcohol[selectedUser.alcoholView];
    lblLookingFor.text  = WinkGlobalObject.arrLookingFor[selectedUser.lookingFor];
    lblGenderLike.text = WinkGlobalObject.arrInterestedIn[selectedUser.interested];
    CGSize scrollableSize = CGSizeMake(scrlvBG.frame.size.width,1400);
    [scrlvBG setContentSize:scrollableSize];
    //[scrlvBG setContentSize:CGSizeMake(scrlvBG.width, scrlvBG.height)];
    [SVProgressHUD dismiss];
}
-(void)getProfile
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *userInfo = @{
                                   UKeyAccountId : WinkGlobalObject.user.ID,
                                   UKeyAccessToken : WinkGlobalObject.accessToken,
                                   UKeyProfileId : WinkGlobalObject.user.ID
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
                 [SVProgressHUD dismiss];
                 [self showAlertWithMessage:response.message];
             }
             else
             {
                  [SVProgressHUD dismiss];
                 [self showAlertWithMessage:response.error.localizedDescription];
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
- (IBAction)btnFriendsTap:(id)sender
{
    FriendsViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    fvc.isMenu = NO;
    fvc.profileId = WinkGlobalObject.user.ID;
    [self presentViewController:fvc animated:YES completion:nil];
}
- (IBAction)btnGallaryTap:(id)sender
{
    MyGallaryViewController *mgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"MyGallaryViewController"];
    
    mgvc.profileId = WinkGlobalObject.user.ID;
    
    [self presentViewController:mgvc animated:YES completion:nil];
}
- (IBAction)btnLikesTap:(id)sender
{
    ProfileLikesViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileLikesViewController"];
    
    pvc.isMenu = NO;
    pvc.profileId = WinkGlobalObject.user.ID;
    [self presentViewController:pvc animated:YES completion:nil];
}
- (IBAction)btnGiftsTap:(id)sender
{
    ProfileGiftsViewController *pgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileGiftsViewController"];
    pgvc.profileId = [WinkGlobalObject.user.ID intValue];
    [self presentViewController:pgvc animated:YES completion:nil];
}
- (IBAction)btnEditTap:(id)sender
{
    EditProfileViewController *epvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    epvc.user = selectedUser;
    [self presentViewController:epvc animated:YES completion:nil];
}
- (IBAction)btnEditCoverTap:(id)sender
{
    isProfilePhoto = NO;
    [self askForImage];
}
- (IBAction)btnEditProfilePhotoTap:(id)sender
{
    isProfilePhoto = YES;
    [self askForImage];
}
#pragma mark - Uiimage selection method
-(void)askForImage
{
    [self.view endEditing:YES];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:AppName
                                                                         message:WinkAskImageSource
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:WinkTextFromCamera
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:WinkTextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:WinkTextCancel
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:fromAlbum];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)selectProfileImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        BOOL isAuthorizedLibrary = NO;
        
        if (photoStatus == PHAuthorizationStatusAuthorized)
        {
            // Access has been granted.
            isAuthorizedLibrary = YES;
            [self openImagePicker:sourceType];
        }
        else if (photoStatus == PHAuthorizationStatusDenied)
        {
            // Access has been denied.
        }
        else if (photoStatus == PHAuthorizationStatusNotDetermined)
        {
            // Access has not been determined.
        }
        else if (photoStatus == PHAuthorizationStatusRestricted)
        {
            // Restricted access - normally won't happen.
        }
        
        if (isAuthorizedLibrary == NO)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus Authstatus)
             {
                 if (Authstatus == PHAuthorizationStatusAuthorized)
                 {
                     [self openImagePicker:sourceType];
                 }
                 else
                 {
                     [self showAlertWithMessage:WinkAllowAccessPhotoLibrary];
                 }
             }];
        }
        
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        BOOL isAuthorizedCamera = NO;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            isAuthorizedCamera = YES;
            [self openImagePicker:sourceType];
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // denied
        }
        else if(authStatus == AVAuthorizationStatusRestricted)
        {
            // restricted, normally won't happen
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // not determined?!
        }
        else
        {
            // impossible, unknown authorization status
        }
        
        if (isAuthorizedCamera == NO)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self openImagePicker:sourceType];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self showAlertWithMessage:WinkAllowAccessCamera];
                                    });
                 }
             }];
        }
    }
    else
    {
        NSAssert(NO, @"Permission type not found");
    }
}
-(void)openImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImg = info[UIImagePickerControllerEditedImage];
         
         if(isProfilePhoto)
         {
             selectedProfilPic = selectedImg;
             [self uploadProfilePic];
         }
         else
         {
             selectedCoverPhoto = selectedImg;
             [self uploadCoverPhoto];
         }
     }];
}
-(void)uploadProfilePic
{
    
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        [WinkWebServiceAPI uploadProfilePhoto:dict withImage:selectedProfilPic completionHAndler:^(WinkAPIResponse *response, NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 NSURL *url = [NSURL URLWithString:responseDict[@"lowPhotoUrl"]];
                 NSString *lastComponent;
                 if([url isKindOfClass:[NSURL class]])
                 {
                     if(url != nil && url != NULL && (url.absoluteString.length != 0))
                     {
                         lastComponent = [url lastPathComponent];
                         WinkGlobalObject.user.lowSizeProfURL = [WinkWebservice URLForProfileImage:lastComponent];
                     }
                     
                 }
                 WinkGlobalObject.user.lowSizeProfString = responseDict[@"lowPhotoUrl"];
                 [btnProfilePic setImage:selectedProfilPic forState:UIControlStateNormal];
                 [WinkGlobalObject.user saveInUserDefaults];
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}
-(void)uploadCoverPhoto
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        [WinkWebServiceAPI uploadCoverPhoto:dict withImage:selectedCoverPhoto completionHAndler:^(WinkAPIResponse *response, NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 NSURL *url = [NSURL URLWithString:responseDict[@"originCoverUrl"]];
                 NSString *lastComponent;
                 if([url isKindOfClass:[NSURL class]])
                 {
                     if(url != nil && url != NULL && (url.absoluteString.length != 0))
                     {
                         lastComponent = [url lastPathComponent];
                         WinkGlobalObject.user.originCoverURL = [WinkWebservice URLForCoverImage:lastComponent];
                     }
                     
                 }
                 WinkGlobalObject.user.originCoverString = responseDict[@"originCoverUrl"];
                 [WinkGlobalObject.user saveInUserDefaults];
                 [imgvVover setImage:selectedCoverPhoto];
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
        
        
        
        NSDictionary *arrDict = [_arrDetail objectAtIndex:0];
        NSDictionary *matchDict = [[NSDictionary alloc]init];
        
        for (int i = 0; i < arrDict.count; i++) {
            NSDictionary *dict = [arrDict.allValues objectAtIndex:i];
            if([dict.allValues containsObject:[NSString stringWithFormat:@"%d",people.tag]])
            {
                NSLog(@"YES");
                matchDict = dict;
                NSLog(@"dict %@",dict);
                
                if(([dict objectForKey:@"fullname"] != [NSNull null]))
                    fvc.tempName = [dict valueForKey:@"fullname"];
                
                if(([dict objectForKey:@"login"] != [NSNull null]))
                    fvc.tempUserName = [dict valueForKey:@"login"];
                fvc.tempImgProfile = people.imageView.image;
                break;
            }
        }
        
        fvc.profileId = (int)people.tag;
        
        
        [self presentViewController:fvc animated:YES completion:nil];
    }
}
- (IBAction)btn_posttap:(id)sender
{
    UploadGallaryIteamViewController *igvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"UploadGallaryIteamViewController"];
    
    [self presentViewController:igvc animated:YES completion:nil];
}

@end
