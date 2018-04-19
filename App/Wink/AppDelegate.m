//
//  AppDelegate.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize locationManager,latitude,longitude;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WinkUtil prepareApplication];
    
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-8111109588933645~1475017417"];
    
    [self registerForPushnotification];
//     Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                            didFinishLaunchingWithOptions:launchOptions];



    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;

    [locationManager requestAlwaysAuthorization];
    
    return YES;
}
-(void)registerForPushnotification
{
    float iosVersion = [[[UIDevice currentDevice] systemVersion]floatValue];
    
    if(iosVersion <= 10.0)
    {
        //if([UIApplication respondsToSelector:@selector(registerUserNotificationSettings:)])
        //{
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        //}
        
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
                 DLog( @"Push registration success - iOS 10" );
             }
             else
             {
                 DLog( @"Push registration FAILED - iOS 10" );
                 DLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 DLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
   [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PushNotification Method
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    NSLog(@"%@",notificationSettings);
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *finalDeviceToken = [deviceToken description];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    WinkGlobalObject.deviceToken = finalDeviceToken;
    
    NSLog(@"device token : %@",finalDeviceToken);
    
    [WinkUtil sendUpdatedDeviceToken];
    
    
    /* NSString *str = [[NSString alloc]initWithFormat:@"Did Register::\n device token %@",finalDeviceToken];
     UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
     [errorAlert addAction:alertOk];
     [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
    // For GCM
    
    // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
  //  GGLInstanceIDConfig *instanceIDConfig = [GGLInstanceIDConfig defaultConfig];
    //instanceIDConfig.delegate = self;
    // Start the GGLInstanceID shared instance with the that config and request a registration
    // token to enable reception of notifications
    //[[GGLInstanceID sharedInstance] startWithConfig:instanceIDConfig];
    //_registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             //kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    //[[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                //        scope:kGGLInstanceIDScopeGCM
                                               //       options:_registrationOptions
                                                     // handler:_registrationHandler];
    // [END get_gcm_reg_token]
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // NSLog(@"%@",userInfo);
    //WinkGlobalObject.notificationCount = WinkGlobalObject.notificationCount + 1;
    
     //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:WinkGlobalObject.notificationCount];
    
    [WinkNotificationManagerObject addNotification:userInfo];
    
    /*NSString *str = [[NSString alloc]initWithFormat:@"Did didReceiveRemoteNotification"];
     UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
     [errorAlert addAction:alertOk];
     [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result)
     {
         //[ACENotificationManagerObject addNotification:userInfo];
         
     }];
    /*NSString *str = [[NSString alloc]initWithFormat:@"Did didReceiveRemoteNotification"];
     UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
     [errorAlert addAction:alertOk];
     [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
}

#pragma mark - CLLocationManagerDelegate Method

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    // UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    //[errorAlert addAction:alertOk];
    //[self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];
    latitude = @"";
    longitude = @"";
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:
        {
            [self.locationManager startUpdatingLocation];
        }
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    //    if (newLocation.coordinate.latitude != prevloc.coordinate.latitude)
    //    {
    latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
    WinkGlobalObject.currentLattitude = latitude ;
    WinkGlobalObject.currentLongitude = longitude;
    
    if(WinkGlobalObject.user.ID != nil)
    {
        [self sendLocationToServer];
    }
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       for (CLPlacemark *placemark in placemarks)
                       {
                          /* NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                           NSLog(@"placemark.country %@",placemark.country);
                           NSLog(@"placemark.postalCode %@",placemark.postalCode);
                           NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                           NSLog(@"placemark.locality %@",placemark.locality);*/
                           
                           WinkGlobalObject.currentCity = placemark.locality;
                           
                           /*NSLog(@"placemark.subLocality %@",placemark.subLocality);
                           NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);*/
                       }
                   }];
    
    
   
}
-(void)sendLocationToServer
{
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"lat" : WinkGlobalObject.currentLattitude,
                           @"lng" : WinkGlobalObject.currentLongitude,
                           
                           };
    if([WinkUtil reachable] )
    {
     [WinkWebServiceAPI setGeoLocation:dict completionHAndler:^(WinkAPIResponse *response)
      {
         
      }];
    }
}


@end
