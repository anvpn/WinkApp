//
//  SearchSettingViewController.m
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "SearchSettingViewController.h"

@interface SearchSettingViewController ()<BSDropDownDelegate>

@property (strong, nonatomic) SideBarViewController *sideMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnAgeFrom;
@property (weak, nonatomic) IBOutlet UIButton *btnAgeTo;
@property (weak, nonatomic) IBOutlet UIImageView *imgvMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgvFemale;
@property (weak, nonatomic) IBOutlet UIImageView *imgvOnline;

@property BOOL isAgeFrom;
@property NSArray *arrAgeFrom;
@property NSArray *arrAgeTo;
@property BSDropDown *ddView;

@property BOOL isMale;
@property BOOL isFemale;
@property BOOL isOnline;

//User 1
@property (weak, nonatomic) IBOutlet UIButton *btnGiver;
@property (weak, nonatomic) IBOutlet UILabel *lblGiverName;
@property (weak, nonatomic) IBOutlet UIButton *btnReceiver;
@property (weak, nonatomic) IBOutlet UILabel *lblReceiverName;
@property (weak, nonatomic) IBOutlet UIButton *btnChatter;
@property (weak, nonatomic) IBOutlet UILabel *lblChatterName;
@property (weak, nonatomic) IBOutlet UILabel *lblBoujeeName;
@property (weak, nonatomic) IBOutlet UIButton *btnBoujee;
@property (weak, nonatomic) IBOutlet UILabel *lblFireName;
@property (weak, nonatomic) IBOutlet UIButton *btnFire;
@property (weak, nonatomic) IBOutlet UILabel *lblFameName;
@property (weak, nonatomic) IBOutlet UIButton *btnFame;


@property (strong, nonatomic) NSArray *arrDetail;

@end

@implementation SearchSettingViewController

@synthesize btnMale,btnFemale,btnOnline,btnAgeFrom,btnAgeTo,isAgeFrom,arrAgeFrom,arrAgeTo,ddView,isMale,isFemale,isOnline,btnGiver,lblGiverName,btnReceiver,lblReceiverName,btnChatter,lblBoujeeName,btnBoujee,lblFireName,btnFire,lblFameName,btnFame,sideMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrAgeTo =@[@"20",@"27",@"27",@"38",@"43",@"50",@"70",@"Not Matter"];
    arrAgeFrom = @[@"13",@"18",@"25",@"30",@"35",@"40",@"45"];
    if(_gender == 0)
    {
        [_imgvMale setImage:[UIImage imageNamed:@"checked.png"]];
        [_imgvFemale setImage:[UIImage imageNamed:@"checkbox.png"]];
        isMale = 1;isFemale = 0;
    }
    else if (_gender == 1)
    {
        [_imgvFemale setImage:[UIImage imageNamed:@"checked.png"]];
        [_imgvMale setImage:[UIImage imageNamed:@"checkbox.png"]];
        isMale = 0;isFemale = 1;
    }
    else
    {
        [_imgvFemale setImage:[UIImage imageNamed:@"checked.png"]];
        [_imgvMale setImage:[UIImage imageNamed:@"checked.png"]];
        isMale = 1;isFemale = 1;
    }
    if(_online == 1)
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
    [btnAgeFrom setTitle:[NSString stringWithFormat:@"%d",_AgeFrom] forState:UIControlStateNormal];
    if(_AgeTo > 100)
    {
        [btnAgeTo setTitle:[NSString stringWithFormat:@"Not Matter"] forState:UIControlStateNormal];
    }
    else
    {
        [btnAgeTo setTitle:[NSString stringWithFormat:@"%d",_AgeTo] forState:UIControlStateNormal];
    }
    [self prepareView];
    [self getPeopleOftheDay];
}
-(void)prepareView
{
    btnChatter.layer.cornerRadius = btnChatter.width /2;
    btnChatter.clipsToBounds = YES;
    btnChatter.layer.borderColor = [UIColor whiteColor].CGColor;
    btnChatter.layer.borderWidth = 2.0;
    
    btnFame.layer.cornerRadius = btnFame.width /2;
    btnFame.clipsToBounds = YES;
    btnFame.layer.borderColor = [UIColor whiteColor].CGColor;
    btnFame.layer.borderWidth = 2.0;
    
    
    btnBoujee.layer.cornerRadius = btnBoujee.width /2;
    btnBoujee.clipsToBounds = YES;
    btnBoujee.layer.borderColor = [UIColor whiteColor].CGColor;
    btnBoujee.layer.borderWidth = 2.0;
    
    btnFire.layer.cornerRadius = btnFire.width /2;
    btnFire.clipsToBounds = YES;
    btnFire.layer.borderColor = [UIColor whiteColor].CGColor;
    btnFire.layer.borderWidth = 2.0;
    
    btnGiver.layer.cornerRadius = btnGiver.width /2;
    btnGiver.clipsToBounds = YES;
    btnGiver.layer.borderColor = [UIColor whiteColor].CGColor;
    btnGiver.layer.borderWidth = 2.0;
    
    btnReceiver.layer.cornerRadius = btnReceiver.width /2;
    btnReceiver.clipsToBounds = YES;
    btnReceiver.layer.borderColor = [UIColor whiteColor].CGColor;
    btnReceiver.layer.borderWidth = 2.0;
    
}
-(void)getPeopleOftheDay
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID
                               };
        [WinkWebServiceAPI getPeopleOfTheDay:dict completionHandler:^(WinkAPIResponse *response, NSArray *arrPeople)
         {
             [SVProgressHUD dismiss];
             if(arrPeople.count > 0)
             {
                 _arrDetail = arrPeople;
                 [self displayDetails];
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
    NSDictionary *dict = (NSDictionary *)_arrDetail[0];
    
    NSDictionary *chatter = dict[@"chatter"];
    NSDictionary *boujee = (NSDictionary *)dict[@"boujee"];
    NSDictionary *giver = dict[@"giftTo"];
    NSDictionary *receiver = dict[@"giftFrom"];
    NSDictionary *fame = dict[@"fameUserData"];
    NSDictionary *fire = dict[@"fireUserData"];
    
    if([chatter isKindOfClass:[NSDictionary class]])
    {
        if(chatter.count > 0)
        {
            NSURL *url = [NSURL URLWithString:chatter[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([chatter[@"online"]boolValue])
            {
                _lblChatterName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = chatter[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                _lblChatterName.attributedText  = myString;
            }
            else
            {
                _lblChatterName.text = chatter[UKeyName];
                _lblChatterName.textColor = [UIColor darkGrayColor];
            }
            [btnChatter setImageForState:UIControlStateNormal withURL:photourl];
            //_lblChatterName.text = chatter[UKeyName];
            btnChatter.tag = [chatter[@"user_id"]integerValue];
        }
    }
    else
    {
        btnChatter.enabled = false;
    }
    if([boujee isKindOfClass:[NSDictionary class]])
    {
        if(boujee.count > 0)
        {
            NSURL *url = [NSURL URLWithString:boujee[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([boujee[@"online"]boolValue])
            {
                lblBoujeeName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = boujee[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblBoujeeName.attributedText  = myString;
            }
            else
            {
                lblBoujeeName.text = boujee[UKeyName];
                lblBoujeeName.textColor = [UIColor darkGrayColor];
            }
            [btnBoujee setImageForState:UIControlStateNormal withURL:photourl];
            //lblBoujeeName.text = boujee[UKeyName];
            btnBoujee.tag = [boujee[@"user_id"]integerValue];
        }
    }
    else
    {
        btnBoujee.enabled = false;
    }
    if([giver isKindOfClass:[NSDictionary class]])
    {
        if(giver.count > 0)
        {
            NSURL *url = [NSURL URLWithString:giver[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([giver[@"online"]boolValue])
            {
                lblGiverName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = giver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblGiverName.attributedText  = myString;
            }
            else
            {
                lblGiverName.text = giver[UKeyName];
                lblGiverName.textColor = [UIColor darkGrayColor];
            }
            [btnGiver setImageForState:UIControlStateNormal withURL:photourl];
            //lblGiverName.text = giver[UKeyName];
            btnGiver.tag = [giver[@"user_id"]integerValue];
        }
    }
    else
    {
        btnGiver.enabled = false;
    }
    if([receiver isKindOfClass:[NSDictionary class]])
    {
        if(receiver.count > 0)
        {
            NSURL *url = [NSURL URLWithString:receiver[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([receiver[@"online"]boolValue])
            {
                lblReceiverName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = receiver[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblReceiverName.attributedText  = myString;
            }
            else
            {
                lblReceiverName.text = receiver[UKeyName];
                lblReceiverName.textColor = [UIColor darkGrayColor];
            }
            [btnReceiver setImageForState:UIControlStateNormal withURL:photourl];
            //lblReceiverName.text = receiver[UKeyName];
            btnReceiver.tag = [receiver[@"user_id"]integerValue];
        }
    }
    else
    {
        btnReceiver.enabled = false;
    }
    if([fame isKindOfClass:[NSDictionary class]])
    {
        if(fame.count > 0)
        {
            NSURL *url = [NSURL URLWithString:fame[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([fame[@"online"]boolValue])
            {
                lblFameName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fame[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblFameName.attributedText  = myString;
            }
            else
            {
                lblFameName.text = fame[UKeyName];
                lblFameName.textColor = [UIColor darkGrayColor];
            }
            [btnFame setImageForState:UIControlStateNormal withURL:photourl];
            //lblFameName.text = fame[UKeyName];
            btnFame.tag = [fame[@"user_id"]integerValue];
        }
    }
    else
    {
        btnFame.enabled = false;
    }
    if([fire isKindOfClass:[NSDictionary class]])
    {
        if(fire.count > 0)
        {
            NSURL *url = [NSURL URLWithString:fire[@"originPhotoUrl"]];
            NSString *lastComponent;
            NSURL *photourl;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                photourl = [WinkWebservice URLForProfileImage:lastComponent];
            }
            if([fire[@"online"]boolValue])
            {
                lblFireName.textColor = [UIColor darkGrayColor];
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:@"ic_online.png"];
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                NSString *Name = fire[UKeyName];
                NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
                [myString appendAttributedString:attachmentString];
                lblFireName.attributedText  = myString;
            }
            else
            {
                lblFireName.text = fire[UKeyName];
                lblFireName.textColor = [UIColor darkGrayColor];
            }
            [btnFire setImageForState:UIControlStateNormal withURL:photourl];
            //lblFireName.text = fire[UKeyName];
            btnFire.tag = [fire[@"user_id"]integerValue];
        }
    }
    else
    {
        btnFire.enabled = false;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnMaleTap:(id)sender
{
    if(isMale)
    {
        [_imgvMale setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
    else
    {
        [_imgvMale setImage:[UIImage imageNamed:@"checked.png"]];
    }
    isMale = !isMale;
}
- (IBAction)btnFemaleTap:(id)sender
{
    if(isFemale)
    {
        [_imgvFemale setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
    else
    {
        [_imgvFemale setImage:[UIImage imageNamed:@"checked.png"]];
    }
    isFemale = !isFemale;
}

- (IBAction)btnOnlineTap:(id)sender
{
    if(isOnline)
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"checkbox.png"]];
        _online = -1;
    }
    else
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"checked.png"]];
        _online = 1;
        
    }
    isOnline = !isOnline;
}
- (IBAction)btnAgeFromTap:(UIButton *)btn
{
    isAgeFrom = YES;
    ddView=[[BSDropDown alloc] initWithWidth:120 withHeightForEachRow:50 originPoint:btn.origin withOptions:arrAgeFrom];
    ddView.delegate=self;
    ddView.dropDownBGColor=[UIColor whiteColor];
    ddView.dropDownTextColor=[UIColor blackColor];
    //    ddView.dropDownFont=[UIFont systemFontOfSize:13];
    [self.view addSubview:ddView];
}
- (IBAction)btnAgeToTap:(UIButton *)btn
{
    isAgeFrom = NO;
    ddView=[[BSDropDown alloc] initWithWidth:120 withHeightForEachRow:50 originPoint:btn.origin withOptions:arrAgeTo];
    ddView.delegate=self;
    ddView.dropDownBGColor=[UIColor whiteColor];
    ddView.dropDownTextColor=[UIColor blackColor];
    //    ddView.dropDownFont=[UIFont systemFontOfSize:13];
    [self.view addSubview:ddView];
}
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnOkTap:(id)sender
{
    if(isMale && isFemale)
    {
        _gender = -1;
    }
    else if (isMale && !isFemale)
    {
        _gender = 0;
    }
    else if (!isMale && isFemale)
    {
        _gender = 1;
    }
    
    NSDictionary *dict = @{
                           @"gender" : [NSNumber numberWithInt:_gender],
                           @"online" : [NSNumber numberWithInt:_online],
                           @"agefrom" : [NSNumber numberWithInt:_AgeFrom],
                           @"ageto" :[NSNumber numberWithInt:_AgeTo]
                           };
    
    [_delegate selectedData:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - BSDropDownDelegate method
-(void)dropDownView:(UIView *)ddView1 AtIndex:(NSInteger)selectedIndex
{
    [ddView removeFromSuperview];
    
    if(isAgeFrom)
    {
        [btnAgeFrom setTitle:[NSString stringWithFormat:@"%@",arrAgeFrom[selectedIndex]] forState:UIControlStateNormal];
        _AgeFrom = [arrAgeFrom[selectedIndex]intValue];
    }
    else
    {
        [btnAgeTo setTitle:[NSString stringWithFormat:@"%@",arrAgeTo[selectedIndex]] forState:UIControlStateNormal];
        if(selectedIndex == (arrAgeTo.count-1))
        {
            _AgeTo = 110;
        }
        else
        {
            _AgeTo = [arrAgeTo[selectedIndex]intValue];
        }
    }
}

- (IBAction)btnPeopleTap:(UIButton *)people
{
    
    if(people.tag == [WinkGlobalObject.user.ID intValue])
    {
        ProfileViewController *pvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        pvc.isMenu = NO;
        [self presentViewController:pvc animated:YES completion:nil];
    }
    else
    {
        FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
        
        
        NSDictionary *arrDict = [_arrDetail objectAtIndex:0];
        
        NSDictionary *matchDict = [[NSDictionary alloc]init];
        
        
        
        for (int i = 0; i < arrDict.count; i++) {
            
            NSDictionary *dict = [arrDict.allValues objectAtIndex:i];
            
            if([dict.allValues containsObject:[NSString stringWithFormat:@"%d",people.tag]])
                
            {
                
                NSLog(@"YES");
                
                matchDict = dict;
                
                NSLog(@"dict %@",dict);
                
                
                
                if(([dict objectForKey:@"fullname"] != [NSNull null]))
                    
                    fvc.tempName = [dict valueForKey:@"fullname"];
                
                
                
                if(([dict objectForKey:@"login"] != [NSNull null]))
                    
                    fvc.tempUserName = [dict valueForKey:@"login"];
                
                fvc.tempImgProfile = people.imageView.image;
                
                break;
                
            }
            
        }
        
        fvc.profileId = (int)people.tag;
        
        
        [self presentViewController:fvc animated:YES completion:nil];
    }
}

@end
