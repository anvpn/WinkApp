//
//  TermsNConditionViewController.m
//  Wink
//
//  Created by Apple on 11/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "TermsNConditionViewController.h"

@interface TermsNConditionViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsNConditionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
