//
//  WinkComment.m
//  Wink
//
//  Created by Apple on 05/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkComment.h"

 NSString *const CKeyComment = @"comment";
 NSString *const CKeyFromUserFullname = @"fromUserFullname";
 NSString *const CKeyfromUserId = @"fromUserId";
 NSString *const CKeyfromUserPhotoUrl = @"fromUserPhotoUrl";
 NSString *const CKeyfromUserUsername = @"fromUserUsername";
 NSString *const CKeyfromUserVerify = @"fromUserVerify";
 NSString *const CKeyCommentId = @"id";
 NSString *const CKeyimageFromUserId =@"imageFromUserId";
 NSString *const CKeyimageId =@"imageId";
 NSString *const CKeynotifyId = @"notifyId";
 NSString *const CKeyreplyToFullname = @"replyToFullname";
 NSString *const CKeyreplyToUserId = @"replyToUserId";
 NSString *const CKeyreplyToUserUsername = @"replyToUserUsername";
 NSString *const CKeytimeAgo = @"timeAgo";

@implementation WinkComment

@synthesize comment,fromUserId,fromUserVerify,fromUserFullname,fromUserPhotoUrl,fromUserUsername,CommentId,imageId,imageFromUserId,replyToUserId,replyToFullname,replyToUserUsername,timeAgo,notifyId;

-(instancetype)initWithDictionary:(NSDictionary *)dictComment
{
    if (dictComment.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        comment = dictComment[CKeyComment];
        fromUserFullname = dictComment[CKeyFromUserFullname];
        fromUserId = dictComment[CKeyfromUserId];
        fromUserVerify = dictComment[CKeyfromUserVerify];
        fromUserUsername = dictComment[CKeyfromUserUsername];
        CommentId = dictComment[CKeyCommentId];
        imageFromUserId = dictComment[CKeyimageFromUserId];
        imageId = dictComment[CKeyimageId];
        notifyId = dictComment[CKeynotifyId];
        replyToFullname = dictComment[CKeyreplyToFullname];
        replyToUserUsername = dictComment[CKeyfromUserUsername];
        replyToUserId = dictComment[CKeyreplyToUserId];
        timeAgo = dictComment[CKeytimeAgo];
        
        NSURL *url = [NSURL URLWithString:dictComment[CKeyfromUserPhotoUrl]];
        NSString *lastComponent;
        
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            fromUserPhotoUrl = [WinkWebservice URLForProfileImage:lastComponent];
        }

    }
    return self;
    
}

@end
