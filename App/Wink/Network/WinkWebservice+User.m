//
//  WinkWebservice+User.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice+User.h"

@implementation WinkWebservice (User)

-(void)loginWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, WinkUser *))completion
{
    // NSString *resourceAddress = [NSString stringWithFormat:@"http://www.winkandroid.com/api/v2/method/account.signIn.inc.php?username=aanal&password=123456&clientId=1"];
    ///account.signIn/%@ ,FileExtension
    
    NSString *resourceAddress = [NSString stringWithFormat:@"account.signIn%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[@"account"][0];
             WinkUser *user = [[WinkUser alloc] initWithDictionary:dict];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}

-(void)sendPoints:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, WinkUser *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.cashoutInvite%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             completion(response,nil);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}
-(void)ForgotPassword:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.recovery%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)loginWithFacebook:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, WinkUser *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.signInByFacebook%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[@"account"][0];
             WinkUser *user = [[WinkUser alloc] initWithDictionary:dict];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)logoutUser:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.logOut%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         if(code == RCodeSuccess)
         {
             
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)signUpWithImage:(NSDictionary *)userInfo withImage:(UIImage *)image completionHandler:(void (^)(WinkAPIResponse *, WinkUser *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.signUp%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageAsData = UIImageJPEGRepresentation(image, 0.7);
         if(imageAsData != nil)
         {
             [formData appendPartWithFileData:imageAsData name:UKeyImage fileName:UKeyImage mimeType:@"image/jpg"];
         }
         
     } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[@"account"][0];
             WinkUser *user = [[WinkUser alloc] initWithDictionary:dict];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}
-(void)uploadPhoto:(NSDictionary *)userInfo withImage:(UIImage *)image completionHandler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    
    
    NSString *resourceAddress = [NSString stringWithFormat:@"account.uploadPhoto%@",FileExtension];
    
    [WinkWebServiceAPI.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:resourceAddress parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageAsData = UIImageJPEGRepresentation(image, 0.7);
         if(imageAsData != nil)
         {
             
             [formData appendPartWithFileData:imageAsData name:@"uploaded_file" fileName:@"newfile.jpg" mimeType:@"image/jpg"];
             
             
         }
         
     } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             completion(response, responseObject);
         }
         else
         {
             completion(response, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}

-(void)getProfile:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, WinkUser *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             
             WinkUser *user = [[WinkUser alloc] initWithDictionary:responseObject];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
    
}
-(void)getFriendsList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"friends.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  if(![dict[@"blocked"]boolValue])
                  {
                      WinkFriend *frnd = [[WinkFriend alloc]initWithDictionary:dict];
                      [arrFriends addObject:frnd];
                      
                  }
              }];
             
             completion(response, arrFriends);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)searchFriendsList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *, NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"app.searchPreload%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSString *iteamId = responseObject[@"itemId"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkUser *frnd = [[WinkUser alloc]initWithDictionary:dict];
                  if (![WinkGlobalObject.user.ID isEqualToString:frnd.ID])
                  {
                      [arrFriends addObject:frnd];
                  }
                  
                  
                  //[arrFriends addObject:frnd];
                  
              }];
             
             completion(response, arrFriends,iteamId);
         }
         else
         {
             completion(response, nil,@"0");
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,@"0");
     }];
}
-(void)searchFriendsListWithFilter:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray * ,int, NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"app.search%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkUser *frnd = [[WinkUser alloc]initWithDictionary:dict];
                  
                  if (![WinkGlobalObject.user.ID isEqualToString:frnd.ID])
                  {
                      [arrFriends addObject:frnd];
                  }
                  
                  //[arrFriends addObject:frnd];
                  
              }];
             
             completion(response, arrFriends,[responseObject[@"itemCount"]intValue],responseObject[@"itemId"]);
         }
         else
         {
             completion(response, nil,0,@"0");
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,0,@"0");
     }];
}
-(void)getNearByFriendsList:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *, int))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.getPeopleNearby%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             int iteamid = [responseObject[@"itemId"]intValue];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkUser *frnd = [[WinkUser alloc]initWithDictionary:dict];
                  [arrFriends addObject:frnd];
                  
              }];
             
             completion(response, arrFriends,iteamid);
         }
         else
         {
             completion(response, nil,0);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,0);
     }];
    
}
-(void)getGallaryList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"photos"];
             NSMutableArray *arrPhotos = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkPhotos *frnd = [[WinkPhotos alloc]initWithDictionary:dict];
                  [arrPhotos addObject:frnd];
                  
              }];
             
             completion(response, arrPhotos);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)getProfileLikesList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.getFans%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkUser *frnd = [[WinkUser alloc]initWithDictionary:dict];
                  [arrFriends addObject:frnd];
              }];
             
             completion(response, arrFriends);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}
-(void)getProfileGuestList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"guests.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  //WinkFriend *frnd = [[WinkFriend alloc]initWithDictionary:dict];
                  if(![dict[@"blocked"]boolValue])
                  {
                      [arrFriends addObject:dict];
                  }
                  
              }];
             
             completion(response, arrFriends);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)updateProfile:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.saveSettings%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)getPeopleOfTheDay:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setPeopleOfTheDay%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         NSArray *arr = [[NSArray alloc]initWithObjects:responseObject, nil];
         
         completion(response,arr);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
    
}
-(void)getWinkStream:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *, int))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.stream%@",FileExtension];
  
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             int iteamid = [responseObject[@"itemId"]intValue];
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrPhotos = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkPhotos *frnd = [[WinkPhotos alloc]initWithDictionary:dict];
                  [arrPhotos addObject:frnd];
                  
              }];
             
             completion(response, arrPhotos,iteamid);
         }
         else
         {
             completion(response, nil,0);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,0);
     }];
    
}

-(void)getWinkStreaminPage:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *, int))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.stream%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             int iteamid = [responseObject[@"itemId"]intValue];
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrPhotos = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkPhotos *frnd = [[WinkPhotos alloc]initWithDictionary:dict];
                  [arrPhotos addObject:frnd];
                  
              }];
             completion(response, arrPhotos,iteamid);
         }
         else
         {
             completion(response, nil,0);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,0);
     }];
}


-(void)getFriendsFeed:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.feed%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrPhotos = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkPhotos *frnd = [[WinkPhotos alloc]initWithDictionary:dict];
                  [arrPhotos addObject:frnd];
                  
              }];
             
             completion(response, arrPhotos);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)getPhotoDetail:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *,NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"images.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         //NSDictionary *dict1 = responseObject[@"items"];
         NSArray *arr = responseObject[@"items"];
         NSMutableArray *arrPhotos = [[NSMutableArray alloc]init];
         [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
          {
              WinkPhotos *frnd = [[WinkPhotos alloc]initWithDictionary:dict];
              [arrPhotos addObject:frnd];
              
          }];
         NSDictionary *dict = responseObject[@"comments"];
         if(dict.count > 0)
         {
             NSArray *arr = dict[@"comments"];
             NSMutableArray *arrComments = [[NSMutableArray alloc]init];
             for (int i = (int)(arr.count-1); i >= 0; i--)
             {
                 NSDictionary *dict = arr[i];
                 WinkComment *comment = [[WinkComment alloc]initWithDictionary:dict];
                 [arrComments addObject:comment];
             }
             /*[arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
              WinkComment *comment = [[WinkComment alloc]initWithDictionary:dict];
              [arrComments addObject:comment];
              
              }];*/
             completion(response, arrComments,arrPhotos);
         }
         else
         {
             completion(response, nil,nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil);
     }];
    
    
}
-(void)reportUserProfile:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.report%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)blockUserProfile:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"blacklist.add%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)removeFromBlackList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"blacklist.remove%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)getILikedList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.getILiked%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrFriends = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkUser *frnd = [[WinkUser alloc]initWithDictionary:dict];
                  [arrFriends addObject:frnd];
              }];
             
             completion(response, arrFriends);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)getGiftsList:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"gifts.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"items"];
             NSMutableArray *arrGifts = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkGift *frnd = [[WinkGift alloc]initWithDictionary:dict];
                  [arrGifts addObject:frnd];
              }];
             
             completion(response, arrGifts);
         }
         else
         {
             completion(response, nil);
         }
         
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)getNotificationList:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"notifications.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"notifications"];
             NSMutableArray *arrGifts = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkNotification *frnd = [[WinkNotification alloc]initWithDictionary:dict];
                  [arrGifts addObject:frnd];
              }];
             
             completion(response, arrGifts);
         }
         else
         {
             completion(response, nil);
         }
         
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)deletePhotoComment:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    
    NSString *resourceAddress = [NSString stringWithFormat:@"images.commentRemove%@",FileExtension];
    
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
-(void)SendPhotoComment:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, WinkComment *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"images.comment%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             WinkComment *comment = [[WinkComment alloc]initWithDictionary:responseObject[@"comment"]];
             
             completion(response,comment);
         }
         else
         {
             completion(response,nil);
         }
         
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
    
}
-(void)deletePhoto:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.remove%@",FileExtension];
    
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
-(void)reportUserPhoto:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.report%@",FileExtension];
    
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
-(void)uploadProfilePhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.uploadPhoto%@",FileExtension];
    
    [WinkWebServiceAPI.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:resourceAddress parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageAsData = UIImageJPEGRepresentation(selectedImage, 0.7);
         if(imageAsData != nil)
         {
             
             [formData appendPartWithFileData:imageAsData name:@"uploaded_file" fileName:@"newfile.jpg" mimeType:@"image/jpg"];
             
             
         }
         
     } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             completion(response, responseObject);
         }
         else
         {
             completion(response, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)uploadCoverPhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.uploadCover%@",FileExtension];
    
    // [WinkWebServiceAPI.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:resourceAddress parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageAsData = UIImageJPEGRepresentation(selectedImage, 0.7);
         if(imageAsData != nil)
         {
             
             [formData appendPartWithFileData:imageAsData name:@"uploaded_file" fileName:@"cover.jpg" mimeType:@"image/jpg"];
             
         }
         
     } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             completion(response, responseObject);
         }
         else
         {
             completion(response, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
    
}
-(void)likeFriendProfile:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.like%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response,responseObject);
         }
         else
         {
             completion(response,nil);
         }
         
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
    
}
-(void)getFame:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"fame.topThreeFame%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         NSArray *arr ;
         if(response.code == RCodeSuccess)
         {
             arr = responseObject[@"topThreeFameData"];
         }
         completion(response,arr);
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
    
}
-(void)SendAmount:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, WinkComment *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"fame.bidAmount%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             completion(response,nil);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)Cashout:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.cashoutWithdraw%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[@"message"];
         NSString *cashoutBalance = responseObject[@"cashoutBalance"];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message andcashoutBalance:cashoutBalance];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)DeleteGift:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"gifts.remove%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[@"message"];
         //NSString *cashoutBalance = responseObject[@"cashoutBalance"];
         
         //WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message andcashoutBalance:cashoutBalance];
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         completion(response);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"signinWithUserDetail Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
@end
