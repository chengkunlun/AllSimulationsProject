//
//  Animation.m
//  QQMusic
//
//  Created by tarena on 15/5/18.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "Animation.h"

@implementation Animation
+ (CAAnimation *)returnAnimationAccordingToString:(NSString *)keyPath fromValue:(NSValue *)fromValue toValue:(NSValue *)toValue duration:(NSTimeInterval)duration{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath = keyPath;
    opacityAnimation.fromValue = fromValue;
    opacityAnimation.toValue = toValue;
    opacityAnimation.duration = duration;
    return opacityAnimation;
}
@end
