//
//  FriendsCollectionCell.m
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "FriendsCollectionCell.h"

@implementation FriendsCollectionCell
@synthesize lblStatus,lblFullName,imgvProfilePic;
-(void)setCellData:(WinkFriend *)frnd
{
    if(frnd.isOnline)
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"online.png"]];
        lblFullName.textColor = [UIColor greenColor];
    }
    else
    {
        [_imgvOnline setImage:[UIImage imageNamed:@"offline.png"]];
        lblFullName.textColor = [UIColor whiteColor];
    }
    NSString *Verify = frnd.friendUserVerify;
    if ([Verify isEqualToString:@"1"])
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSString *Name = [NSString stringWithFormat:@"%@ ",frnd.fullname];
        //NSString *Name = frnd.fullname;
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblFullName.attributedText  = myString;
    }
    else
    {
        lblFullName.text = frnd.fullname;
    }
    //[imgvProfilePic setImageWithURL:frnd.photoURL ];
    [imgvProfilePic setImageWithURL:frnd.photoURL placeholderImage:[UIImage imageNamed:@"defaultthumbnail"]];
}
-(void)setGallaryPhoto:(WinkPhotos *)photos
{
//    [imgvProfilePic setImageWithURL:photos.gallaryNormalPhotoURL];
    
    [imgvProfilePic sd_setImageWithURL:photos.gallaryNormalPhotoURL placeholderImage:[UIImage imageNamed:@"img_defaultthumbnail"] options:SDWebImageRefreshCached];
    
    
    if(photos.isVideo)
    {
        _imgvvideoLayer.hidden = NO;
    }
    else
    {
        _imgvvideoLayer.hidden = YES;
    }
    imgvProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    imgvProfilePic.layer.masksToBounds=YES;
    //imgvProfilePic.contentMode UIViewContentMode.ScaleAspectFill;
    //imgvProfilePic.layer.maskToBounds=YES;
}
-(void)setNearbyFriends:(WinkUser *)user
{
    lblFullName.text = user.name;
    _lblDistance.text = [NSString stringWithFormat:@"%.01fKm",user.distance];
    [imgvProfilePic setImageWithURL:user.lowSizeProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
}
-(void)setSearchFrndData:(WinkUser *)user
{
    
    if(user.isOnline)
    {
        self.img_onlineoffline.image = [UIImage imageNamed:@"ic_online.png"];
        lblStatus.text = @"Online";
        lblFullName.textColor = [UIColor greenColor];
    }
    else
    {
        self.img_onlineoffline.image = [UIImage imageNamed:@"offline.png"];
        lblStatus.text = @"Offline";
        lblFullName.textColor = [UIColor whiteColor];
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
    
   
    [imgvProfilePic setImageWithURL:user.lowSizeProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
}
@end
