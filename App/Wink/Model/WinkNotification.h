//
//  WinkNotification.h
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NKeyUserFullName;
extern NSString * const NKeyUserID;
extern NSString * const NKeyUserPhotoURL;
extern NSString * const NKeyUserState;
extern NSString * const NKeyUserName;
extern NSString * const NKeyNId;
extern NSString * const NKeyIteamId;
extern NSString * const NKeyTimeAgo;
extern NSString * const NKeyNType;

typedef NS_ENUM(NSInteger, WinkNotificationState)
{
    WinkNotificationStatePending,
    WinkNotificationStateShown,
    WinkNotificationStateRedirected,
    WinkNotificationStateComplete,
};
typedef NS_ENUM(NSInteger, WinkNotificationType)
{
    WinkNotificationLike,
    WinkNotificationFollower,
    WinkNotificationMessage,
    WinkNotificationComment,
    WinkNotificationCommentReply,
    WinkNotificationFriendRequestAccepted,
    WinkNotificationGift,
    WinkNotificationImageComment,
    WinkNotificationImageCommentReply,
    WinkNotificationImageLike
};
@interface WinkNotification : NSObject

@property (strong, nonatomic) NSString *userFullName;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *nId;
@property (strong, nonatomic) NSString *timeAgo;
@property (strong, nonatomic) NSString *nType;
@property (strong, nonatomic) NSString *iteamId;

@property (strong, nonatomic) NSDictionary *msgDict;

@property  WinkNotificationState notificationState;

@property (strong, nonatomic) NSURL *NotiphotoURL;

-(instancetype)initWithDictionary:(NSDictionary *)dictNInfo;

@end
#define WinkNotificationManagerObject [WinkNotificationManager notificationManager]

@interface WinkNotificationManager : NSObject

+ (WinkNotificationManager *)notificationManager;

- (void)addNotification:(NSDictionary *)payload;

- (void)clearAllNotifications;
@end
