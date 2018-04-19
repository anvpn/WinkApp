//
//  SettingOptionViewController.h
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@protocol SettingOptionViewControllerDelegate <NSObject>

-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label;

@end

@interface SettingOptionViewController : WinkViewController

@property (strong, nonatomic)NSString *titleLable;
@property (strong, nonatomic)NSArray *arrOptions;
@property (strong, nonatomic) NSString *buttonLabel;

@property int selectedIndex;
@property id<SettingOptionViewControllerDelegate> delegate;

@end
