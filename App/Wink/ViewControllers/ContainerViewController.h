//
//  ContainerViewController.h
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface ContainerViewController : WinkViewController

@property (weak, nonatomic) IBOutlet UIView *vwcontainer;
@property (strong, nonatomic) UIViewController *childVc;

- (void) displayContentController: (UIViewController*) content;

@end
