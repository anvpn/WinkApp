//
//  FriendsCollectionCell.h
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvProfilePic;
@property (weak, nonatomic) IBOutlet UIImageView *imgvvideoLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgvOnline;

@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCredit;

@property (weak, nonatomic) IBOutlet UIImageView *img_onlineoffline;


-(void)setCellData:(WinkFriend *)frnd;
-(void)setGallaryPhoto :(WinkPhotos *)photos;
-(void)setNearbyFriends:(WinkUser *)user;
-(void)setSearchFrndData:(WinkUser *)user;

@end
