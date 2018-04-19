//
//  PeopleOfTheDayViewController.m
//  Wink
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "PeopleOfTheDayViewController.h"

@interface PeopleOfTheDayViewController ()
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
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@property (strong, nonatomic) NSArray *arrDetail;

@property (strong, nonatomic) SideBarViewController *sideMenu;

@end

@implementation PeopleOfTheDayViewController
@synthesize btnGiver,lblGiverName,btnReceiver,lblReceiverName,btnChatter,lblBoujeeName,btnBoujee,lblFireName,btnFire,lblFameName,btnFame,sideMenu,vwAd;

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
    
    [self prepareView];
    [self getPeopleOftheDay];
    
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    
    [self presentViewController:cvc animated:YES completion:nil];
}
-(void)prepareView
{
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        vwAd.hidden = YES;
    }
    
    btnChatter.layer.cornerRadius = btnChatter.width /2;
    btnChatter.clipsToBounds = YES;
    btnChatter.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnChatter.layer.borderWidth = 3.0;
    
    btnFame.layer.cornerRadius = btnFame.width /2;
    btnFame.clipsToBounds = YES;
    btnFame.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnFame.layer.borderWidth = 3.0;
    
    
    btnBoujee.layer.cornerRadius = btnBoujee.width /2;
    btnBoujee.clipsToBounds = YES;
    btnBoujee.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnBoujee.layer.borderWidth = 3.0;
    
    btnFire.layer.cornerRadius = btnFire.width /2;
    btnFire.clipsToBounds = YES;
    btnFire.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnFire.layer.borderWidth = 3.0;
    
    btnGiver.layer.cornerRadius = btnGiver.width /2;
    btnGiver.clipsToBounds = YES;
    btnGiver.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnGiver.layer.borderWidth = 3.0;
    
    btnReceiver.layer.cornerRadius = btnReceiver.width /2;
    btnReceiver.clipsToBounds = YES;
    btnReceiver.layer.borderColor = [UIColor lightTextColor].CGColor;
    btnReceiver.layer.borderWidth = 3.0;
    
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
            
            [btnChatter setImageForState:UIControlStateNormal withURL:photourl];
            
            if([chatter[@"online"]boolValue])
            {
                _lblChatterName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = chatter[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblChatterName.attributedText  = myString;
            }
            else
            {
                _lblChatterName.text = chatter[UKeyName];
                _lblChatterName.textColor = [UIColor darkGrayColor];
            }
            btnChatter.tag = [chatter[@"user_id"]integerValue];
        }
    }
    else
    {
        btnChatter.enabled = false;
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
            
            [btnBoujee setImageForState:UIControlStateNormal withURL:photourl];
            //lblBoujeeName.text = boujee[UKeyName];
            if([boujee[@"online"]boolValue])
            {
                lblBoujeeName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = boujee[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblBoujeeName.attributedText  = myString;
            }
            else
            {
                lblBoujeeName.text = boujee[UKeyName];
                lblBoujeeName.textColor = [UIColor darkGrayColor];
            }
            btnBoujee.tag = [boujee[@"user_id"]integerValue];
        }
    }
    else
    {
        btnBoujee.enabled = false;
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
            
            [btnGiver setImageForState:UIControlStateNormal withURL:photourl];
            //lblGiverName.text = giver[UKeyName];
            if([giver[@"online"]boolValue])
            {
                lblGiverName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = giver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblGiverName.attributedText  = myString;
            }
            else
            {
                lblGiverName.text = giver[UKeyName];
                lblGiverName.textColor = [UIColor darkGrayColor];
            }
            btnGiver.tag = [giver[@"user_id"]integerValue];
        }
    }
    else
    {
        btnGiver.enabled = false;
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
            
            [btnReceiver setImageForState:UIControlStateNormal withURL:photourl];
            //lblReceiverName.text = receiver[UKeyName];
            if([receiver[@"online"]boolValue])
            {
                lblReceiverName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = receiver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblReceiverName.attributedText  = myString;
            }
            else
            {
                lblReceiverName.text = receiver[UKeyName];
                lblReceiverName.textColor = [UIColor darkGrayColor];
            }
            btnReceiver.tag = [receiver[@"user_id"]integerValue];
        }
    }
    else
    {
        btnReceiver.enabled = false;
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
            
            [btnFame setImageForState:UIControlStateNormal withURL:photourl];
            //lblFameName.text = fame[UKeyName];
            if([fame[@"online"]boolValue])
            {
                lblFameName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fame[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblFameName.attributedText  = myString;
            }
            else
            {
                lblFameName.text = fame[UKeyName];
                lblFameName.textColor = [UIColor darkGrayColor];
            }
            btnFame.tag = [fame[@"user_id"]integerValue];
        }
    }
    else
    {
        btnFame.enabled = false;
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
            
            [btnFire setImageForState:UIControlStateNormal withURL:photourl];
            //lblFireName.text = fire[UKeyName];
            if([fire[@"online"]boolValue])
            {
                lblFireName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fire[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblFireName.attributedText  = myString;
            }
            else
            {
                lblFireName.text = fire[UKeyName];
                lblFireName.textColor = [UIColor darkGrayColor];
            }
            btnFire.tag = [fire[@"user_id"]integerValue];
        }
    }
    else
    {
        btnFire.enabled = false;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
- (IBAction)btnMenuTap:(id)sender
{
    sideMenu = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    [self.view addSubview:sideMenu.view];

    [sideMenu showMenu];
}
- (IBAction)btnPeopleTap:(UIButton *)people
{
    
    if(people.tag == [WinkGlobalObject.user.ID intValue])
    {
        ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        pvc.isMenu = NO;
        [self.navigationController presentViewController:pvc animated:YES completion:nil];
    }
    else
    {
        FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
        
        fvc.profileId = (int)people.tag;
        
        
        [self.navigationController presentViewController:fvc animated:YES completion:nil];
    }
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}


@end
