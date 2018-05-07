//
//  SideBarViewController.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "SideBarViewController.h"

@interface SideBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;
@property (weak, nonatomic) IBOutlet UIView *vwProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgvBg;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIView *vwMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblvMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationCount;
@property (weak, nonatomic) IBOutlet UIView *vwSideMenu;
@property (strong, nonatomic) NSArray *arrMenuName;
@property (strong, nonatomic) NSArray *arrMenuIcon;

@end

@implementation SideBarViewController
@synthesize scrlvBG,vwProfile,imgvBg,lblName,lblStatus,btnProfile,vwMenu,tblvMenu,arrMenuName,arrMenuIcon,vwSideMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WinkUtil authorizeUser];
    arrMenuIcon = @[];
    
    //arrMenuName = @[@"Profile",@"My Gallery",@"Friends",@"Messages",@"Notifications",@"Profile Guests",@"Profile Likes",@"I Liked",@"Upgrades",@"People Nearby",@"People of the Day",@"Wink Stream",@"Find a Friend",@"Invite Friend",@"Logout",@"Settings"];
    arrMenuName = @[@"Media feed",@"Messages",@"Find friend",@"Profile guest",@"People of the Day",@"Wink store",@"Invite friend",@"Settings",@"Logout"];
    
    [tblvMenu reloadData];

    self.View_tuch.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.View_tuch addGestureRecognizer:singleFingerTap];

}

-(void)viewWillAppear:(BOOL)animated
{
    btnProfile.layer.cornerRadius = btnProfile.width / 2;
    btnProfile.clipsToBounds = YES;
    
    [self prepareView];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self hideMenu];
    //Do stuff here...
}
-(void)prepareView
{
//    tblvMenu.height = tblvMenu.contentSize.height;
//    vwMenu.height   = tblvMenu.height;
    //
    
//    WinkUser *userDemo = [[WinkUser alloc]init];
//    userDemo = WinkGlobalObject.user;
    
    
    lblStatus.text = [NSString stringWithFormat:@"@%@",WinkGlobalObject.user.userName];
    
    if (WinkGlobalObject.user.verify)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        //NSString *Name = WinkGlobalObject.user.name;
        NSString *Name = [NSString stringWithFormat:@"%@ ",WinkGlobalObject.user.name];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblName.attributedText  = myString;
    }
    else
    {
        lblName.text  = WinkGlobalObject.user.name;
    }
    //lblStatus.text = WinkGlobalObject.user.userName;
    //[imgvBg setImageWithURL:WinkGlobalObject.user.originCoverURL];
    [imgvBg setImageWithURL:WinkGlobalObject.user.originCoverURL placeholderImage:[UIImage imageNamed:@"profile_bg.png"]];
    [btnProfile setImageForState:UIControlStateNormal withURL:WinkGlobalObject.user.lowSizeProfURL];
    btnProfile.layer.cornerRadius = btnProfile.width / 2;
    btnProfile.clipsToBounds = YES;
    btnProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    btnProfile.layer.borderWidth = 3.0;
//    [scrlvBG setContentSize:CGSizeMake(scrlvBG.width,vwMenu.y + vwMenu.height+10)];
}
#pragma mark - Side Menu Methods
- (void)showMenu
{
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
    
    [self.view.superview bringSubviewToFront:self.view];
    
    //viewBackCover.hidden = NO;
    
    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:0 animations:^
     {
         vwSideMenu.x = 0;
         
         self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
     }
                     completion:^(BOOL finished)
     {
        // viewBackCover.hidden = YES;
         
         //[self loadProfileImage];
     }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.view.backgroundColor = [UIColor clearColor];
         
         vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
     }
                     completion:^(BOOL finished)
     {
         self.view.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
     }];
}
- (IBAction)btnHideMenuTap:(id)sender
{
    [self hideMenu];
}

#pragma mark - UITableview Delegate & Datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenuName.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    cell.lblMenu.text = arrMenuName[indexPath.row];
    cell.imgvIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrMenuName[indexPath.row]]];
    
    if(WinkGlobalObject.sideMenuNotification.count > 0)
    {
        if (indexPath.row == 1 && ([WinkGlobalObject.sideMenuNotification[@"messagesCount"]intValue ] > 0)) //message Menu
        {
            cell.lblCount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"messagesCount"]];
        }
        else if (indexPath.row == 3 && ([WinkGlobalObject.sideMenuNotification[@"guestsCount"] intValue] > 0)) //profile Guests Menu
        {
             cell.lblCount.text = [NSString stringWithFormat:@"%@",WinkGlobalObject.sideMenuNotification[@"guestsCount"]];
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideMenu];
    //UIViewController *vc = [[WinkGlobalObject.rootNavigationController viewControllers] firstObject];
    
    if(indexPath.row == 0) // profile menu // Media feed
    {
        WinkStreamViewController *wvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"WinkStreamViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:wvc animated:NO];
        
        //ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        //pvc.isMenu = YES;
        
        //[WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
        //[WinkGlobalObject.rootNavigationController setViewControllers:@[WinkGlobalObject.containerViewController] animated:NO];
        
    }
    else if (indexPath.row == 1) // My Gallary Menu //Message
    {
        MessageViewController *mvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [WinkGlobalObject.rootNavigationController pushViewController:mvc animated:NO];
       //MyGallaryViewController *gvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"MyGallaryViewController"];
        //gvc.profileId = WinkGlobalObject.user.ID;
        //gvc.isMenu = YES;
        //[WinkGlobalObject.rootNavigationController pushViewController:gvc animated:NO];

    }
    else if (indexPath.row == 2) // Friends Menu  //New Find Friend
    {
        FindFriendViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FindFriendViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:fvc animated:NO];
        
        //FriendsViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendsViewController"];
        //fvc.isMenu = YES;
        //fvc.profileId = WinkGlobalObject.user.ID;
        //[WinkGlobalObject.rootNavigationController pushViewController:fvc animated:NO];
    }
    else if (indexPath.row == 3) //Messages Menu //Profile Guest
    {
        ProfileGuestViewController *pgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileGuestViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:pgvc animated:NO];
        //MessageViewController *mvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"MessageViewController"];
        //[WinkGlobalObject.rootNavigationController pushViewController:mvc animated:NO];
    }
    else if (indexPath.row == 4) //Notifications Menu //New People of the day
    {
        PeopleOfTheDayViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"PeopleOfTheDayViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
        
        //NotificationListViewController *nvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
        //[WinkGlobalObject.rootNavigationController pushViewController:nvc animated:NO];

    }
    else if (indexPath.row == 5)//profile Guests Menu //New Wink Store.
    {
        UpgradesViewController * uvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"UpgradesViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:uvc animated:NO];
        //ProfileGuestViewController *pgvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileGuestViewController"];
       
        //[WinkGlobalObject.rootNavigationController pushViewController:pgvc animated:NO];
    }
    else if (indexPath.row == 6) //Profile Likes Menu  //New Invite Friends
    {
        InviteFriendViewController *ivc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"InviteFriendViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:ivc animated:NO];
        
        //ProfileLikesViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileLikesViewController"];
        //pvc.isMenu = YES;
        //pvc.profileId = WinkGlobalObject.user.ID;
        //[WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
    }
    else if (indexPath.row == 7) // I Liked Menu  // New Setting
    {
        AppSettingViewController *asvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"AppSettingViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:asvc animated:NO];
        //ILikedViewController *ivc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ILikedViewController"];
        
        //[WinkGlobalObject.rootNavigationController pushViewController:ivc animated:NO];
    }
    else if (indexPath.row == 8) // Upgrades Menu   //New Logout
    {
        [WinkUtil logoutUser];
        //UpgradesViewController * uvc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"UpgradesViewController"];
        
        //[WinkGlobalObject.rootNavigationController pushViewController:uvc animated:NO];
    }
    else if (indexPath.row == 9) // People Nearby Menu
    {
        PeopleNearbyViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"PeopleNearbyViewController"];
        [WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
    }
    else if (indexPath.row == 10) // People Of the Day
    {
        PeopleOfTheDayViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"PeopleOfTheDayViewController"];
       
        [WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
    }
    else if (indexPath.row == 11) // Wink Stream Menu
    {
        WinkStreamViewController *wvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"WinkStreamViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:wvc animated:NO];
        
    }
    else if (indexPath.row == 12) // Find a Friend Menu
    {
        FindFriendViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FindFriendViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:fvc animated:NO];
    }
    else if (indexPath.row == 13) // Invite Friend Menu
    {
        InviteFriendViewController *ivc = [WinkGlobalObject.storyboardMain instantiateViewControllerWithIdentifier:@"InviteFriendViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:ivc animated:NO];
    }
    else if (indexPath.row == 14) // logout Menu
    {
        [WinkUtil logoutUser];
    }
    else if (indexPath.row == 15)  // Settings Menu
    {
        AppSettingViewController *asvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"AppSettingViewController"];
        
        [WinkGlobalObject.rootNavigationController pushViewController:asvc animated:NO];
    }
   /* else if (indexPath.row == 16) // Settings Menu
    {
        
    }*/
}

- (IBAction)btn_viewProfile:(id)sender
{
    ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    pvc.isMenu = YES;
    pvc.winkSelectedUser = WinkGlobalObject.user;
//    pvc.accessibilityElementCount
    [WinkGlobalObject.rootNavigationController pushViewController:pvc animated:NO];
}
@end
