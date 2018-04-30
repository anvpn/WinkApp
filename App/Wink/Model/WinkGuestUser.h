//
//  WinkGuestUser.h
//  Wink
//
//  Created by Apple on 30/04/18.
//  Copyright © 2018 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinkGuestUser : NSObject
@property BOOL  blocked;
@property BOOL error;
@property BOOL  guestUserOnline;
@property BOOL guestUserVerify;
@property BOOL guestUserVip;

@property (strong, nonatomic) NSString *createAt;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString  *error_code;
@property (strong, nonatomic) NSString *guestTo;
@property (strong, nonatomic) NSString *guestUserFullname;
@property (strong, nonatomic) NSString *guestUserId;
@property (strong, nonatomic) NSString *guestUserPhoto;
@property (strong, nonatomic) NSString *guestUserUsername;
@property (strong, nonatomic) NSString *guestId;
@property (strong, nonatomic) NSString *removeAt;
@property (strong, nonatomic) NSString *timeAgo;
@property (strong, nonatomic) NSString *times;
-(instancetype)initWithDictionary:(NSDictionary *)userinfo;


@end
