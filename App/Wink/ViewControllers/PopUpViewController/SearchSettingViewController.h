//
//  SearchSettingViewController.h
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@protocol SearchSettingViewControllerDelegate <NSObject>

-(void)selectedData:(NSDictionary *)dict;

@end

@interface SearchSettingViewController : WinkViewController

@property int AgeFrom;
@property int AgeTo;
@property int gender;
@property int online;

@property id<SearchSettingViewControllerDelegate> delegate;

@end
