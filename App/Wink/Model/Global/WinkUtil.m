//
//  WinkUtil.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkUtil.h"

@implementation WinkUtil

+ (void)prepareApplication
{
    [WinkUtil setupLogging];
    [WinkUtil prepareUser];
    [WinkUtil prepareInitialStoryboard];
    [WinkUtil prepareThirdPartyAPI];
    [WinkUtil authorizeUser];
    [WinkUtil registerForPushNotification];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setForegroundColor:[UIColor blueColor]];
    
    [[UILabel appearance] setAdjustsFontSizeToFitWidth:YES];
    [[UILabel appearance] setMinimumScaleFactor:0.5];
    
    //[KZMLocationMonitor startInUseLocationMonitor];
}

+ (void)setupLogging
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    fileLogger.rollingFrequency = 60 * 60 * 24;// roll every day
    fileLogger.maximumFileSize  = 1024 * 1024 * 2;// max 2mb file size
    
    (fileLogger.logFileManager).maximumNumberOfLogFiles = 7;
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.000 green:0.322 blue:0.608 alpha:1.000]
                                     backgroundColor:[UIColor colorWithRed:0.741 green:0.898 blue:0.973 alpha:1.000]
                                             forFlag:DDLogFlagInfo];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.847 green:0.000 blue:0.047 alpha:1.000]
                                     backgroundColor:[UIColor colorWithRed:1.000 green:0.729 blue:0.729 alpha:1.000]
                                             forFlag:DDLogFlagError];
    
    [DDLog addLogger:fileLogger];
    
    //DDLogVerbose(@"Logging is setup (\"%@\")", [fileLogger.logFileManager logsDirectory]);
}

+ (void)prepareUser
{
    WinkGlobalObject.user = [[WinkUser alloc] initFromUserDefault];
    
    if(WinkGlobalObject.user)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        WinkGlobalObject.accessToken = [userDefaults valueForKey:UKeyAccessToken];
    }
}

+ (void)prepareInitialStoryboard
{
    UINavigationController *rootController;
    
    if(WinkGlobalObject.user)
    {
        rootController = [WinkGlobalObject.storyboardMenubar instantiateInitialViewController];
    }
    else
    {
        rootController = [WinkGlobalObject.storyboardLoginSignup instantiateInitialViewController];
    }
    
    //rootController = [WinkGlobalObject.storyboardMain instantiateInitialViewController];
    
    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = rootController;
    
    WinkGlobalObject.rootNavigationController = rootController;
}

+ (void)prepareThirdPartyAPI
{
   // [GMSServices provideAPIKey:GoogleMapAPIKey];
}
+(void)authorizeUser
{
    if(WinkGlobalObject.user.ID)
    {
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyClientId : @"1"
                               };
        [WinkWebServiceAPI accountAuthorize:dict completionHandler:^(WinkAPIResponse *response, NSDictionary *dict)
         {
             if(response.code == RCodeSuccess)
             {
                 WinkGlobalObject.sideMenuNotification = dict;
                 WinkGlobalObject.user.cashOutBalance = dict[@"cashoutBalance"];
             }
         }];

    }
    
}
+ (void)registerForPushNotification
{
    AppDelegate *appdelegateObj =  (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdelegateObj registerForPushnotification];
}

+ (void)sendDeviceInformationOnServer
{
   /* if (KZMGlobalObject.user)
    {
        NSDictionary *parameters = @{
                                     UKeyDeviceType  : UValueDeviceType,
                                     UKeyDeviceToken : (KZMGlobalObject.deviceToken ) ? : @"",
                                     UKeyAppVersion  : ([KZMUtil applicationVersion]) ? : @""
                                     };
        
        [KZMWebServiceAPI updateDeviceInformation:parameters completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }*/
}

+ (BOOL)reachable
{
    WinkReachability *reachability = [WinkReachability reachabilityForInternetConnection];
    NetworkStatus internetStatus  = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    
    return YES;
}

+ (void)showAlertFromController:(UIViewController *)controller withMessage:(NSString *)message
{
    if(message == nil)
    {
        return;
    }
    else if (controller == nil)
    {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        controller = appDelegate.window.rootViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:WinkTextOK style:UIAlertActionStyleDefault handler:nil]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertFromController:(UIViewController *)controller
                    withMessage:(NSString *)message
                     andHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    if(message == nil)
    {
        return;
    }
    else if (controller == nil)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        controller = appDelegate.window.rootViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:WinkTextOK style:UIAlertActionStyleDefault handler:handler]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)applicationVersion
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}
+ (void)updateAccessToken:(NSString *)updatedToken
{
    // NSLog(@"=========== sent Token ======= \n %@",[ACEWebService APIClient].requestSerializer.HTTPRequestHeaders);
    
    if(![updatedToken isKindOfClass:[NSNull class]])
    {
        if( updatedToken != nil && ![updatedToken isEqualToString:@""])
        {
            
            WinkGlobalObject.accessToken = [NSString stringWithFormat:@"%@",updatedToken];
            
            NSLog(@"=========== Updated Token ======= \n %@",WinkGlobalObject.accessToken);
            
           // [WinkWebServiceAPI.requestSerializer setValue:WinkGlobalObject.accessToken forHTTPHeaderField:UKeyHTTPHeader];
            
            // Update new token in userdefault
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setValue:WinkGlobalObject.accessToken forKey:UKeyAccessToken];
            
            [userDefaults synchronize];
        }
        
    }
}
+(void)logoutUser
{
    if ([WinkUtil reachable])
    {
        
        NSDictionary *dict = @{
                               UKeyClientId : @1,
                               UKeyAccountId: WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken
                               };
        
        [SVProgressHUD show];
        
        [WinkWebServiceAPI logoutUser:dict completionHandler:^(WinkAPIResponse *response)
         {
             
             if (response.code == RCodeSuccess)
             {
                 [WinkGlobalObject.user logout];
                 
                 UINavigationController *rootController = [WinkGlobalObject.storyboardLoginSignup instantiateInitialViewController];
                 
                 AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 
                 appDelegate.window.rootViewController = rootController;
                 
                 WinkGlobalObject.rootNavigationController = rootController;
                 
             }
             else
             {
                 [self showAlertFromController:nil withMessage:response.message];
             }
             
             [SVProgressHUD dismiss];
         }];
        
        
    }
    else
    {
        [self showAlertFromController:nil withMessage:WinkNoInternet];
    }

}
+(void)openControllerOnNotification:(NSString *)notificationType withServiceId:(NSString *)serviceId withNotificationId:(NSString *)notificationId
{
    //ChatViewController *slvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ChatViewController"];
    
    if ([notificationType isEqualToString:@"10"]) // Schedule Detail Type Notification
    {
        
        //[WinkGlobalObject.rootNavigationController setViewControllers:@[slvc,sdvc] animated:YES];
    }
    else if ([notificationType isEqualToString:@"5"]) // Rating and Review Type Notification
    {
    
    }
    else if ([notificationType isEqualToString:@"15"]) // Sales Person Request Notification
    {
       
    }
    else //General Notification
    {
                
    }
    
    WinkGlobalObject.notificationCount = WinkGlobalObject.notificationCount - 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:WinkGlobalObject.notificationCount];
}
+(void)sendUpdatedDeviceToken
{
    if (WinkGlobalObject.user && WinkGlobalObject.deviceToken)
    {
        NSDictionary *deviceTokenInfo = @{
                                          UKeyAccountId  : WinkGlobalObject.user.ID,
                                          UKeyDeviceToken : WinkGlobalObject.deviceToken,
                                          UKeyAccessToken : WinkGlobalObject.accessToken
                                          };
        
        [WinkWebServiceAPI updateDeviceToken:deviceTokenInfo completionHandler:^(WinkAPIResponse *response)
         {
             
             
         }];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
}
@end
