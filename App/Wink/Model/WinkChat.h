//
//  WinkChat.h
//  Wink
//
//  Created by Apple on 07/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CHKeyChatId;
extern NSString *const CHKeyWithUserId;
extern NSString *const CHKeyWithUserVerify;
extern NSString *const CHKeyWithUserState;
extern NSString *const CHKeyWithUserUsername;
extern NSString *const CHKeyWithUserFullname;
extern NSString *const CHKeyWithUserPhotoUrl;
extern NSString *const CHKeylastMessage;
extern NSString *const CHKeylastMessageAgo;
extern NSString *const CHKeynewMessagesCount;
extern NSString *const CHKeytimeAgo;

@interface WinkChat : NSObject

@property (strong, nonatomic) NSString *chatId;
@property (strong, nonatomic) NSString *WithUserId;
@property (strong, nonatomic) NSString *WithUserVerify;
@property (strong, nonatomic) NSString *WithUserState;
@property (strong, nonatomic) NSString *WithUserUsername;
@property (strong, nonatomic) NSString *WithUserFullname;
@property (strong, nonatomic) NSString *lastMessage;
@property (strong, nonatomic) NSString *lastMessageAgo;
@property (strong, nonatomic) NSString *msgCount;
@property (strong, nonatomic) NSString *timeAgo;

@property (strong, nonatomic) NSURL * WithUserPhotoUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictChatInfo;

@end
