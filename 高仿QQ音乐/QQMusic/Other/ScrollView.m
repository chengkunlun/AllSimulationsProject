//
//  ScrollView.m
//  QQMusic
//
//  Created by tarena on 17/5/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "ScrollView.h"
#define mainFrame [UIScreen mainScreen].bounds

@implementation ScrollView
+ (UIScrollView *)returnScrollView:(NSArray *)musics frame:(CGRect)frame{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = frame;
    scrollView.contentSize = CGSizeMake(frame.size.width * musics.count, frame.size.height);
    for (int i = 0; i<musics.count; i++) {
        UIImage *image = [UIImage imageNamed:musics[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageViewFrame = frame;
        imageViewFrame.origin = CGPointMake(frame.size.width * i, 0);
        imageView.frame = imageViewFrame;
        [scrollView addSubview:imageView];
    }
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    return scrollView;
}
#define buttonW 60
#define buttonH 35
+ (UIButton *)createButton:(UIButton *)button location:(NSArray *)images{
    CGFloat buttonX = mainFrame.size.width * (images.count - 1) + (mainFrame.size.width - buttonW) / 2;
    CGFloat buttonY = mainFrame.size.height - 130;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    return button;
}
@end
