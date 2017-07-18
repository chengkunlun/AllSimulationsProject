//
//  Animation.h
//  QQMusic
//
//  Created by tarena on 15/5/18.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Animation : CAAnimation
+ (CAAnimation *)returnAnimationAccordingToString:(NSString *)keyPath fromValue:(NSValue *)fromValue toValue:(NSValue *)toValue duration:(NSTimeInterval)duration;
@end
