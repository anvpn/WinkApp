//
//  WinkComment.h
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CKeyComment;
extern NSString *const CKeyFromUserFullname;
extern NSString *const CKeyfromUserId;
extern NSString *const CKeyfromUserPhotoUrl;
extern NSString *const CKeyfromUserUsername;
extern NSString *const CKeyfromUserVerify;
extern NSString *const CKeyCommentId;
extern NSString *const CKeyimageFromUserId;
extern NSString *const CKeyimageId;
extern NSString *const CKeynotifyId;
extern NSString *const CKeyreplyToFullname;
extern NSString *const CKeyreplyToUserId;
extern NSString *const CKeyreplyToUserUsername;
extern NSString *const CKeytimeAgo;

@interface WinkComment : NSObject

@property (strong, nonatomic) NSString * comment;
@property (strong, nonatomic) NSString * fromUserFullname;
@property (strong, nonatomic) NSString * fromUserId;
@property (strong, nonatomic) NSString * fromUserUsername;
@property (strong, nonatomic) NSString * fromUserVerify;
@property (strong, nonatomic) NSString * CommentId;
@property (strong, nonatomic) NSString * imageFromUserId;
@property (strong, nonatomic) NSString * imageId;
@property (strong, nonatomic) NSString * notifyId;
@property (strong, nonatomic) NSString * replyToFullname;
@property (strong, nonatomic) NSString * replyToUserId;
@property (strong, nonatomic) NSString * replyToUserUsername;
@property (strong, nonatomic) NSString * timeAgo;

@property (strong, nonatomic) NSURL* fromUserPhotoUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictComment;

@end
