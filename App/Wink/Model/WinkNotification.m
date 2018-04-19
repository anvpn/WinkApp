//
//  WinkNotification.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkNotification.h"

 NSString * const NKeyUserFullName  =@"fromUserFullname";
 NSString * const NKeyUserID        =@"fromUserId";
 NSString * const NKeyUserPhotoURL  =@"fromUserPhotoUrl";
 NSString * const NKeyUserState     =@"fromUserState";
 NSString * const NKeyUserName      =@"fromUserUsername";
 NSString * const NKeyNId           =@"id";
 NSString * const NKeyIteamId       =@"itemId";
 NSString * const NKeyTimeAgo       =@"timeAgo";
 NSString * const NKeyNType         =@"type";

@implementation WinkNotification
@synthesize userId,userName,userFullName,nId,timeAgo,nType,NotiphotoURL,iteamId,message;

-(instancetype)initWithDictionary:(NSDictionary *)dictNInfo
{
    if (dictNInfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        userFullName = dictNInfo[NKeyUserFullName];
        userName = dictNInfo[NKeyUserName];
        userId = dictNInfo[NKeyUserID];
        nId = dictNInfo[NKeyNId];
        timeAgo = dictNInfo[NKeyTimeAgo];
        nType = dictNInfo[NKeyNType];
        iteamId = dictNInfo[NKeyIteamId];
        
        NSURL *url = [NSURL URLWithString:dictNInfo[NKeyUserPhotoURL]];
        NSString *lastComponent;
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            NotiphotoURL = [WinkWebservice URLForProfileImage:lastComponent];
        }
        switch ([dictNInfo[NKeyNType]intValue])
        {
            case WinkNotificationLike:
                message = [NSString stringWithFormat:@"%@ likes your profile",userFullName];
                break;
                
            case WinkNotificationComment:
                message = [NSString stringWithFormat:@"%@ added a new comment",userFullName];
                break;
                
            case WinkNotificationCommentReply:
                message = [NSString stringWithFormat:@"%@ replied to your comment",userFullName];
                break;
                
            case WinkNotificationGift:
                message = [NSString stringWithFormat:@"%@ made a gift",userFullName];
                break;
                
            case WinkNotificationImageComment:
                message = [NSString stringWithFormat:@"%@ added a new comment",userFullName];
                break;
                
            case WinkNotificationImageCommentReply:
                message = [NSString stringWithFormat:@"%@ replied to your comment",userFullName];
                break;
                
            case WinkNotificationImageLike:
                message = [NSString stringWithFormat:@"%@ likes your iteam",userFullName];
                break;
                
            default:
                message = [NSString stringWithFormat:@"%@ sent you a request to friends.",userFullName];
                break;
                break;
        }
        
    }
    return self;

}

@end
@interface WinkNotificationManager()

@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation WinkNotificationManager

@synthesize notifications;

+ (WinkNotificationManager *)notificationManager
{
    static WinkNotificationManager *notificationManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      notificationManager = [[WinkNotificationManager alloc] init];
                  });
    
    return notificationManager;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        notifications = @[].mutableCopy;
    }
    
    return self;
}

- (void)addNotification:(NSDictionary *)payload
{
    if(payload)
    {
        WinkNotification *notification = [[WinkNotification alloc] init];
        
        notification.nId               = [NSString stringWithFormat:@"%@",payload [@"data"][@"id"]];
        notification.message          = payload [@"aps"][@"alert"];
        notification.nType             = [payload [@"data"][@"type"] stringValue];
        notification.notificationState   = WinkNotificationStatePending;
        notification.msgDict          = payload [@"data"];
        //notification.serviceID        = [payload[NKeyServiceID] stringValue];
        
        [notifications addObject:notification];
        
        [self processPendingNotifications];
    }
}

- (void)processPendingNotifications
{
    if(!WinkGlobalObject.user)
    {
        notifications = @[].mutableCopy;
        return;
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [notifications enumerateObjectsUsingBlock:^(WinkNotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.notificationState == WinkNotificationStatePending)
             {
                 if([notification.nType isEqualToString:@"9"]) //For Chat message
                 {
                     notification.notificationState = WinkNotificationStateShown;

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChatTable" object:notification.msgDict];
                 }
                 else
                 {
                    [self showAlertForNotification:notification];
                 }

             }
         }];
    }
    else
    {
        [notifications enumerateObjectsUsingBlock:^(WinkNotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.notificationState == WinkNotificationStatePending)
             {
                 [self navigateForNotification:notification];
             }
         }];
    }
    WinkGlobalObject.notificationCount = WinkGlobalObject.notificationCount - 1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:WinkGlobalObject.notificationCount];
}

- (void)showAlertForNotification:(WinkNotification *)notification
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = delegate.window.rootViewController;
    
    if (controller.presentedViewController)
    {
        controller = controller.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:notification.message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Show Detail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          [self navigateForNotification:notification];
                      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          [notifications removeObject:notification];
                          
                          [self processPendingNotifications];
                      }]];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
    notification.notificationState = WinkNotificationStateShown;
}

- (void)navigateForNotification:(WinkNotification *)notification
{
    [WinkUtil openControllerOnNotification:notification.nType withServiceId:@"1" withNotificationId:notification.nId];
    
    notification.notificationState = WinkNotificationStateComplete;
}

- (void)clearAllNotifications
{
    notifications = @[].mutableCopy;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self processPendingNotifications];
}

@end
