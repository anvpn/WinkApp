//
//  FameViewController.m
//  Wink
//
//  Created by Manish on 7/22/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "FameViewController.h"

@interface FameViewController ()<ZWTTextboxToolbarHandlerDelegate>
//Button
@property (weak, nonatomic) IBOutlet UIButton *btn_chatter;
@property (weak, nonatomic) IBOutlet UIButton *btn_receiver;
@property (weak, nonatomic) IBOutlet UIButton *btn_giver;
//Label
@property (weak, nonatomic) IBOutlet UILabel *lbl_Chatter;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Receiver;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Giver;
//Text filed
@property (weak, nonatomic) IBOutlet HoshiTextField *txt_amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ChatterBid;
@property (weak, nonatomic) IBOutlet UILabel *lblReceiverBid;
@property (weak, nonatomic) IBOutlet UILabel *lblGiverBid;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;

@property (strong, nonatomic) NSArray *arrDetail;
@property (strong, nonatomic) ZWTTextboxToolbarHandler *handler;

@property int MaxBid;


@end

@implementation FameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    
    _btn_chatter.layer.cornerRadius = _btn_chatter.width /2;
    _btn_chatter.clipsToBounds = YES;
    _btn_chatter.layer.borderColor = [UIColor lightTextColor].CGColor;
    _btn_chatter.layer.borderWidth = 3.0;
    
    _btn_receiver.layer.cornerRadius = _btn_receiver.width /2;
    _btn_receiver.clipsToBounds = YES;
    _btn_receiver.layer.borderColor = [UIColor lightTextColor].CGColor;
    _btn_receiver.layer.borderWidth = 3.0;
    
    
    _btn_giver.layer.cornerRadius = _btn_giver.width /2;
    _btn_giver.clipsToBounds = YES;
    _btn_giver.layer.borderColor = [UIColor lightTextColor].CGColor;
    _btn_giver.layer.borderWidth = 3.0;
    _MaxBid = 0;
    _handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[_txt_amount] andScroll:_scrlvBG];
    _handler.showNextPrevious = NO;
    _handler.delegate = self;
    
    [self GetFameData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//Back Button
- (IBAction)btn_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//Place Bid Button
- (IBAction)btn_placebid:(id)sender
{
    int Value = [_txt_amount.text intValue];
    
    if (Value >= 10 )
    {
        if(Value <= WinkGlobalObject.user.balance)
        {
            if(Value > _MaxBid)
            {
                [self SendAmount];
            }
            else
            {
                [self showAlertWithMessage:[NSString stringWithFormat:@"Maximum bid is : %d",_MaxBid]];
            }
        }
        else
        {
            [self showAlertWithMessage:@"Not enough credits"];
        }
    }
    else
    {
        [self showAlertWithMessage:@"Enter Mimimum 10 credit for bid."];
    }
    [_txt_amount resignFirstResponder];
}
-(void)GetFameData
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        [WinkWebServiceAPI getFame:dict completionHandler:^(WinkAPIResponse *response, NSArray *arrPeople)
         {
             [SVProgressHUD dismiss];
             if(arrPeople.count > 0)
             {
                 _arrDetail = arrPeople;
                 [self displayDetails];
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
    else
    {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)displayDetails
{
    if (_arrDetail.count > 0)
    {
        NSMutableDictionary *dict1 = [_arrDetail objectAtIndex:0];
        if (dict1.count > 0)
        {
            NSURL *url = [NSURL URLWithString:dict1[@"normalPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            [_btn_chatter setImageForState:UIControlStateNormal withURL:photourl];
            //_lbl_Chatter.text = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"fullname"]];
            _lbl_ChatterBid.text = [NSString stringWithFormat:@"%@ Bid",dict1[@"bidAmount"]];
             _MaxBid = [dict1[@"bidAmount"]intValue];
           
            BOOL Online = [dict1[@"online"]boolValue];
            if (Online)
            {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"fullname"]];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lbl_Chatter.attributedText  = myString;
            }
            else
            {
                _lbl_Chatter.text = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"fullname"]];
            }
        }
    }
    if(_arrDetail.count > 1)
    {
        NSMutableDictionary *dict2 = [_arrDetail objectAtIndex:1];
        if (dict2.count > 0)
        {
            NSURL *url = [NSURL URLWithString:dict2[@"normalPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            [_btn_receiver setImageForState:UIControlStateNormal withURL:photourl];
            //_lbl_Receiver.text = [NSString stringWithFormat:@"%@",[dict2 valueForKey:@"fullname"]];
            _lblReceiverBid.text = [NSString stringWithFormat:@"%@ Bid",dict2[@"bidAmount"]];
            BOOL Online = [dict2[@"online"]boolValue];
            if (Online)
            {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = [NSString stringWithFormat:@"%@",[dict2 valueForKey:@"fullname"]];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lbl_Receiver.attributedText  = myString;
            }
            else
            {
                _lbl_Receiver.text = [NSString stringWithFormat:@"%@",[dict2 valueForKey:@"fullname"]];
            }
            
        }
    }
    
    if(_arrDetail.count > 2)
    {
        NSMutableDictionary *dict3 = [_arrDetail objectAtIndex:2];
        if (dict3.count > 0)
        {
            NSURL *url = [NSURL URLWithString:dict3[@"normalPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            [_btn_giver setImageForState:UIControlStateNormal withURL:photourl];
            //_lbl_Giver.text = [NSString stringWithFormat:@"%@",[dict3 valueForKey:@"fullname"]];
            _lblGiverBid.text = [NSString stringWithFormat:@"%@ Bid",dict3[@"bidAmount"]];
            BOOL Online = [dict3[@"online"]boolValue];
            if (Online)
            {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = [NSString stringWithFormat:@"%@",[dict3 valueForKey:@"fullname"]];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lbl_Giver.attributedText  = myString;
            }
            else
            {
                _lbl_Giver.text = [NSString stringWithFormat:@"%@",[dict3 valueForKey:@"fullname"]];
            }
        }
    }
}
-(void)SendAmount
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"bidAmount" : _txt_amount.text
                               };
        [WinkWebServiceAPI SendAmount:dict completionHandler:^(WinkAPIResponse *response,WinkComment *comment)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.user.balance -= [_txt_amount.text intValue];
                 [WinkGlobalObject.user saveInUserDefaults];
                 
                 [self showAlertWithMessage:@"Bid placed successfuly"];
                 _txt_amount.text = @"";
                 [_txt_amount resignFirstResponder];
                  [self GetFameData];
             }
             else
             {
                 [self showAlertWithMessage:response.message];
             }
         }];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:WinkNoInternet];
    }
}
//bidAmount
@end
