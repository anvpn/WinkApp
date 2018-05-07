//
//  ProfileLikeCell.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ProfileLikeCell.h"

@implementation ProfileLikeCell
@synthesize imgvProfile,lblCity,lblFullName,lblUserName,imgvGift,lblTimeAgo,btnDelete,imgType,lbl_online;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setCellData:(WinkUser *)user
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    
    /* [btnProfilePic setImageForState:UIControlStateNormal withURL:user.lowSizeProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];*/
    
    [imgvProfile setImageWithURL:user.lowSizeProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    lblUserName.text = [NSString stringWithFormat:@"@%@",user.userName];
    //lblFullName.text = user.name;
    lblCity.text = user.location;
    if(user.isOnline)
    {
        _lblOnline.hidden = NO;
    }
    
    if (user.isOnline)
    {
        lbl_online.hidden=NO;
    }
    else
    {
        lbl_online.hidden=YES;
    }
    if (user.verify)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSString *Name = [NSString stringWithFormat:@"%@ ",user.name];
        
        //NSString *Name = user.name;
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblFullName.attributedText  = myString;
    }
    else
    {
        lblFullName.text = user.name;
    }
    
}
-(void)setGiftCellData:(WinkGift *)gift
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    
    [imgvProfile setImageWithURL:gift.fromUserPhoto placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    lblUserName.text = [NSString stringWithFormat:@"@%@",gift.fromUserName];
    lblFullName.text = gift.fromUserFullName;
    lblTimeAgo.text = gift.timeAgo;
    
    [imgvGift setImageWithURL:gift.giftImagePhoto];
}
-(void)setNotificationCellData:(WinkNotification *)noti
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    [imgvProfile setImageWithURL:noti.NotiphotoURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    lblFullName.text = noti.message;
    lblTimeAgo.text = noti.timeAgo;
    imgType.layer.cornerRadius = imgType.layer.frame.size.width/2;
    imgType.layer.masksToBounds = YES;
    if ([noti.nType isEqualToString:@"0"])
    {
        NSLog(@"0");
        imgType.image = [UIImage imageNamed:@"img_notify_like.png"];
    }
    else if ([noti.nType isEqualToString:@"1"])
    {
        NSLog(@"1");
        imgType.image = [UIImage imageNamed:@"img_notify_follower.png"];
    }
    else if ([noti.nType isEqualToString:@"2"])
    {
        NSLog(@"2");
        imgType.image = [UIImage imageNamed:@"img_notify_follower.png"];
    }
    else if ([noti.nType isEqualToString:@"3"])
    {
        NSLog(@"3");
        imgType.image = [UIImage imageNamed:@"img_notify_comment.png"];
    }
    else if ([noti.nType isEqualToString:@"4"])
    {
        NSLog(@"4");
        imgType.image = [UIImage imageNamed:@"img_notify_reply.png"];
    }
    else if ([noti.nType isEqualToString:@"5"])
    {
        NSLog(@"5");
        imgType.image = [UIImage imageNamed:@"img_notify_follower.png"];
    }
    else if ([noti.nType isEqualToString:@"6"])
    {
        NSLog(@"6");
        imgType.image = [UIImage imageNamed:@"img_notify_gift.png"];
    }
    else if ([noti.nType isEqualToString:@"7"])
    {
        NSLog(@"7");
        imgType.image = [UIImage imageNamed:@"img_notify_comment.png"];
    }
    else if ([noti.nType isEqualToString:@"8"])
    {
        NSLog(@"8");
        imgType.image = [UIImage imageNamed:@"img_notify_reply.png"];
    }
    else if ([noti.nType isEqualToString:@"9"])
    {
        NSLog(@"9");
        imgType.image = [UIImage imageNamed:@"img_notify_like.png"];
    }
}
-(void)setCommentData:(WinkComment *)comment
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    [imgvProfile setImageWithURL:comment.fromUserPhotoUrl placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    const char *jsonString = [comment.comment UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    _lblComment.text = goodMsg;

    lblFullName.text = comment.fromUserFullname;
    lblTimeAgo.text = comment.timeAgo;
    if([comment.fromUserId isEqualToString:WinkGlobalObject.user.ID])
    {
        //[btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        btnDelete.tag = 1;
        [btnDelete setImage:[UIImage imageNamed:@"img_del.png"] forState:UIControlStateNormal];
    }
    else
    {
        //[btnDelete setTitle:@"Reply" forState:UIControlStateNormal];
        btnDelete.tag = 2;
        
        [btnDelete setImage:[UIImage imageNamed:@"img_notify_reply.png"] forState:UIControlStateNormal];
        //[btnDelete setImage:[UIImage imageNamed:@"img_reports.png"] forState:UIControlStateNormal];
    }
}
-(void)setBlockedPeopleData:(NSDictionary *)dict
{
    
    BOOL blockUV = [[dict valueForKey:@"blockedUserVerify"]boolValue];
    
    if (blockUV)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        //lblFullName.text = dict[@"blockedUserFullname"];
        
        NSString *Name = [NSString stringWithFormat:@"%@ ",dict[@"blockedUserFullname"]];
        
        //NSString *Name = user.name;
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblFullName.attributedText  = myString;
    }
    else
    {
        lblFullName.text = dict[@"blockedUserFullname"];
    }
    
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:dict[@"blockedUserPhotoUrl"]];
    NSString *lastComponent;
    NSURL *photoURL = [[NSURL alloc]init];
    
    if(url != nil && url != NULL && (url.absoluteString.length != 0))
    {
        lastComponent = [url lastPathComponent];
        photoURL = [WinkWebservice URLForProfileImage:lastComponent];
    }
    
    [imgvProfile setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    //lblFullName.text = dict[@"blockedUserFullname"];
    lblTimeAgo.text = dict[@"timeAgo"];
}
-(void)setContactData:(NSDictionary *)dict
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    
    if([dict valueForKey:@"firstname"] != nil)
    {
        lblFullName.text = dict[@"firstname"];
        NSString *firstLetter = @"";
        if(lblFullName.text.length > 1)
        {
           firstLetter = [dict[@"firstname"] substringToIndex:1];
        }
        _lbl_firstname.text = firstLetter;
    }
    else
    {
        _lbl_firstname.text =  @"#";
    }
    if([dict valueForKey:@"number"] != nil)
    {
        _lblPhoneNumber.text = dict[@"number"];
    }
    
    
    float red = arc4random() % 255 / 255.0;
    float green = arc4random() % 255 / 255.0;
    float blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [imgvProfile setBackgroundColor:color];
}

-(void)setMessageCellData:(WinkChat *)chat
{
    imgvProfile.layer.cornerRadius = imgvProfile.width / 2;
    imgvProfile.layer.masksToBounds = YES;
    [imgvProfile setImageWithURL:chat.WithUserPhotoUrl placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    //ana
    imgvProfile.contentMode = UIViewContentModeScaleAspectFill ;
    
    NSString *Verify = chat.WithUserVerify;
    
    if ([Verify isEqualToString:@"1"])
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        //NSString *Name = chat.WithUserFullname;
        NSString *Name = [NSString stringWithFormat:@"%@ ",chat.WithUserFullname];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblFullName.attributedText  = myString;
    }
    else
    {
        lblFullName.text = chat.WithUserFullname;
    }
    
    
    const char *jsonString = [chat.lastMessage UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    _lblMsgCount.layer.cornerRadius = _lblMsgCount.frame.size.width/2;
    _lblMsgCount.clipsToBounds = true;
    _lblMsgCount.layer.masksToBounds = true;
    
    
    
    _lblLastMessage.text = goodMsg;
    lblTimeAgo.text = chat.lastMessageAgo;
    if([chat.msgCount intValue] > 0)
    {
        _lblMsgCount.text = chat.msgCount;
        _lblMsgCount.hidden = NO;
    }
    else
    {
        _lblMsgCount.hidden = YES;
    }
    
    //lblFullName.text =
}
-(void)setCashoutData:(NSDictionary *)dict
{
    NSString *action = dict[@"action"];
    if([action isEqualToString:@"ACTION_GIFT_SEND"])
    {
        _lblFirstLabel.text = @"Points From Sending Gifts:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"GIFT_SEND.png"];
    }
    if([action isEqualToString:@"ACTION_INVITE_FRIEND"])
    {
        _lblFirstLabel.text = @"Points From Invite Friend:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"img_invitefriends.png"];
    }
    else if ([action isEqualToString:@"ACTION_PROFILE_UPDATED"])
    {
        _lblFirstLabel.text = @"Points From Update Profile:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"PROFILE_UPDATED.png"];
        
    }
    else if ([action isEqualToString:@"ACTION_LOGIN"])
    {
        _lblFirstLabel.text = @"Points When you Log In:";
        _lblBalance.text = dict[@"total_points"];
        //MESSAGE_SEND
        imgvProfile.image = [UIImage imageNamed:@"LOGIN.png"];
        
    }
    else if ([action isEqualToString:@"ACTION_MESSAGE_SEND"])
    {
        _lblFirstLabel.text = @"Points From Message:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"MESSAGE_SEND.png"];
    }
    else if ([action isEqualToString:@"ACTION_WITHDRAWAL"])
    {
        _lblFirstLabel.text = @"Points you Withdraw:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"WITHDRAWAL.png"];
    }
    else if ([action isEqualToString:@"ACTION_GIFT_RECEIVE"])
    {
        _lblFirstLabel.text = @"Points from Receive Gifts:";
        _lblBalance.text = dict[@"total_points"];
        imgvProfile.image = [UIImage imageNamed:@"GIFT_RECEIVE.png"];
    }
}
@end
