//
//  WinkUser.h
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const UKeyId;
extern NSString *const UKeyUserName;
extern NSString *const UKeyName;
extern NSString *const UKeyPassword;
extern NSString *const UKeyDetail;

extern NSString *const UKeyDeviceToken;
extern NSString *const UKeyAccessToken;
extern NSString *const UKeyClientId;
extern NSString *const UKeyAccountId;
extern NSString *const UKeyProfileId;
extern NSString *const UKeyImage;
extern NSString *const UKeyGCMId;

extern NSString *const UKeyAdMob;
extern NSString *const UKeyGhost;
extern NSString *const UKeyVIP;
extern NSString *const UKeyGCM;
extern NSString *const UKeyCreatedDate;
extern NSString *const UKeyCashOutBalance;

extern NSString *const UKeyBalance;
extern NSString *const UKeyFBID;
extern NSString *const UKeyRating;
extern NSString *const UKeyState;
extern NSString *const UKeyLocation;
extern NSString *const UKeyStatus;
extern NSString *const UKeyFB_Page;
extern NSString *const UKeyInsta_page;
extern NSString *const UKeyVerify;
extern NSString *const UKeyEmail;
extern NSString *const UKeyEmailVerify;
extern NSString *const UKeySex;

extern NSString *const UKeyYear;
extern NSString *const UKeyMonth;
extern NSString *const UKeyDay;
extern NSString *const UKeyLattitude;
extern NSString *const UKeyLongittude;
extern NSString *const UKeyLanguage;
extern NSString *const UKeylowPhotoUrl;
extern NSString *const UKeyNormalPhotoUrl;
extern NSString *const UKeyBigPhotoUrl;
extern NSString *const UKeyCoverURL;
extern NSString *const UKeyOriginCoverUrl;
extern NSString *const UKeyRStatus;

extern NSString *const UKeyPoliticalViews;
extern NSString *const UKeyWorldView;
extern NSString *const UKeyPersonalPriority;
extern NSString *const UKeyImportantInOthers;
extern NSString *const UKeySmokingViews;
extern NSString *const UKeyAlcoholViews;
extern NSString *const UKeyLooking;
extern NSString *const UKeyInterested;
extern NSString *const UKeyallowPhotosComments;
extern NSString *const UKeyallowComments;
extern NSString *const UKeyallowMessages;
extern NSString *const UKeyallowLikesGCM;
extern NSString *const UKeyallowBirthday;
extern NSString *const UKeyBlock;


extern NSString *const UKeyallowGiftsGCM;
extern NSString *const UKeyallowCommentsGCM;
extern NSString *const UKeyallowFollowersGCM;
extern NSString *const UKeyallowMessagesGCM;
extern NSString *const UKeyallowCommentReplyGCM;
extern NSString *const UKeyIsOnline;
extern NSString *const UKeyIsFriend;
extern NSString *const UKeyIsMyLike;
extern NSString *const UKeyFriendsCount;
extern NSString *const UKeyphotosCount;
extern NSString *const UKeylikesCount;
extern NSString *const UKeygiftsCount;
extern NSString *const UKeynotificationsCount;

extern NSString *const UKeyGuestsCount;
extern NSString *const UKeyNewFriendsCount;
extern NSString *const UKeyMessagesCount;
extern NSString *const UKeyAdding_job;
extern NSString *const UKeyHeight;
extern NSString *const UKeyAge;
extern NSString *const UKeyReligion;
extern NSString *const UKeyInterest;

extern NSString *const UKeyDistance;


@interface WinkUser : NSObject

@property (strong, nonatomic) NSString  *ID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;


@property  BOOL isAdmob;
@property  BOOL isGhost;
@property  BOOL isVIP;
@property  BOOL isGCM;
@property  BOOL follow;
@property  BOOL verify;
@property  BOOL emailVerify;
@property  BOOL isAllowPhotoComment;
@property  BOOL isAllowComment;
@property  BOOL isAllowMessage;
@property  BOOL isAllowLikesGCM;
@property  BOOL isAllowGiftGCM;
@property  BOOL isAllowCommentsGCM;
@property  BOOL isAllowFollowersGCM;
@property  BOOL isAllowMessagesGCM;
@property  BOOL isallowCommentReplyGCM;
@property  BOOL isAllowBirthday;
@property  BOOL isOnline;
@property  BOOL isBlocked;
@property  BOOL isFriend;
@property  BOOL isMyLike;

@property int balance;
@property int rating;
@property int state;
@property int gender;
@property int bYear;
@property int bMonth;
@property int bDay;

@property int rStatus;
@property int politicalView;
@property int worldView;
@property int personalView;
@property int importantInOthers;
@property int smokingViews;
@property int alcoholView;
@property int lookingFor;
@property int interested;

@property int friendsCount;
@property int photosCount;
@property int likesCount;
@property int giftsCount;
@property int notificationsCount;
@property int guestCount;
@property int newFriendsCount;
@property int messagesCount;

@property float distance;

@property (strong, nonatomic) NSString *fb_id;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *fStatus;
@property (strong, nonatomic) NSString *fb_page;
@property (strong, nonatomic) NSString *insta_page;
@property (strong, nonatomic) NSString *lattitude;
@property (strong, nonatomic) NSString *longittude;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *adding_job;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *religion;
@property (strong, nonatomic) NSString *interest;
@property (strong, nonatomic) NSString *gcmregID;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *cashOutBalance;

@property (strong, nonatomic) NSURL  *lowSizeProfURL;
@property (strong, nonatomic) NSURL  *normalSizeProfURL;
@property (strong, nonatomic) NSURL  *bigSizeProfURL;
@property (strong, nonatomic) NSURL  *coverURL;
@property (strong, nonatomic) NSURL *originCoverURL;

@property (strong, nonatomic) NSString *lowSizeProfString;
@property (strong, nonatomic) NSString *originCoverString;



-(instancetype)initWithDictionary:(NSDictionary *)userinfo;
- (instancetype)initFromUserDefault;

//- (void)signup;
- (void)login;
- (void)logout;

- (void)saveInUserDefaults;

@end
