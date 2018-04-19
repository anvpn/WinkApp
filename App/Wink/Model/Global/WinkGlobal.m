//
//  WinkGlobal.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkGlobal.h"

@implementation WinkGlobal

@synthesize screenSizeType;
//@synthesize user;
@synthesize storyboardLoginSignup, storyboardMain, storyboardMenubar,containerViewController,buttonStringTag,Ghost_Mode_Cost,Disable_Ad_Cost,Verified_Badge_Cost;

+ (WinkGlobal *)global
{
    static WinkGlobal *global = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      global = [[WinkGlobal alloc] init];
                  });
    
    return global;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        screenSizeType = [self identifyDeviceType];
        Ghost_Mode_Cost = 250;
        Verified_Badge_Cost = 250;
        Disable_Ad_Cost = 250;
    }
    
    return self;
}

- (WinkScreenSizeType)identifyDeviceType
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if(screenSize.height == 480)
    {
        return WinkScreenSizeType3_5;
    }
    else if(screenSize.height == 568)
    {
        return WinkScreenSizeType4;
    }
    else if(screenSize.height == 667)
    {
        return WinkScreenSizeType4_7;
    }
    else if(screenSize.height == 736)
    {
        return WinkScreenSizeType5_5;
    }
    
    return WinkScreenSizeTypeUndefined;
}

#pragma mark - Storyboard Methods
- (UIStoryboard *)storyboardLoginSignup
{
    if(!storyboardLoginSignup)
    {
        storyboardLoginSignup = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
    }
    
    return storyboardLoginSignup;
}

- (UIStoryboard *)storyboardMain
{
    if(!storyboardMain)
    {
        storyboardMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    return storyboardMain;
}

- (UIStoryboard *)storyboardMenubar
{
    if(!storyboardMenubar)
    {
        storyboardMenubar = [UIStoryboard storyboardWithName:@"MenuBar" bundle:nil];
    }
    
    return storyboardMenubar;
}
-(UIViewController *)containerViewController
{
    if(!containerViewController)
    {
        containerViewController  = [storyboardMenubar instantiateViewControllerWithIdentifier:@"ContainerViewController"];
    }
    return containerViewController;
}
-(NSArray *)arrGender
{
    return @[@"Male",@"Female"];
}
-(NSArray *)arrRstatus
{

    return  @[@"Not specified",@"Single",@"In a relationship",@"Engaged",@"Married",@"In love",@"Retired",@"It's complicated",@"Actively searching"];
}
-(NSArray *)arrWorldView
{
    return @[@"None selected",@"Hinduism",@"Buddism",@"Catholicism",@"Protestantism",@"Islam",@"Orthodoxy",@"Judaism",@"Secular Humanism",@"Pastafarianism"];
}
-(NSArray *)arrTypeOfEmployment
{
    return @[@"None selected",@"Salaried",@"Non-Professional",@"Business",@"Professional",@"Student",@"Retired",@"Home Maker",@"Unemployed",@"Other"];
}
-(NSArray *)arrPersonalPrio
{
    return @[@"Not Specified",@"Family and children",@"Career and money",@"Entertainment and leisure",@"Science and research",@"Improving the world",@"Personal development",@"Beuty and art",@"Fame and influence"];
}
-(NSArray *)arrImportantInOther
{
    return @[@"Not Specified",@"Intellect and creativity",@"Kindnessand honesty",@"Health and beauty",@"Wealth and power",@"Courage and persistence",@"Humor and love for life"];
}
-(NSArray *)arrViewOnSmoking
{
    return @[@"Not specified",@"Very negative",@"Negative",@"Compromisable",@"Neutral",@"Positive"];
}
-(NSArray *)arrViewOnAlcohol
{
    return @[@"Not specified",@"Very negative",@"Negative",@"Compromisable",@"Neutral",@"Positive"];
}
-(NSArray *)arrLookingFor
{
    return @[@"Not specified",@"Friendship",@"Relationship",@"Flirting"];
}
-(NSArray *)arrInterestedIn
{
    return @[@"Not specified",@"I'm interested in women",@"I'm interested in men"];
}
@end
