//
//  WinkGift.h
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GKeyGiftAnonymos;
extern NSString *const GKeyGiftFromUserId;
extern NSString *const GKeyGiftFromFullName;
extern NSString *const GKeyGiftFromUserPhoto;
extern NSString *const GKeyGiftUserName;
extern NSString *const GKeyFromUserVerify;
extern NSString *const GKeyGiftFromUserVip;
extern NSString *const GKeyGiftId;
extern NSString *const GKeygiftToId;
extern NSString *const GKeyGiftImgURL;
extern NSString *const GKeyMessage;
extern NSString *const GKeyTimeAgo;
extern NSString *const GKeyRemoveAt;


@interface WinkGift : NSObject

@property BOOL isFromAnonymos;
@property BOOL isUserVerify;
@property BOOL isFromUserVIP;

@property (strong,nonatomic) NSString *fromUserID;
@property (strong,nonatomic) NSString *fromUserFullName;
@property (strong,nonatomic) NSString *fromUserName;

@property (strong,nonatomic) NSURL *fromUserPhoto;
@property (strong,nonatomic) NSURL *giftImagePhoto;

@property (strong,nonatomic) NSString *giftId;
@property (strong,nonatomic) NSString *giftToID;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSString *timeAgo;
@property (strong,nonatomic) NSString *ID;

-(instancetype)initWithDictionary:(NSDictionary *)dictInfo;

@end
