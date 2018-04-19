//
//  WinkWebservice+AppSetting.h
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice.h"

@interface WinkWebservice (AppSetting)

-(void)setAllowMessage:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setAllowPhotosComment:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setAllowLikeGCM:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setAllowFriendRequestGCM:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setAllowPrivateMsgGCM:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)setAllowGiftGCM:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response))completion;

-(void)ChangePassword:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)DeactivateAccount:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getBlockedList:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrBlocked))completion;

-(void)contactUs:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getUpgradeDetail:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSDictionary *dict))completion;

-(void)disconnectFromFacebook:(NSDictionary *)dict completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)connectToFacebook:(NSDictionary *)dict completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)accountAuthorize:(NSDictionary *)dict completionHandler:(void(^)(WinkAPIResponse *response, NSDictionary * dict))completion;

-(void)accountWithdraw:(NSDictionary *)dict completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getCashOutHistory:(NSDictionary *)dict completionHandler:(void(^)(WinkAPIResponse *response, NSArray *dict))completion;

@end
