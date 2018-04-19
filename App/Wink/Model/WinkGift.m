//
//  WinkGift.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkGift.h"

NSString *const GKeyGiftAnonymos        =@"giftAnonymous";
NSString *const GKeyGiftFromUserId      =@"giftFrom";
NSString *const GKeyGiftFromFullName    =@"giftFromUserFullname";
NSString *const GKeyGiftFromUserPhoto   =@"giftFromUserPhoto";
NSString *const GKeyGiftUserName        =@"giftFromUserUsername";
NSString *const GKeyFromUserVerify      =@"giftFromUserVerify";
NSString *const GKeyGiftFromUserVip     =@"giftFromUserVip";
NSString *const GKeyGiftId              =@"giftId";
NSString *const GKeygiftToId            =@"giftTo";
NSString *const GKeyGiftImgURL          =@"imgUrl";
NSString *const GKeyMessage             =@"message";
NSString *const GKeyTimeAgo             =@"timeAgo";
NSString *const GKeyRemoveAt            =@"removeAt";
NSString *const GKeyID                  =@"id";

@implementation WinkGift

@synthesize isFromUserVIP,isUserVerify,isFromAnonymos,fromUserID,fromUserName,fromUserPhoto,fromUserFullName,giftId,giftToID,giftImagePhoto,message,timeAgo,ID;

-(instancetype)initWithDictionary:(NSDictionary *)dictInfo
{
    if (dictInfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        isFromAnonymos = [dictInfo[GKeyGiftAnonymos]boolValue];
        isUserVerify = [dictInfo[GKeyFromUserVerify]boolValue];
        isFromUserVIP = [dictInfo[GKeyGiftFromUserVip]boolValue];
        
        fromUserID = dictInfo[GKeyGiftFromUserId];
        fromUserFullName = dictInfo[GKeyGiftFromFullName];
        fromUserName = dictInfo[GKeyGiftUserName];
        
        giftId = dictInfo[GKeyGiftId];
        giftToID = dictInfo[GKeygiftToId];
        message = dictInfo[GKeyMessage];
        
        timeAgo = dictInfo[GKeyTimeAgo];
        
        ID = dictInfo[GKeyID];
        
        NSURL *url = [NSURL URLWithString:dictInfo[GKeyGiftFromUserPhoto]];
        NSString *lastComponent;
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            fromUserPhoto = [WinkWebservice URLForProfileImage:lastComponent];
        }
        url = [NSURL URLWithString:dictInfo[GKeyGiftImgURL]];
        
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            giftImagePhoto = [WinkWebservice URLForGiftImage:lastComponent];
        }
    
        
    }
    return self;
}
@end
