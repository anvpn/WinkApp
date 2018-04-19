//
//  WinkWebservice+Chat.m
//  Wink
//
//  Created by Apple on 07/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice+Chat.h"

@implementation WinkWebservice (Chat)

-(void)updateDeviceToken:(NSDictionary *)deviceToken completionHandler:(void(^)(WinkAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setApnDeviceToken%@",FileExtension];
    
    [self POST:resourceAddress parameters:deviceToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         //DDLogError(@"Updating Devicetoken Error : %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}


-(void)getMessageList:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"dialogs_new.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"chats"];
             NSMutableArray *arrChats = [[NSMutableArray alloc]init];
             [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  WinkChat *chat = [[WinkChat alloc]initWithDictionary:dict];
                  [arrChats addObject:chat];
                  
              }];
             
             completion(response, arrChats);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)getChatMessages:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSArray *, NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"chat.get%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSArray *arr = responseObject[@"messages"];
             NSString *messageID = responseObject[@"msgId"];
             
             completion(response, arr,messageID);
         }
         else
         {
             completion(response, nil,nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil);
     }];

}
-(void)getPreviusChatMessages:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSArray *, NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"chat.getPrevious%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(code == RCodeSuccess)
         {
             NSMutableArray *Arr1 = [[NSMutableArray alloc]init];
             NSArray *arr = responseObject[@"messages"];
             NSString *messageID = responseObject[@"msgId"];
             for (int i =(int)arr.count-1  ; i >= 0; i--)
             {
                 //NSLog(@"%@",[arr objectAtIndex:i-1]);
                 [Arr1 addObject:[arr objectAtIndex:i]];
                 //[Arr1 arrayByAddingObject:[arr objectAtIndex:i-1]];
             }
             completion(response, Arr1,messageID);
         }
         else
         {
             completion(response, nil,nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil);
     }];
    
}

-(void)deleteChat:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"chat.remove%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
        
         completion(response);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)newChatMessage:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"msg.new%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[@"message"];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
    

}
-(void)uploadChatPhoto:(UIImage *)image completionHandler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"msg.uploadImg%@",FileExtension];
    
    [WinkWebServiceAPI.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    
    [self POST:resourceAddress parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
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
-(void)setGeoLocation:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setGeoLocation%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)sendFriendRequest:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"profile.follow%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)unFriendUser:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"friends.remove%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)setGhostMode:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setGhostMode%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}
-(void)setVerifiedBadge:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.setVerifiedBadge%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)disabledAd:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    //http://winkandroid.com/api/v3/method/account.setDisableAds.inc.php
    NSString *resourceAddress = [NSString stringWithFormat:@"account.disableAds%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)addCredits:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, int))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"account.addFunds%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response,[responseObject[@"balance"]intValue]);
         }
         else
         {
             completion(response,0);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,0);
     }];

}
-(void)acceptFriendRequest:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"friends.acceptRequest%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)rejectFriendRequest:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"friends.rejectRequest%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         if(response.code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)getCommonGiftList:(NSDictionary *)userInfo completionHAndler:(void (^)(WinkAPIResponse *, NSArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"gifts.select%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             completion(response , responseObject[@"items"]);
         }
         else
         {
             completion(response, nil);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)sendGift:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, int))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"gifts.send%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             int balance = [responseObject[@"balance"]intValue];
             completion(response,balance);
         }
         else
         {
             completion(response,0);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,0);
     }];

}
-(void)uploadGallaryPhoto:(NSDictionary *)userInfo withImage:(UIImage *)selectedImage completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.uploadImg%@",FileExtension];
    
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
-(void)uploadGallaryVideo:(NSDictionary *)userInfo withData:(NSData *)videoData andImage:(UIImage *)selectedImage completionHAndler:(void (^)(WinkAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"video.upload%@",FileExtension];
    
    [WinkWebServiceAPI.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self POST:resourceAddress parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
       
         NSData *imageAsData = UIImageJPEGRepresentation(selectedImage, 0.7);
         
         if(imageAsData != nil)
         {
             [formData appendPartWithFileData:imageAsData name:@"uploaded_file" fileName:@"newfile.jpg" mimeType:@"text/csv"];
             
         }
         
         if(videoData != nil)
         {
             
             [formData appendPartWithFileData:videoData name:@"uploaded_video_file" fileName:@"new.mp4" mimeType:@"text/csv"];
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
-(void)uploadGallaryIteam:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"photos.new%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)likeGallaryIteam:(NSDictionary *)userInfo completionHandler:(void (^)(WinkAPIResponse *, int , BOOL))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"images.like%@",FileExtension];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:code andMessage:message];
         
         [WinkUtil updateAccessToken:responseObject[UKeyAccessToken]];
         
         if(response.code == RCodeSuccess)
         {
             int likeCount = [responseObject[@"likesCount"]intValue];
             BOOL isMyLike = [responseObject[@"myLike"]boolValue];
             completion(response,likeCount,isMyLike);
         }
         else
         {
             completion(response,0,NO);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"getMessageList Error: %@", error);
         
         [self requestFail:task withError:error];
         
         WinkAPIResponse *response = [[WinkAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,0,NO);
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

@end
