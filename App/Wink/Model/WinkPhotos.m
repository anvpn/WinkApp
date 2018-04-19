//
//  WinkPhotos.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkPhotos.h"

  NSString *const PKeyAccessMode = @"accessMode";
  NSString *const PKeyArea = @"area";
  NSString *const PKeyCity = @"city";
  NSString *const PKeyComment = @"comment";
  NSString *const PKeyCommentCount = @"commentsCount";
  NSString *const PKeyCountry = @"country";

  NSString *const PKeyfromUserAllowPhotosComments = @"fromUserAllowPhotosComments";
  NSString *const PKeyfromUserFullname = @"fromUserFullname";
  NSString *const PKeyfromUserId = @"fromUserId";
  NSString *const PKeyfromUserPhoto = @"fromUserPhoto";
  NSString *const PKeyfromUserUsername = @"fromUserUsername";
  NSString *const PKeyfromUserVerify = @"fromUserVerify";

  NSString *const PKeyimgUrl = @"imgUrl";
  NSString *const PKeylikesCount = @"likesCount";
  NSString *const PKeymyLike = @"myLike";
  NSString *const PKeyoriginImgUrl = @"originImgUrl";
  NSString *const PKeypreviewImgUrl = @"previewImgUrl";

 NSString *const PKeyIteamType = @"itemType";

  NSString *const PKeypreviewVideoImgUrl = @"previewVideoImgUrl";

  NSString *const PKeyrating = @"rating";
  NSString *const PKeytimeAgo = @"timeAgo";
  NSString *const PKeyvideoUrl = @"videoUrl";

 NSString *const PKeyRemoveAt = @"removeAt";
 NSString *const PKeyPhotoId = @"id";

@implementation WinkPhotos

@synthesize  isAccessMode,isAllowComment, isUserVerify,isMyLike,area,city,country,comment,commentCount,fullName,userId,likesCount,photoId,timeAgo,rating,userPhotoURL,gallaryNormalPhotoURL,gallaryPreviewPhotoURL,gallaryOriginPhotoURL,gallaryVideoURL,gallaryPreviewVideoURL,userName,isVideo;

/*-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        isAccessMode    = [dict[PKeyAccessMode]boolValue];
        isAllowComment  = [dict[PKeyfromUserAllowPhotosComments]boolValue];
        isUserVerify = [dict[PKeyfromUserVerify]boolValue];
        isMyLike = [dict[PKeymyLike]boolValue];
        isVideo = [dict[PKeyIteamType]boolValue];
        
        area = dict[PKeyArea];
        city = dict[PKeyArea];
        country = dict[PKeyArea];
        
        comment = dict[PKeyComment];
        commentCount = dict[PKeyCommentCount];
        fullName = dict[PKeyfromUserFullname];
        userId = dict[PKeyfromUserId];
        userName = dict[PKeyfromUserUsername];
        
        likesCount = dict[PKeylikesCount];
        photoId = dict[PKeyPhotoId];
        timeAgo = dict[PKeytimeAgo];
        rating = dict[PKeyrating];
        
        NSURL *url = [NSURL URLWithString:dict[PKeyfromUserPhoto]];
        NSString *lastComponent;
        
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            userPhotoURL = [WinkWebservice URLForProfileImage:lastComponent];
        }
        url = [NSURL URLWithString:dict[PKeyimgUrl]];
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            gallaryNormalPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
        }
        url = [NSURL URLWithString:dict[PKeypreviewImgUrl]];
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            gallaryPreviewPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
        }
        url = [NSURL URLWithString:dict[PKeyoriginImgUrl]];
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            gallaryOriginPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
        }
        url = [NSURL URLWithString:dict[PKeypreviewVideoImgUrl]];
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            gallaryPreviewVideoURL = [WinkWebservice URLForGallaryImage:lastComponent];
        }
        url = [NSURL URLWithString:dict[PKeyvideoUrl]];
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            gallaryVideoURL = [WinkWebservice URLForGallaryVideo:lastComponent];
        }

    }
    return self;
}*/
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        //NSLog(@"1dict:-%@",dict);
        isAccessMode    = [dict[PKeyAccessMode]boolValue];
        
        if ([[dict valueForKey:@"fromUserAllowPhotosComments"]isKindOfClass:[NSNull class]])
        {
            isAllowComment  = NO;
        }
        else
        {
            isAllowComment  = [dict[PKeyfromUserAllowPhotosComments]boolValue];
        }
        //isAllowComment  = [dict[PKeyfromUserAllowPhotosComments]boolValue];
        if ([[dict valueForKey:@"fromUserVerify"]isKindOfClass:[NSNull class]])
        {
            isUserVerify  = NO;
        }
        else
        {
            isUserVerify = [dict[PKeyfromUserVerify]boolValue];
        }
        //isUserVerify = [dict[PKeyfromUserVerify]boolValue];
        isMyLike = [dict[PKeymyLike]boolValue];
        isVideo = [dict[PKeyIteamType]boolValue];
        
        area = dict[PKeyArea];
        city = dict[PKeyArea];
        country = dict[PKeyArea];
        
        comment = dict[PKeyComment];
        commentCount = dict[PKeyCommentCount];
        
        if ([[dict valueForKey:@"fromUserFullname"]isKindOfClass:[NSNull class]])
        {
            fullName = dict[PKeyfromUserFullname];
        }
        else
        {
            fullName = dict[PKeyfromUserFullname];
        }
        //fullName = dict[PKeyfromUserFullname];
        
        userId = dict[PKeyfromUserId];
        userName = dict[PKeyfromUserUsername];
        
        likesCount = dict[PKeylikesCount];
        photoId = dict[PKeyPhotoId];
        timeAgo = dict[PKeytimeAgo];
        rating = dict[PKeyrating];
        
        if ([[dict valueForKey:@"fromUserPhoto"] isKindOfClass:[NSNull class]])
        {
            //NSURL *url = [NSURL URLWithString:dict[PKeyfromUserPhoto]];
            //NSString *lastComponent;
            
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            //  lastComponent = [url lastPathComponent];
            //                userPhotoURL = [WinkWebservice URLForProfileImage:@"ASD"];
            //}
            //url = [NSURL URLWithString:dict[PKeyimgUrl]];
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            //   lastComponent = [url lastPathComponent];
            gallaryNormalPhotoURL = [WinkWebservice URLForGallaryImage:@"ASD"];
            //}
            //url = [NSURL URLWithString:dict[PKeypreviewImgUrl]];
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            //   lastComponent = [url lastPathComponent];
            gallaryPreviewPhotoURL = [WinkWebservice URLForGallaryImage:@"ASD"];
            //}
            //url = [NSURL URLWithString:dict[PKeyoriginImgUrl]];
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            // lastComponent = [url lastPathComponent];
            gallaryOriginPhotoURL = [WinkWebservice URLForGallaryImage:@"ASD"];
            //}
            //url = [NSURL URLWithString:dict[PKeypreviewVideoImgUrl]];
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            //   lastComponent = [url lastPathComponent];
            gallaryPreviewVideoURL = [WinkWebservice URLForGallaryImage:@"ASD"];
            //}
            //url = [NSURL URLWithString:dict[PKeyvideoUrl]];
            //if(url != nil && url != NULL && (url.absoluteString.length != 0))
            //{
            //  lastComponent = [url lastPathComponent];
            gallaryVideoURL = [WinkWebservice URLForGallaryVideo:@"ASD"];
            //}
        }
        else
        {
            NSURL *url = [NSURL URLWithString:dict[PKeyfromUserPhoto]];
            NSString *lastComponent;
            
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                userPhotoURL = [WinkWebservice URLForProfileImage:lastComponent];
            }
            url = [NSURL URLWithString:dict[PKeyimgUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                gallaryNormalPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
            }
            url = [NSURL URLWithString:dict[PKeypreviewImgUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                gallaryPreviewPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
            }
            url = [NSURL URLWithString:dict[PKeyoriginImgUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                gallaryOriginPhotoURL = [WinkWebservice URLForGallaryImage:lastComponent];
            }
            url = [NSURL URLWithString:dict[PKeypreviewVideoImgUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                gallaryPreviewVideoURL = [WinkWebservice URLForGallaryImage:lastComponent];
            }
            url = [NSURL URLWithString:dict[PKeyvideoUrl]];
            if(url != nil && url != NULL && (url.absoluteString.length != 0))
            {
                lastComponent = [url lastPathComponent];
                gallaryVideoURL = [WinkWebservice URLForGallaryVideo:lastComponent];
            }
        }
    }
    //NSLog(@"2dict:-%@",dict);
    return self;
}
@end
