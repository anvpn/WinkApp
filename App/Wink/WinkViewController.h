//
//  ViewController.h
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinkViewController : UIViewController

- (void)showErrorMessage:(NSString *_Nonnull)message belowView:(UIView *_Nonnull)viewDisplay;

- (void)removeErrorMessageBelowView:(UIView *_Nullable)viewDisplay;

- (void)showAlertWithMessage:(NSString *__nullable)message;
- (void)showAlertWithMessage:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler;
- (NSString *_Nonnull)encodeEmojis:(NSString *_Nonnull)strText;
- (NSString *_Nonnull)decodeEmojis:(NSString *_Nonnull)strText;

- (GADBannerView *_Nonnull)setUpAdvertisement;

@end

