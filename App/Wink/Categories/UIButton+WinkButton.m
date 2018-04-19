//
//  UIButton+WinkButton.m
//  Wink
//
//  Created by Apple on 23/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "UIButton+WinkButton.h"

@implementation UIButton (WinkButton)


-(void)setStringTag:(NSString *)stringTag
{
    WinkGlobalObject.buttonStringTag = stringTag;
}
-(NSString *)getStringTag
{
    return WinkGlobalObject.buttonStringTag;
}
@end
