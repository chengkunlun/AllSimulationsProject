//
//  PageControl.m
//  QQMusic
//
//  Created by tarena on 17/5/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PageControl.h"

@implementation PageControl
+ (UIPageControl *)returnPageControl:(NSArray *)musics frame:(CGRect)frame{
    UIPageControl *pageController = [[UIPageControl alloc] init];
    pageController.frame = frame;
    pageController.numberOfPages = musics.count;
    pageController.userInteractionEnabled = NO;
    pageController.currentPageIndicatorTintColor = [UIColor redColor];
    pageController.pageIndicatorTintColor = [UIColor greenColor];
    
    return pageController;
}

@end
