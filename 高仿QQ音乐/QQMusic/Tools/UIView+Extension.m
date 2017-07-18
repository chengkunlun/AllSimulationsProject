//
//  UIView+Extension.m
//  Demo1_AudioStreamer
//
//  Created by tarena on 15/5/7.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect rect     = self.frame;
    rect.origin.x   = x;
    self.frame      = rect;
}

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect rect     = self.frame;
    rect.origin.y   = y;
    self.frame      = rect;
}

- (CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

- (void)setWidth:(CGFloat)width
{
//    CGRect rect     = self.frame;
//    rect.size.width = width;
//    self.frame      = rect;
    CGRect rect=self.frame;
    rect.size.width=width;
    self.frame=rect;
}
- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect         = self.frame;
    rect.size.height    = height;
    self.frame          = rect;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame  = rect;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size   = size;
    self.frame  = rect;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center  = self.center;
    center.x        = centerX;
    self.center     = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center  = self.center;
    center.y        = centerY;
    self.center     = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

@end
