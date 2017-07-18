//
//  ScrollView.h
//  QQMusic
//
//  Created by tarena on 17/5/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView
+ (UIScrollView *)returnScrollView:(NSArray *)musics frame:(CGRect)frame;
+ (UIButton *)createButton:(UIButton *)button location:(NSArray *)images;
@end
