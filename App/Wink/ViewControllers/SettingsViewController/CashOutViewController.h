//
//  CashOutViewController.h
//  Wink
//
//  Created by Apple on 31/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface CashOutViewController : WinkViewController
{
    
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *lbl_balance;

@property (weak, nonatomic) IBOutlet UILabel *lbl_startBal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_startEnd;


@end
