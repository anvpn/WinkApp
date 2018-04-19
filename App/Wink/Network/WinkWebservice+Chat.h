//
//  WinkWebservice+Chat.h
//  Wink
//
//  Created by Apple on 07/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice.h"

@interface WinkWebservice (Chat)


-(void)updateDeviceToken:(NSDictionary *)deviceToken completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getMessageList : (NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrMessages))completion;

-(void)getChatMessages: (NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response,NSArray *arrMessages,NSString *msgID))completion;

-(void)getPreviusChatMessages: (NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response,NSArray *arrMessages,NSString *msgID))completion;

-(void)deleteChat:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)newChatMessage:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSDictionary *dict))completion;

-(void)uploadChatPhoto:(UIImage *)image completionHandler:(void(^)(WinkAPIResponse *response,NSDictionary *photoDict))completion;

-(void)setGeoLocation:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)sendFriendRequest :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)unFriendUser :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setGhostMode :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setVerifiedBadge :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)disabledAd :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)addCredits:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *response, int credit))completion;

-(void)acceptFriendRequest:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)rejectFriendRequest:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;


-(void)getCommonGiftList:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSArray *arrGifts))completion;

-(void)sendGift:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response,int balance))completion;

-(void)uploadGallaryPhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void(^)(WinkAPIResponse *response, NSDictionary *dict))completion;

-(void)uploadGallaryVideo:(NSDictionary *)userInfo withData:(NSData *)videoData  andImage:(UIImage *)selectedImage completionHAndler:(void(^)(WinkAPIResponse *response, NSDictionary *dict))completion;

-(void)uploadGallaryIteam:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)likeGallaryIteam:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, int likeCount, BOOL myLike))completion;




@end
