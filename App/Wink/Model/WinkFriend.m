//
//  WinkFriend.m
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkFriend.h"
 NSString *const FKeyFullName = @"friendUserFullname";
 NSString *const FKeyUserId = @"friendUserId";
 NSString *const FKeyIsOnline = @"friendUserOnline";
 NSString *const FKeyPhoto = @"friendUserPhoto";
 NSString *const FKeyUserName = @"friendUserUsername";
 NSString *const FKeyRemoveAt = @"removeAt";
 NSString *const FKeytimeAgo = @"timeAgo";
NSString *const FKeyfriendUserVerify = @"friendUserVerify";


@implementation WinkFriend
@synthesize fullname,userName,userId,isOnline,photoURL,removeAt,timeAgo,friendUserVerify;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        fullname = dict[FKeyFullName];
        userId = dict[FKeyUserId];
        userName = dict[FKeyUserName];
        isOnline = [dict[FKeyIsOnline]boolValue];
        removeAt = dict[FKeyRemoveAt];
        timeAgo = dict[FKeytimeAgo];
        friendUserVerify = dict[FKeyfriendUserVerify];
        NSURL *url = [NSURL URLWithString:dict[FKeyPhoto]];
        NSString *lastComponent;
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            photoURL = [WinkWebservice URLForProfileImage:lastComponent];
        }
    }
    
    return self;
    
}
@end
