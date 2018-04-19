//
//  WinkMessageBar.m
//  Wink
//
//  Created by Apple on 17/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

NSInteger const WinkValidationMsgHeight     =    15.0f;
NSInteger const WinkValidationMsgFontHeight = 12.0f; ;
NSString *const WinkValidationMsgFont     = @"Helvetica";

#import "WinkMessageBar.h"


@interface WinkMessageBar()

@property (strong, nonatomic) UILabel *lblMessage;
@property (strong, nonatomic) UIImageView *imgvIcon;

@end

@implementation WinkMessageBar
@synthesize lblMessage,imgvIcon,message;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self prepareView];
        [self prepareForError];
    }
    
    return self;
}

- (void)prepareView
{
    imgvIcon = [[UIImageView alloc] init];
    
    imgvIcon.frame            = CGRectMake(0, 0, 15, 15);
    imgvIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    imgvIcon.contentMode      = UIViewContentModeCenter;
    
    [self addSubview:imgvIcon];
    
    lblMessage = [[UILabel alloc] init];
    
    lblMessage.font                      = [UIFont fontWithName:WinkValidationMsgFont size:WinkValidationMsgFontHeight];
    lblMessage.frame                     = CGRectMake(17, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    lblMessage.minimumScaleFactor        = 0.5;
    lblMessage.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:lblMessage];
    
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    lblMessage.frame = CGRectMake(17, 0, CGRectGetWidth(self.frame) - 17, CGRectGetHeight(self.frame));
}

- (void)setMessage:(NSString *)newMessage
{
    message = newMessage;
    
    lblMessage.text = message;
}

- (void)prepareForError
{
    lblMessage.textColor  = [UIColor redColor];
    imgvIcon.image       = [UIImage imageNamed:@"error-icon"];
}



@end
