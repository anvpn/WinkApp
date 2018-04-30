//
//  WinkGuestUser.m
//  Wink
//
//  Created by Apple on 30/04/18.
//  Copyright © 2018 VPN. All rights reserved.
//

#import "WinkGuestUser.h"

@implementation WinkGuestUser
@synthesize blocked,createAt,date,error,error_code,guestTo,guestUserFullname,guestUserId,guestUserOnline,
guestUserPhoto,guestUserUsername,guestUserVerify,guestUserVip,removeAt,timeAgo,times,guestId;


-(instancetype)initWithDictionary:(NSDictionary *)userinfo
{
    if (userinfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        blocked          = [userinfo[@"blocked"] boolValue];
        createAt     = userinfo[@"createAt"];
        date        = userinfo[@"date"];
        error       = [userinfo[@"error"] boolValue];
        error_code      = userinfo[@"error_code"];
        guestTo    = userinfo[@"guestTo"];
        guestUserFullname      = userinfo[@"guestUserFullname"];
        guestUserId       = userinfo[@"guestUserId"];
        guestUserOnline      = [userinfo[@"guestUserOnline"] boolValue];
        guestUserPhoto     = userinfo[@"guestUserPhoto"];
        guestUserUsername   = userinfo[@"guestUserUsername"];
        guestUserVerify = [userinfo[@"guestUserVerify"] boolValue];
        guestUserVip = [userinfo[@"guestUserVip"] boolValue];
        removeAt = userinfo[@"removeAt"];
        timeAgo = userinfo[@"timeAgo"];
        times = userinfo[@"times"];
        guestId =  userinfo[@"guestId"];
    }
    
    return self;
}
@end
