//
//  WinkPhotos.h
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PKeyAccessMode;
extern NSString *const PKeyArea;
extern NSString *const PKeyCity;
extern NSString *const PKeyComment;
extern NSString *const PKeyCommentCount;
extern NSString *const PKeyCountry;

extern NSString *const PKeyfromUserAllowPhotosComments;
extern NSString *const PKeyfromUserFullname;
extern NSString *const PKeyfromUserId;
extern NSString *const PKeyfromUserPhoto;
extern NSString *const PKeyfromUserUsername;
extern NSString *const PKeyfromUserVerify;

extern NSString *const PKeyimgUrl;
extern NSString *const PKeylikesCount;
extern NSString *const PKeymyLike;
extern NSString *const PKeyIteamType;

extern NSString *const PKeyoriginImgUrl;
extern NSString *const PKeypreviewImgUrl;
extern NSString *const PKeypreviewVideoImgUrl;

extern NSString *const PKeyrating;
extern NSString *const PKeytimeAgo;
extern NSString *const PKeyvideoUrl;

extern NSString *const PKeyRemoveAt;
extern NSString *const PKeyPhotoId;

@interface WinkPhotos : NSObject

@property BOOL isAccessMode;
@property BOOL isAllowComment;
@property BOOL isUserVerify;
@property BOOL isMyLike;
@property BOOL isVideo;

@property NSString *area;
@property NSString *city;
@property NSString *country;
@property NSString *comment;
@property NSString *commentCount;

@property NSString *fullName;
@property NSString *userName;
@property NSString *userId;
@property NSString *likesCount;
@property NSString *photoId;
@property NSString *timeAgo;
@property NSString *rating;


@property NSURL *userPhotoURL;

@property NSURL *gallaryNormalPhotoURL;
@property NSURL *gallaryPreviewPhotoURL;
@property NSURL *gallaryOriginPhotoURL;

@property NSURL *gallaryPreviewVideoURL;
@property NSURL *gallaryVideoURL;

-(instancetype)initWithDictionary : (NSDictionary *)dict;

@end
