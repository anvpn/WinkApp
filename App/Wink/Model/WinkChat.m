//
//  WinkChat.m
//  Wink
//
//  Created by Apple on 07/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkChat.h"

 NSString *const CHKeyChatId            =   @"id";
 NSString *const CHKeyWithUserId        =   @"withUserId";
 NSString *const CHKeyWithUserVerify    =@"withUserVerify";
 NSString *const CHKeyWithUserState     =@"withUserState";
 NSString *const CHKeyWithUserUsername  = @"withUserUsername";
 NSString *const CHKeyWithUserFullname  =@"withUserFullname";
 NSString *const CHKeyWithUserPhotoUrl   =@"withUserPhotoUrl";
 NSString *const CHKeylastMessage       =@"lastMessage";
 NSString *const CHKeylastMessageAgo    =@"lastMessageAgo";
 NSString *const CHKeynewMessagesCount = @"newMessagesCount";
 NSString *const CHKeytimeAgo = @"timeAgo";

@implementation WinkChat

@synthesize chatId,WithUserId,WithUserState,WithUserVerify,WithUserFullname,WithUserUsername,lastMessage,lastMessageAgo,msgCount,timeAgo,WithUserPhotoUrl;

/*-(instancetype)initWithDictionary:(NSDictionary *)dictChatInfo
{
    if (dictChatInfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        chatId = dictChatInfo[CHKeyChatId];
        WithUserId = dictChatInfo[CHKeyWithUserId];
        WithUserVerify = dictChatInfo[CHKeyWithUserVerify];
        WithUserState = dictChatInfo[CHKeyWithUserState];
        WithUserFullname = dictChatInfo[CHKeyWithUserFullname];
        WithUserUsername = dictChatInfo[CHKeyWithUserUsername];
        lastMessage = dictChatInfo[CHKeylastMessage];
        lastMessageAgo = dictChatInfo[CHKeylastMessageAgo];
        msgCount = dictChatInfo[CHKeynewMessagesCount];
        timeAgo = dictChatInfo[CHKeytimeAgo];
        
        NSURL *url = [NSURL URLWithString:dictChatInfo[CHKeyWithUserPhotoUrl]];
        NSString *lastComponent;
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            WithUserPhotoUrl = [WinkWebservice URLForProfileImage:lastComponent];
        }
    }
    return self;
}*/
-(instancetype)initWithDictionary:(NSDictionary *)dictChatInfo
{
    if (dictChatInfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        if (![dictChatInfo[CHKeyChatId] isKindOfClass:[NSNull class]])
        {
            chatId = dictChatInfo[CHKeyChatId];
        }
        else
        {
            chatId = @"";
        }
        if (![dictChatInfo[CHKeyWithUserId] isKindOfClass:[NSNull class]])
        {
            WithUserId = dictChatInfo[CHKeyWithUserId];
        }
        else
        {
            WithUserId = @"";
        }
        if (![dictChatInfo[CHKeyWithUserVerify] isKindOfClass:[NSNull class]])
        {
            WithUserVerify = dictChatInfo[CHKeyWithUserVerify];
        }
        else
        {
            WithUserVerify = @"";
        }
        if (![dictChatInfo[CHKeyWithUserState] isKindOfClass:[NSNull class]])
        {
            WithUserState = dictChatInfo[CHKeyWithUserState];
        }
        else
        {
            WithUserState = @"";
        }
        if (![dictChatInfo[CHKeyWithUserFullname] isKindOfClass:[NSNull class]])
        {
            WithUserFullname = dictChatInfo[CHKeyWithUserFullname];
        }
        else
        {
            WithUserFullname = @"";
        }
        if (![dictChatInfo[CHKeyWithUserUsername] isKindOfClass:[NSNull class]])
        {
            WithUserUsername = dictChatInfo[CHKeyWithUserUsername];
        }
        else
        {
            WithUserUsername = @"";
        }
        if (![dictChatInfo[CHKeylastMessage] isKindOfClass:[NSNull class]])
        {
            lastMessage = dictChatInfo[CHKeylastMessage];
        }
        else
        {
            lastMessage = @"";
        }
        if (![dictChatInfo[CHKeylastMessageAgo] isKindOfClass:[NSNull class]])
        {
            lastMessageAgo = dictChatInfo[CHKeylastMessageAgo];
        }
        else
        {
            lastMessageAgo = @"";
        }
        if (![dictChatInfo[CHKeynewMessagesCount] isKindOfClass:[NSNull class]])
        {
            msgCount = dictChatInfo[CHKeynewMessagesCount];
        }
        else
        {
            msgCount = @"";
        }
        if (![dictChatInfo[CHKeytimeAgo] isKindOfClass:[NSNull class]])
        {
            timeAgo = dictChatInfo[CHKeytimeAgo];
        }
        else
        {
            timeAgo = @"";
        }
        //chatId = dictChatInfo[CHKeyChatId];
        //WithUserId = dictChatInfo[CHKeyWithUserId];
        //WithUserVerify = dictChatInfo[CHKeyWithUserVerify];
        //WithUserState = dictChatInfo[CHKeyWithUserState];
        //WithUserFullname = dictChatInfo[CHKeyWithUserFullname];
        //WithUserUsername = dictChatInfo[CHKeyWithUserUsername];
        //lastMessage = dictChatInfo[CHKeylastMessage];
        //lastMessageAgo = dictChatInfo[CHKeylastMessageAgo];
        //msgCount = dictChatInfo[CHKeynewMessagesCount];
        //timeAgo = dictChatInfo[CHKeytimeAgo];
        
        if (![dictChatInfo[CHKeyWithUserPhotoUrl] isKindOfClass:[NSNull class]])
        {
            NSURL *url = [NSURL URLWithString:dictChatInfo[CHKeyWithUserPhotoUrl]];
            NSString *lastComponent;
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                WithUserPhotoUrl = [WinkWebservice URLForProfileImage:lastComponent];
            }
        }
        else
        {
            WithUserPhotoUrl = [WinkWebservice URLForProfileImage:@""];
        }
        //        NSURL *url = [NSURL URLWithString:dictChatInfo[CHKeyWithUserPhotoUrl]];
        //        NSString *lastComponent;
        //        if(url != nil && url != NULL && (url.absoluteString.length != 0) && )
        //        {
        //            lastComponent = [url lastPathComponent];
        //            WithUserPhotoUrl = [WinkWebservice URLForProfileImage:lastComponent];
        //        }
    }
    return self;
}

@end
