//
//  WinkUtil.h
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinkUtil : NSObject

+ (void)prepareApplication;
+ (void)registerForPushNotification;
+ (void)sendDeviceInformationOnServer;
+ (void)authorizeUser;
+ (BOOL)reachable;

+ (NSString * _Nullable)applicationVersion;

+ (void)showAlertFromController:(UIViewController * _Nullable)controller withMessage:(NSString * _Nullable)message;
+ (void)showAlertFromController:(UIViewController * _Nullable)controller
                    withMessage:(NSString * _Nullable)message
                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler;
+ (void)updateAccessToken:(NSString *_Nullable)token;

+ (void)logoutUser;

+ (void)openControllerOnNotification:(NSString * _Nullable)notificationType withServiceId:(NSString * _Nullable)serviceId withNotificationId:(NSString * _Nullable)notificationId;

+ (void)sendUpdatedDeviceToken;

@end
