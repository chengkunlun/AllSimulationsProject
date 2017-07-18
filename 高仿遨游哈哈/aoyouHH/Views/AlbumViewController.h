//
//  AlbumViewController.h
//  HXCJ
//
//  Created by ibokan on 13-4-30.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//
/*
    图片放大协议 原理:放进去一个数组
 */

#import <UIKit/UIKit.h>
@interface AlbumViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>{
CGFloat offset;
}

// 接受图片数组
@property(retain,nonatomic)NSMutableArray *imgs;
// 显示轮播ScrollView
@property(retain,nonatomic)UIScrollView *preScrollView;
// 显示滑动label
@property(retain,nonatomic)UILabel *slidingLabel;
// 接受图片tag值
@property(assign,nonatomic)NSInteger imageTag;

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;




@end
