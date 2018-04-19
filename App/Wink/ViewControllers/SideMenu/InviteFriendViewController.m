//
//  InviteFriendViewController.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "InviteFriendViewController.h"


NSString *AppURL = @"https://itunes.apple.com/us/app/wink-free-dating-ios-app/id1256893097";
@interface InviteFriendViewController ()<UITableViewDelegate,UITableViewDataSource,FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCntacts;
@property (weak, nonatomic) IBOutlet UIButton *btnWeb;
@property (weak, nonatomic) IBOutlet UIView *vwSlider;
@property (weak, nonatomic) IBOutlet UIView *vwWebInvite;
@property (weak, nonatomic) IBOutlet UIView *vwContactInvite;
@property (weak, nonatomic) IBOutlet UITableView *tblvContacts;
@property (weak, nonatomic) IBOutlet UIView *vwAd;
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;

@property (weak, nonatomic) IBOutlet UIButton *btn_invFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btn_invTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btn_invWhatsapp;
@property (weak, nonatomic) IBOutlet UIButton *btn_invEmail;
@property (weak, nonatomic) IBOutlet UIButton *btn_invSma;
@property (weak, nonatomic) IBOutlet UIButton *btn_invOtherapp;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Notificationcount;

@property (strong, nonatomic) SideBarViewController *sideMenu;

@property BOOL isContact;
@property CGFloat sliderY;
@property NSMutableArray *arrContacts;
@property (strong, nonatomic) NSString *appMsg;

@end

@implementation InviteFriendViewController
@synthesize isContact,vwSlider,btnCntacts,btnWeb,vwWebInvite,vwContactInvite,tblvContacts,sliderY,arrContacts,sideMenu,appMsg,vwAd,btn_invFacebook,btn_invTwitter,btn_invWhatsapp,btn_invEmail,btn_invSma,btn_invOtherapp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    btn_invFacebook.layer.cornerRadius = 5;
    btn_invFacebook.layer.masksToBounds = YES;
    btn_invTwitter.layer.cornerRadius = 5;
    btn_invTwitter.layer.masksToBounds = YES;
    btn_invWhatsapp.layer.cornerRadius = 5;
    btn_invWhatsapp.layer.masksToBounds = YES;
    btn_invEmail.layer.cornerRadius = 5;
    btn_invEmail.layer.masksToBounds = YES;
    btn_invSma.layer.cornerRadius = 5;
    btn_invSma.layer.masksToBounds = YES;
    btn_invOtherapp.layer.cornerRadius = 5;
    btn_invOtherapp.layer.masksToBounds = YES;
    
    sliderY = vwSlider.y;
    isContact = YES;
    vwContactInvite.hidden = NO;
    vwWebInvite.hidden = YES;
    arrContacts = [[NSMutableArray alloc]init];
    appMsg = [NSString stringWithFormat:@"Hey check out my app at :%@",AppURL];
    //[_btnBalance setTitle:[NSString stringWithFormat:@"%@",WinkGlobalObject.user.cashOutBalance] forState:UIControlStateNormal];
    
    _lbl_Notificationcount.layer.cornerRadius= 5;
    _lbl_Notificationcount.hidden=YES;
    if ([WinkGlobalObject.sideMenuNotification[@"notificationsCount"] intValue]> 0)
    {
        _lbl_Notificationcount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"notificationsCount"]];
        _lbl_Notificationcount.hidden=NO;
    }
    

    
    [self getContacts];
    
    if(WinkGlobalObject.user.isAdmob)
    {
        [vwAd addSubview:[self setUpAdvertisement]];
    }
    else
    {
        tblvContacts.height = tblvContacts.height + vwAd.height;
        vwAd.hidden = YES;
    }
    // Do any additional setup after loading the view.
}
- (IBAction)btnBalanceTap:(id)sender
{
    CashOutViewController *cvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"CashOutViewController"];
    [self presentViewController:cvc animated:YES completion:nil];
}

-(void)getContacts
{
    [SVProgressHUD show];
    CNContactStore *store = [[CNContactStore alloc] init];
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
        if (granted == YES)
        {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error)
            {
                NSLog(@"error fetching contacts %@", error);
            } else
            {
                for (CNContact *contact in cnContacts)
                {
                    NSString *phoneNumber = @"";
                    
                    for (CNLabeledValue *label in contact.phoneNumbers)
                    {
                        NSString *phone = [label.value stringValue];
                        if ([phone length] > 0)
                        {
                            phoneNumber = phone;
                            break;
                        }
                    }
                    NSDictionary *dict = @{
                                           @"firstname" :contact.givenName,
                                           @"lastname" :contact.familyName,
                                           @"imagedata" :contact.imageData!= nil?contact.imageData:@"",
                                           @"number" : phoneNumber
                                           };
                    [arrContacts addObject:dict];
                    [tblvContacts reloadData];
                    [SVProgressHUD dismiss];
                }
            }
        }        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)btnInviteTap:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:tblvContacts];
    NSIndexPath *indexPath = [tblvContacts indexPathForRowAtPoint:buttonPosition];
    NSDictionary  *contact = arrContacts[indexPath.row];
    //NSURL(string: "sms:\(phoneNumber)&body=\(text)")
    NSURL *messageURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@&body=%@",contact[@"number"],AppURL]];
    if([[UIApplication sharedApplication]canOpenURL:messageURL])
    {
        [[UIApplication sharedApplication]openURL:messageURL];
    }
}

- (IBAction)btnContactTap:(UIButton *)btn
{
    [tblvContacts setContentOffset:tblvContacts.contentOffset animated:NO];
    
    if(!isContact)
    {
        isContact = YES;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             vwSlider.center = CGPointMake(btn.center.x,vwSlider.y);
             vwSlider.y = sliderY;
             vwContactInvite.hidden = NO;
             vwWebInvite.hidden = YES;
             
         }];
        
    }
}

- (IBAction)btnWebTap:(UIButton *)btn
{
    [tblvContacts setContentOffset:tblvContacts.contentOffset animated:NO];
    
    if(isContact)
    {
        isContact = NO;
        
        [UIView animateWithDuration:0.5 animations:^
         {
             vwSlider.center = CGPointMake(btn.center.x,vwSlider.y);
             vwSlider.y = sliderY;
             vwContactInvite.hidden = YES;
             vwWebInvite.hidden = NO;
         }];
        
    }

}
- (IBAction)inviteFBTap:(id)sender
{
    [self SendPoints];
    /*FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];*/
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:appMsg];
        [controller addURL:[NSURL URLWithString:AppURL]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
}
- (IBAction)inviteTwitterTap:(id)sender
{
    [self SendPoints];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:appMsg];
        [tweetSheet addURL:[NSURL URLWithString:AppURL]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}
- (IBAction)inviteEmailTap:(id)sender
{
    [self SendPoints];
    NSString * googleUrlString = [NSString stringWithFormat:@"googlegmail:///co?subject=Hello&body=hello"];
    ;
    NSURL *googleURL = [NSURL URLWithString:googleUrlString];
    
    if([[UIApplication sharedApplication]canOpenURL:googleURL])
    {
        // show alert to choose app
        [[UIApplication sharedApplication]openURL:googleURL];
    }
    
}
- (IBAction)inviteSMSTap:(id)sender
{
    [self SendPoints];
    NSURL *messageURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@&body=%@",@"",AppURL]];
    if([[UIApplication sharedApplication]canOpenURL:messageURL])
    {
        [[UIApplication sharedApplication]openURL:messageURL];
    }
}
- (IBAction)inviteWhatsappTap:(id)sender
{
    //NSString *theTempMessage = @"https://www.youtube.com/user/kidstvabcd";
    
    [self SendPoints];
    NSString * theTempMessage = [NSString stringWithFormat:@"%@\n%@",appMsg,AppURL];
    
    theTempMessage =    (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) theTempMessage, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",theTempMessage];
    NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        // can not share with whats app
    }
    
}

- (IBAction)inviteOtherTap:(id)sender
{
    [self SendPoints];
    NSArray *activityItems = [NSArray arrayWithObjects:appMsg, nil, AppURL, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UITableviewDelegate & UITableviewDataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrContacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    NSDictionary *dict = arrContacts[indexPath.row];
    
    [cell setContactData:dict];
    
    return cell;
}

#pragma mark - FBSDKInvite dialog delegate
-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}
-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    
}

- (IBAction)btn_notification:(id)sender
{
    NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
    //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];
}

-(void)SendPoints
{
    NSDictionary *userDict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
    
    
    [WinkWebServiceAPI sendPoints:userDict completionHandler:^(WinkAPIResponse *response, WinkUser *user)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             
         }
         else if (response.code == 1)
         {
            
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
@end
