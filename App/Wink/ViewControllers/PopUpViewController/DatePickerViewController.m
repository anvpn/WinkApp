//
//  DatePickerViewController.m
//  Wink
//
//  Created by Apple on 20/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *calender;

@end

@implementation DatePickerViewController
@synthesize calender;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [calender setMaximumDate:maxDate];
    calender.date = maxDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnOkTap:(id)sender
{
    [self.delegate selectedDate:calender.date];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
