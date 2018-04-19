//
//  ProfileViewController.h
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface ProfileViewController : WinkViewController

@property BOOL isMenu;

@property (weak, nonatomic) IBOutlet UIView *view_Activity;
@property (weak, nonatomic) IBOutlet UIView *view_Information;
@property (weak, nonatomic) WinkUser *winkSelectedUser;



@end
