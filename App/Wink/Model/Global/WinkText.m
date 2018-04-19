//
//  WinkText.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkText.h"

@implementation WinkText
NSString *const AppName         = @"Wink";
NSString *const WinkNoInternet   = @"There are no network avaliable. Please connect to internet and try again.";

#pragma mark - Button Text
NSString *const WinkTextYes     = @"Yes";
NSString *const WinkTextNo      = @"No";
NSString *const WinkTextOK      = @"OK";
NSString *const WinkTextCancel  = @"Cancel";
NSString *const WinkTextSetting = @"Setting";

NSString *const WinkTextFromCamera  = @"Take Photo";
NSString *const WinkTextFromLibrary = @"Photo From Albums";
NSString *const WinkTextNoMoreData  = @"No More Data";
NSString *const WinkTextLoading     = @"Loading...";
NSString *const WinkTextShow        = @"Show";

#pragma mark - Image Source Messages;
NSString *const WinkAskImageSource = @"How do you want to select an image?";
NSString *const WinkAllowAccessPhotoLibrary = @"Please turn on allow access for Photo Library from the Settings.";
NSString *const WinkAllowAccessCamera       = @"Please turn on allow access for Camera from the Settings.";
#pragma mark - Login validation text
NSString *const WinkBlankUserName   = @"Please enter username"  ;
NSString *const WinkBlankPassword   = @"Please enter password";
NSString *const WinkEnterMinChar    = @"Please enter min 5 character"  ;
NSString *const WinkPswdSpace       = @"Password contains Spcae. Please Re-enter password";
NSString *const WinkInvalidPswd     = @"Password should contains at least one capital character, one small character and one numeric character and should be more then 6 characters";

NSString *const WinkSamePswd        =@"New password and confirm password should be same";

NSString *const WinkBlankFullName   = @"Please enter Full Name";
NSString *const WinkBlankEmail      = @"Please enter email";
NSString *const WinkInvalidMail     = @"Please enter valid email";
NSString *const WinkBlankDate       =  @"Please enter BirthDate";


NSString *const winkBlankCity       =@"Please enter city";
NSString *const WinkBlankJobProfile =@"Please enter job profile";
NSString *const WinkBlankReligion   =@"Please enter religion";

NSString *const WinkBlankMessage  = @"Please enter message";
NSString *const WinkBlankSubject    =@"Please enter subject";


@end
