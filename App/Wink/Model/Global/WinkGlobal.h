//
//  WinkGlobal.h
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WinkUser.h"
#import "ContainerViewController.h"
typedef NS_ENUM(NSInteger, WinkScreenSizeType)
{
    WinkScreenSizeTypeUndefined = 0,
    WinkScreenSizeType3_5       = 1,
    WinkScreenSizeType4         = 2,
    WinkScreenSizeType4_7       = 3,
    WinkScreenSizeType5_5       = 4
};

#define WinkGlobalObject [WinkGlobal global]
@interface WinkGlobal : NSObject

//@property (strong, nonatomic) KZMUser *user;

+ (WinkGlobal *)global;

@property (nonatomic) WinkScreenSizeType screenSizeType;

@property (strong, nonatomic) UIStoryboard *storyboardLoginSignup;
@property (strong, nonatomic) UIStoryboard *storyboardMain;
@property (strong, nonatomic) UIStoryboard *storyboardMenubar;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *accessToken;

@property (strong, nonatomic) NSString *buttonStringTag;

@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) ContainerViewController *containerViewController;

@property (strong, nonatomic) WinkUser *user;

@property (strong, nonatomic) NSArray *arrGender;
@property (strong, nonatomic) NSArray *arrRstatus;
@property (strong, nonatomic) NSArray *arrTypeOfEmployment;
@property (strong, nonatomic) NSArray *arrWorldView;
@property (strong, nonatomic) NSArray *arrPersonalPrio;
@property (strong, nonatomic) NSArray *arrImportantInOther;
@property (strong, nonatomic) NSArray *arrViewOnSmoking;
@property (strong, nonatomic) NSArray *arrViewOnAlcohol;
@property (strong, nonatomic) NSArray *arrLookingFor;
@property (strong, nonatomic) NSArray *arrInterestedIn;
@property (strong,nonatomic) NSString *currentLattitude;
@property (strong, nonatomic) NSString *cashoutBalance;
@property (strong, nonatomic) NSString *currentLongitude;
@property (strong, nonatomic) NSString *currentCity;
@property (nonatomic) NSInteger notificationCount;
@property (strong, nonatomic) NSMutableDictionary *sideMenuNotification;
@property int Ghost_Mode_Cost;
@property int Verified_Badge_Cost;
@property int Disable_Ad_Cost;

@end
