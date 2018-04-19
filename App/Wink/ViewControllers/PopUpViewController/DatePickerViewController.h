//
//  DatePickerViewController.h
//  Wink
//
//  Created by Apple on 20/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@protocol  DatePickerViewControllerDelegate<NSObject>

-(void)selectedDate:(NSDate *)selectedDate;

@end

@interface DatePickerViewController : WinkViewController

@property id <DatePickerViewControllerDelegate> delegate;

@end
