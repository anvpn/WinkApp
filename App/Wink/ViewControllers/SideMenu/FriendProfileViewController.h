//
//  FriendProfileViewController.h
//  Wink
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"
#import "WinkUser.h"

@interface FriendProfileViewController : WinkViewController

@property int profileId;
@property (strong,nonatomic) NSDictionary * dictFriend;
@property (strong,nonatomic) WinkUser * winkUser;



@end
