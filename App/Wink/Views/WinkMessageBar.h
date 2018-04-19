//
//  WinkMessageBar.h
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const WinkValidationMsgHeight;
extern NSInteger const WinkValidationMsgFontHeight;
extern NSString *const WinkValidationMsgFont;

@interface WinkMessageBar : UIControl

@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) UIView *relatedView;

- (void)prepareForError;

@end
