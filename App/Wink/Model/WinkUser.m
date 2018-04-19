//
//  WinkUser.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkUser.h"





NSString *const UKeyId              =@"id";
NSString *const UKeyUserName        =@"username";
NSString *const UKeyName            =@"fullname";
NSString *const UKeyDetail         =@"userDetails";
NSString *const UKeyPassword        =@"password";
NSString *const UKeyDeviceToken     =@"apn_deviceToken";
NSString *const UKeyAccessToken     =@"accessToken";

NSString *const UKeyClientId        =@"clientId";
NSString *const UKeyAccountId       =@"accountId";
NSString *const UKeyProfileId       =@"profileId";
NSString *const UKeyImage           =@"photo";
NSString *const UKeyGCMId           =@"gcm_regid";

NSString *const UKeyCashOutBalance =@"cashoutBalance";

NSString *const UKeyAdMob           =@"admob";
NSString *const UKeyGhost           =@"ghost";
NSString *const UKeyVIP             =@"vip";
NSString *const UKeyGCM             =@"gcm";
NSString *const UKeyCreatedDate     =@"createDate";
NSString *const UKeyBalance         =@"balance";
NSString *const UKeyFBID            =@"fb_id";
NSString *const UKeyRating          =@"rating";
NSString *const UKeyState           =@"state";
NSString *const UKeyLocation        =@"location";
NSString *const UKeyStatus          =@"status";
NSString *const UKeyFB_Page         =@"fb_page";
NSString *const UKeyInsta_page      =@"instagram_page";
NSString *const UKeyVerify          =@"verify";
NSString *const UKeyEmail           =@"email";
NSString *const UKeyEmailVerify     =@"emailVerify";
NSString *const UKeySex             =@"sex";

NSString *const UKeyYear            =@"year";
NSString *const UKeyMonth           =@"month";
NSString *const UKeyDay             =@"day";
NSString *const UKeyLattitude       =@"lat";
NSString *const UKeyLongittude      =@"lng";
NSString *const UKeyLanguage        =@"language";
NSString *const UKeylowPhotoUrl     =@"lowPhotoUrl";
NSString *const UKeyNormalPhotoUrl  =@"normalPhotoUrl";
NSString *const UKeyBigPhotoUrl     =@"bigPhotoUrl";
NSString *const UKeyCoverURL        =@"coverUrl";
NSString *const UKeyOriginCoverUrl  =@"originCoverUrl";
NSString *const UKeyRStatus         =@"iStatus";

NSString *const UKeyPoliticalViews  =@"iPoliticalViews";
NSString *const UKeyWorldView       =@"iWorldView";
NSString *const UKeyPersonalPriority   =@"iPersonalPriority";
NSString *const UKeyImportantInOthers   =@"iImportantInOthers";
NSString *const UKeySmokingViews        =@"iSmokingViews";
NSString *const UKeyAlcoholViews        =@"iAlcoholViews";
NSString *const UKeyLooking             =@"iLooking";
NSString *const UKeyInterested          =@"iInterested";
NSString *const UKeyallowPhotosComments =@"allowPhotosComments";
NSString *const UKeyallowComments       =@"allowComments";
NSString *const UKeyallowMessages       =@"allowMessages";
NSString *const UKeyallowLikesGCM       =@"allowLikesGCM";
NSString *const UKeyallowBirthday       =@"allowShowMyBirthday";
NSString *const UKeyBlock               =@"blocked";

NSString *const UKeyallowGiftsGCM       =@"allowGiftsGCM";
NSString *const UKeyallowCommentsGCM    =@"allowCommentsGCM";
NSString *const UKeyallowFollowersGCM   =@"allowFollowersGCM";
NSString *const UKeyallowMessagesGCM    =@"allowMessagesGCM";
NSString *const UKeyallowCommentReplyGCM=@"allowCommentReplyGCM";
NSString *const UKeyIsOnline            =@"online";
NSString *const UKeyIsFriend            =@"friend";
NSString *const UKeyIsMyLike            =@"myLike";
NSString *const UKeyFriendsCount        =@"friendsCount";
NSString *const UKeyphotosCount         =@"photosCount";
NSString *const UKeylikesCount          =@"likesCount";
NSString *const UKeygiftsCount          =@"giftsCount";
NSString *const UKeynotificationsCount  =@"notificationsCount";

NSString *const UKeyGuestsCount         =@"guestsCount";
NSString *const UKeyNewFriendsCount     =@"newFriendsCount";
NSString *const UKeyMessagesCount       =@"messagesCount";
NSString *const UKeyAdding_job          =@"adding_job";
NSString *const UKeyHeight              =@"height";
NSString *const UKeyAge                 =@"age";
NSString *const UKeyReligion            =@"religion";
NSString *const UKeyInterest            =@"interest";

NSString *const UKeyDistance           =@"distance";


@implementation WinkUser

@synthesize ID,name,userName,email,status;
@synthesize isAdmob,follow,isGhost,isVIP,isGCM,verify,emailVerify,isAllowPhotoComment,isAllowComment,isAllowMessage,isAllowLikesGCM,isAllowGiftGCM,isAllowCommentsGCM,isAllowFollowersGCM,isAllowMessagesGCM,isallowCommentReplyGCM,isOnline,isBlocked,isFriend,isMyLike,isAllowBirthday;

@synthesize balance,rating,state,gender,bYear,bMonth,bDay,rStatus,politicalView,worldView,personalView,importantInOthers,smokingViews,alcoholView,lookingFor,interested,friendsCount,photosCount,likesCount,giftsCount,notificationsCount,guestCount,newFriendsCount,messagesCount,distance,cashOutBalance;

@synthesize fb_id,location,fStatus,fb_page,insta_page,lattitude,longittude,language,adding_job,height,age,religion,interest,lowSizeProfString,originCoverString;
@synthesize lowSizeProfURL,normalSizeProfURL,bigSizeProfURL,coverURL,originCoverURL,gcmregID,createdDate;

-(instancetype)initWithDictionary:(NSDictionary *)userinfo
{
    if (userinfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID          = userinfo[UKeyId];
        userName     = userinfo[UKeyUserName];
        name        = userinfo[UKeyName];
        email       = userinfo[UKeyEmail];
        isAdmob      = [userinfo[UKeyAdMob]boolValue];
        isGhost    = [userinfo[UKeyGhost]boolValue];
        isVIP      = [userinfo[UKeyVIP]boolValue];
        isGCM       = [userinfo[UKeyGCM]boolValue];
        verify      = [userinfo[UKeyVerify]boolValue];
        follow     = [userinfo[@"follow"]boolValue];
        emailVerify   = [userinfo[UKeyEmailVerify]boolValue];
        isAllowPhotoComment = [userinfo[UKeyallowPhotosComments]boolValue];
        isAllowComment = [userinfo[UKeyallowComments]boolValue];
        isAllowMessage = [userinfo[UKeyallowMessages]boolValue];
        isAllowLikesGCM = [userinfo[UKeyallowLikesGCM]boolValue];
        isAllowGiftGCM = [userinfo[UKeyallowGiftsGCM]boolValue];
        isAllowCommentsGCM = [userinfo[UKeyallowCommentsGCM]boolValue];
        isAllowFollowersGCM = [userinfo[UKeyallowFollowersGCM]boolValue];
        isAllowMessagesGCM = [userinfo[UKeyallowMessagesGCM]boolValue];
        isallowCommentReplyGCM = [userinfo[UKeyallowCommentsGCM]boolValue];
        isAllowBirthday = [userinfo[UKeyallowBirthday]boolValue];
        isOnline     = [userinfo[UKeyIsOnline]boolValue];
        isBlocked = [userinfo[UKeyBlock]boolValue];
        isFriend  = [userinfo[UKeyIsFriend]boolValue];
        isMyLike = [userinfo[UKeyIsMyLike]boolValue];
        
        balance = [userinfo[UKeyBalance]intValue];
        rating = [userinfo[UKeyRating]intValue];
        state  = [userinfo[UKeyState]intValue];
        gender = [userinfo[UKeySex]intValue];
        bYear = [userinfo[UKeyYear]intValue];
        bMonth = [userinfo[UKeyMonth]intValue] + 1;
        bDay = [userinfo[UKeyDay]intValue];
        rStatus = [userinfo[UKeyRStatus]intValue];
        
        politicalView = [userinfo[UKeyPoliticalViews]intValue];
        worldView = [userinfo[UKeyWorldView]intValue];
        personalView = [userinfo[UKeyPersonalPriority]intValue];
        importantInOthers = [userinfo[UKeyImportantInOthers]intValue];
        smokingViews = [userinfo[UKeySmokingViews]intValue];
        alcoholView = [userinfo[UKeyAlcoholViews]intValue];
        lookingFor  =[userinfo[UKeyLooking]intValue];
        interested  = [userinfo[UKeyInterested]intValue];
        friendsCount =[userinfo[UKeyFriendsCount]intValue];
        photosCount = [userinfo[UKeyphotosCount]intValue];
        likesCount = [userinfo[UKeylikesCount]intValue];
        giftsCount = [userinfo[UKeygiftsCount]intValue];
        notificationsCount = [userinfo[UKeynotificationsCount]intValue];
        guestCount = [userinfo[UKeyGuestsCount]intValue];
        newFriendsCount = [userinfo[UKeyNewFriendsCount]intValue];
        messagesCount = [userinfo[UKeyMessagesCount]intValue];
        
        distance = [userinfo[UKeyDistance]floatValue];
        
        fb_id = userinfo[UKeyFBID];
        gcmregID = userinfo[UKeyGCMId];
        location = userinfo[UKeyLocation];
        fStatus = userinfo[fStatus];
        fb_page = userinfo[UKeyFB_Page];
        insta_page = userinfo[UKeyInsta_page];
        lattitude = userinfo[UKeyLattitude];
        longittude = userinfo[UKeyLongittude];
        language = userinfo[UKeyLanguage];
        cashOutBalance = userinfo[UKeyCashOutBalance];
        
        status = userinfo[UKeyStatus];
        
        if([userinfo[UKeyAdding_job] isKindOfClass:[NSString class]])
        {
            adding_job = userinfo[UKeyAdding_job];

        }
        else
        {
            adding_job = @"";

        }
        if([userinfo[UKeyHeight] isKindOfClass:[NSString class]])
        {
            height = userinfo[UKeyHeight];
        }
        else
        {
            adding_job = @"";
            
        }
       
        if([userinfo[UKeyAge]  isKindOfClass:[NSString class]])
        {
            age     = userinfo[UKeyAge];
        }
        
        if([userinfo[UKeyReligion] isKindOfClass:[NSString class]])
        {
             religion = userinfo[UKeyReligion];
            
        }
        else
        {
             religion = @"";
            
        }
       
        interest = userinfo[UKeyInterest];
        createdDate = userinfo[UKeyCreatedDate];
        
        NSURL *url = [NSURL URLWithString:userinfo[UKeylowPhotoUrl]];
        NSString *lastComponent;
        if([url isKindOfClass:[NSURL class]])
        {
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                lowSizeProfURL = [WinkWebservice URLForProfileImage:lastComponent];
            }

        }
        
        url = [NSURL URLWithString:userinfo[UKeyNormalPhotoUrl]];
        if([url isKindOfClass:[NSURL class]])
        {
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                normalSizeProfURL = [WinkWebservice URLForProfileImage:lastComponent];
            }
        }
        NSString *str = userinfo[UKeyBigPhotoUrl];
        if([str isKindOfClass:[NSString class]])
        {
            url = [NSURL URLWithString:userinfo[UKeyBigPhotoUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                bigSizeProfURL = [WinkWebservice URLForProfileImage:lastComponent];
            }
        }
        
        url = [NSURL URLWithString:userinfo[UKeyCoverURL]];
        if([url isKindOfClass:[NSURL class]])
        {
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                coverURL = [WinkWebservice URLForCoverImage:lastComponent];
            }
        }
    
        url = [NSURL URLWithString:userinfo[UKeyOriginCoverUrl]];
        if([url isKindOfClass:[NSURL class]])
        {
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                originCoverURL = [WinkWebservice URLForCoverImage:lastComponent];
            }

        }
        lowSizeProfString = [NSString stringWithFormat:@"%@",lowSizeProfURL];
        originCoverString = [NSString stringWithFormat:@"%@",originCoverURL];
    }
    return self;
}
-(void)login
{
    WinkGlobalObject.user = self;
    [self saveInUserDefaults];
    [WinkUtil registerForPushNotification];
}
- (void)saveInUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:[self getDictionary] forKey:UKeyDetail];
    
    [userDefaults synchronize];
}
- (NSDictionary *)getDictionary
{
    
   /* isAdmob      = [userinfo[UKeyAdMob]boolValue];
    isGhost    = [userinfo[UKeyGhost]boolValue];
    isVIP      = [userinfo[UKeyVIP]boolValue];
    isGCM       = [userinfo[UKeyGCM]boolValue];
    verify      = [userinfo[UKeyVerify]boolValue];
    emailVerify   = [userinfo[UKeyEmailVerify]boolValue];
    isAllowPhotoComment = [userinfo[UKeyallowPhotosComments]boolValue];
    isAllowComment = [userinfo[UKeyallowComments]boolValue];
    isAllowMessage = [userinfo[UKeyallowMessages]boolValue];
    isAllowLikesGCM = [userinfo[UKeyallowLikesGCM]boolValue];
    isAllowGiftGCM = [userinfo[UKeyallowGiftsGCM]boolValue];
    isAllowCommentsGCM = [userinfo[UKeyallowCommentsGCM]boolValue];
    isAllowFollowersGCM = [userinfo[UKeyallowFollowersGCM]boolValue];
    isAllowMessagesGCM = [userinfo[UKeyallowMessagesGCM]boolValue];
    isallowCommentReplyGCM = [userinfo[UKeyallowCommentsGCM]boolValue];
    isOnline     = [userinfo[UKeyIsOnline]boolValue];
    isBlocked = [userinfo[UKeyBlock]boolValue];
    
    balance = [userinfo[UKeyBalance]intValue];*/
    
    NSDictionary *userInfo = @{
                               UKeyId           : WinkGlobalObject.user.ID,
                               UKeyName         : WinkGlobalObject.user.name,
                               UKeyUserName     : WinkGlobalObject.user.userName,
                               UKeyEmail        : WinkGlobalObject.user.email,
                               UKeylowPhotoUrl  : WinkGlobalObject.user.lowSizeProfString,
                               UKeyOriginCoverUrl : WinkGlobalObject.user.originCoverString,
                               UKeyFBID : WinkGlobalObject.user.fb_id,
                               UKeyAdMob : [NSNumber numberWithBool:WinkGlobalObject.user.isAdmob],
                               UKeyVerify : [NSNumber numberWithBool:WinkGlobalObject.user.verify],
                               UKeyGhost : [NSNumber numberWithBool:WinkGlobalObject.user.isGhost],
                               UKeyBalance : [NSNumber  numberWithInt:balance],
                               UKeyCashOutBalance : WinkGlobalObject.user.cashOutBalance,
                           };
    return userInfo;
}
- (instancetype)initFromUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [userDefaults valueForKey:UKeyDetail];
    
    if (userInfo)
    {
        self = [[WinkUser alloc] initWithDictionary:userInfo];
    }
    else
    {
        return nil;
    }
    
    return self;
}
-(void)logout
{
    WinkGlobalObject.user = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:UKeyDetail];
    [userDefaults setValue:nil forKey:UKeyAccessToken];

    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
@end
