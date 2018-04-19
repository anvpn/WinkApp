//
//  WinkWebservice+AppSetting.m
//  Wink
//
//  Created by Apple on 06/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice+AppSetting.h"

@implementation WinkWebservice (AppSetting)
-(void)setAllowMessage:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowMessages%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)setAllowPhotosComment:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowPhotosComments%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)setAllowLikeGCM:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowLikesGCM%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)setAllowFriendRequestGCM:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowFollowersGCM%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)setAllowPrivateMsgGCM:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowMessagesGCM%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)setAllowGiftGCM:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setAllowGiftsGCM%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)ChangePassword:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setPassword%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)DeactivateAccount:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.deactivate%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)getBlockedList:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"blacklist.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         NSArray *arr = responseObject[@"items"];
         NSMutableArray *arrBlocked = [[NSMutableArray alloc]init];
         [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
          {
              [arrBlocked addObject:dict];
          }];

         
         completion(response,arrBlocked);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)contactUs:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"support.sendTicket%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)getUpgradeDetail:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    
    
    NSString *resourceAddress = [NSString stringWithFormat:@"account.upgradeFeaturesDetails%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response,responseObject);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)disconnectFromFacebook:(NSDictionary *)dict completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.disconnectFromFacebook%@",FileExtension];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)connectToFacebook:(NSDictionary *)dict completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.connectToFacebook%@",FileExtension];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)accountAuthorize:(NSDictionary *)dict completionHandler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.authorize%@",FileExtension];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         NSDictionary *dict ;
         if(response.code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"account"];
             NSDictionary *data = arr[0];
             dict = @{
                      @"guestsCount" : data[@"guestsCount"],
                      @"newFriendsCount" : data[@"newFriendsCount"],
                      @"messagesCount" : data[@"messagesCount"],
                      @"notificationsCount" : data[@"notificationsCount"],
                      @"cashoutBalance" : data[@"cashoutBalance"],
                      };
             
         }
         completion(response,dict);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)accountWithdraw:(NSDictionary *)dict completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.cashoutWithdraw%@",FileExtension];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)getCashOutHistory:(NSDictionary *)dict completionHandler:(void (^)(WinkAPIResponse *, NSArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.cashoutHistory%@",FileExtension];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         NSArray  *arrValue = responseObject[@"cashout_history"];
         completion(response,arrValue);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
@end
