//
//  UIView+CGRectUtils.m
//  Wink
//
//  Created by Apple on 16/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "UIView+CGRectUtils.h"

@implementation UIView (CGRectUtils)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            width, self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, height);
}


@end
