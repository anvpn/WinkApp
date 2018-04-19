//
//  WinkFriend.h
//  Wink
//
//  Created by Apple on 21/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FKeyFullName;
extern NSString *const FKeyUserId;
extern NSString *const FKeyIsOnline;
extern NSString *const FKeyPhoto;
extern NSString *const FKeyUserName;
extern NSString *const FKeyRemoveAt;
extern NSString *const FKeytimeAgo;
extern NSString *const FKeyfriendUserVerify;

@interface WinkFriend : NSObject

@property NSString *fullname;
@property NSString *userId;
@property BOOL isOnline;
@property NSURL *photoURL;
@property NSString *userName;
@property NSString *removeAt;
@property NSString *timeAgo;
@property NSString *friendUserVerify;
-(instancetype )initWithDictionary:(NSDictionary *)dict;


@end
