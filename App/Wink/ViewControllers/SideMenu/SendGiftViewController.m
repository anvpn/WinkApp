//
//  SendGiftViewController.m
//  Wink
//
//  Created by Apple on 14/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "SendGiftViewController.h"

@interface SendGiftViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UITextView *txtvComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgvGift;

@end

@implementation SendGiftViewController
@synthesize lblHeader,txtvComment,selectedDict,selectedProfileId,imgvGift;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    [txtvComment becomeFirstResponder];
    NSURL *url = [NSURL URLWithString:selectedDict[@"imgUrl"]];
    NSString *lastComponent;
    NSURL *giftURL;
    
    if([url isKindOfClass:[NSURL class]])
    {
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            giftURL = [WinkWebservice URLForGiftImage:lastComponent];
        }
        
    }
    [imgvGift setImageWithURL:giftURL placeholderImage:[UIImage imageNamed:@"Wink.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSendNowTap:(id)sender
{
    //if(txtvComment.text.length > 0)
    //{
        if([WinkUtil reachable])
        {
            [self sendGift];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    //}
}
-(void)sendGift
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"giftAnonymous" : @"0",
                           @"message" : txtvComment.text,
                           @"giftId" : selectedDict[@"id"],
                           @"giftTo" : selectedProfileId
                           };
    [WinkWebServiceAPI sendGift:dict completionHandler:^(WinkAPIResponse *response,int balance)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self showAlertWithMessage:@"Gift send successfully" andHandler:^(UIAlertAction * _Nullable action)
            {
                WinkGlobalObject.user.balance = balance;
                [WinkGlobalObject.user saveInUserDefaults];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }
        else if(response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:response.error.localizedDescription];
        }
    }];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8)
    {
         lblHeader.text = [NSString stringWithFormat:@"%lu",((140-textView.text.length)+1)];
        return YES;
    }
    
    if(text.length > 0)
    {
        lblHeader.text = [NSString stringWithFormat:@"%lu",(140 -textView.text.length-1)];
    }
    if (textView.text.length == 0)
    {
        lblHeader.text = @"Send Gift";
    }
    if(textView.text.length >= 140)
    {
        return NO;
    }
    return YES;
}

@end
