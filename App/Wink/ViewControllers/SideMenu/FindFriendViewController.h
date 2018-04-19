//
//  FindFriendViewController.h
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface FindFriendViewController : WinkViewController
{
    
}
//Button
@property (weak, nonatomic) IBOutlet UIButton *btn_search;
- (IBAction)btn_search:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNearBy;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;

@end
