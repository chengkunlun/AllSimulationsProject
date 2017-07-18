//
//  UIView+Extension.h
//  Demo1_AudioStreamer
//
//  Created by tarena on 15/5/7.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

//
//  UIView+Extension.h
//
//  Created by Hunk on 15/4/13.
//  Copyright (c) 2015年 Hunk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

// View's frame.origin.x
@property (nonatomic, assign) CGFloat   x;
// View's frame.origin.y
@property (nonatomic, assign) CGFloat   y;
// View's frame.size.width
@property (nonatomic, assign) CGFloat   width;
// View's frame.size.height
@property (nonatomic, assign) CGFloat   height;
// View's frame.origin
@property (nonatomic, assign) CGPoint   origin;
// View's frame.size
@property (nonatomic, assign) CGSize    size;
// View's center.x
@property (nonatomic, assign) CGFloat   centerX;
// View's center.y
@property (nonatomic, assign) CGFloat   centerY;

@end

