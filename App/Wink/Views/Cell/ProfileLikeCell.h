//
//  ProfileLikeCell.h
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileLikeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgvProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_online;

@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeAgo;
@property (weak, nonatomic) IBOutlet UIImageView *imgvGift;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;

@property (weak, nonatomic) IBOutlet UILabel *lblFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;


@property (weak, nonatomic) IBOutlet UILabel *lblMsgCount;

@property (weak, nonatomic) IBOutlet UILabel *lblOnline;

@property (weak, nonatomic) IBOutlet UILabel *lbl_firstname;

@property (weak, nonatomic) IBOutlet UIButton *btn_Giftcancel;


-(void)setCellData:(WinkUser *)user;
-(void)setGiftCellData:(WinkGift *)user;
-(void)setNotificationCellData:(WinkNotification *)noti;
-(void)setCommentData:(WinkComment *)comment;

-(void)setBlockedPeopleData:(NSDictionary *)dict;
-(void)setContactData:(NSDictionary *)dict;
-(void)setMessageCellData:(WinkChat *)chat;

-(void)setCashoutData:(NSDictionary *)dict;


@end
