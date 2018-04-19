//
//  WinkWebservice+User.h
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice.h"

@interface WinkWebservice (User)

-(void)loginWithUserDetail:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, WinkUser *user))completion;

-(void)sendPoints:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, WinkUser *user))completion;

-(void)loginWithFacebook:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, WinkUser *user))completion;

-(void)logoutUser:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

- (void)signUpWithImage:(NSDictionary *)userInfo withImage:(UIImage *)image completionHandler:(void(^)(WinkAPIResponse *response, WinkUser *user))completion;

-(void)uploadPhoto:(NSDictionary *)userInfo withImage:(UIImage *)image completionHandler:(void(^)(WinkAPIResponse *response, NSDictionary *photoDict))completion;

-(void)getProfile:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, WinkUser *user))completion;

-(void)getFriendsList : (NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrFriends))completion;


-(void)searchFriendsList : (NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrFriends, NSString *iteamId))completion;

-(void)searchFriendsListWithFilter : (NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrFriends, int peopleFound ,NSString *iteamId))completion;

-(void)getNearByFriendsList :(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId))completion;



-(void)getGallaryList : (NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrPhotos))completion;

-(void)getProfileLikesList:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrLikes))completion;

-(void)getProfileGuestList:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrGuest))completion;

-(void)updateProfile:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getPeopleOfTheDay:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSArray *dictPeopleOfTheDay))completion;

-(void)getWinkStream:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId))completion;


-(void)getWinkStreaminPage:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrPhotos, int iteamId))completion;

-(void)getFriendsFeed:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrPhotos))completion;

-(void)getPhotoDetail:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrComments,NSMutableArray *Data))completion;

-(void)reportUserProfile:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)blockUserProfile:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)removeFromBlackList:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)getILikedList:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrILikes))completion;

-(void)getGiftsList:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrGifts))completion;

-(void)getFame:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSArray *dictPeopleOfTheDay))completion;

-(void)SendAmount:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response,WinkComment*))completion;

-(void)getNotificationList:(NSDictionary *)userInfo completionHAndler:(void(^)(WinkAPIResponse *response, NSMutableArray *arrNotification))completion;

-(void)deletePhotoComment:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)SendPhotoComment:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response,WinkComment*))completion;

-(void)deletePhoto:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)reportUserPhoto:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)uploadProfilePhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void(^)(WinkAPIResponse *response,NSDictionary *responseDict))completion;

-(void)uploadCoverPhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void(^)(WinkAPIResponse *response,NSDictionary *responseDict))completion;

-(void)likeFriendProfile:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response, NSDictionary *responseDict))completion;

-(void)ForgotPassword:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)Cashout:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;

-(void)DeleteGift:(NSDictionary *)userInfo completionHandler:(void(^)(WinkAPIResponse *response))completion;
@end
