//
//  SideBarViewController.h
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface SideBarViewController : WinkViewController

- (void)showMenu;
- (void)hideMenu;

@property (weak, nonatomic) IBOutlet UIView *View_tuch;


@end
