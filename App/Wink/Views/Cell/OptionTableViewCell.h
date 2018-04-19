//
//  OptionTableViewCell.h
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOption;
@property (weak, nonatomic) IBOutlet UIImageView *imgvRadio;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
