//
//  AppDelegate.h
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property CLLocationManager *locationManager;
@property NSString       *latitude          ;
@property NSString      *longitude         ;
-(void)registerForPushnotification;
@property BOOL isDeleteFeed;
@end

