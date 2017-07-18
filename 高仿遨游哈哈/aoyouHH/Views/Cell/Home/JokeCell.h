//
//  JokeCell.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/23.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"
#import "RCLabel.h"

@interface JokeCell : UITableViewCell

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIImageView *userImg;
@property(nonatomic, strong) UILabel *userNameLable;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIButton *topicBtn;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) RCLabel *contentRCLabel;//富文本

@property(nonatomic, strong) UIImageView *picImg;

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIButton *greenBtn;
@property(nonatomic, strong) UIButton *redBtn;
@property(nonatomic, strong) UIButton *commentBtn;
@property(nonatomic, strong) UIButton *shareBtn;

@property(nonatomic, strong) UIView *vlineView1;//垂直分割线
@property(nonatomic, strong) UIView *vlineView2;//垂直分割线
@property(nonatomic, strong) UIView *vlineView3;//垂直分割线

/**
 *  图片大小类型，默认的时normal
 */
@property(nonatomic, strong) NSString *imgType;
/**
 *  cell的数据
 */
@property(nonatomic, strong) JokeModel *joke;
/**
 *  cell的高度
 */
@property(nonatomic, assign) CGFloat cellHeight;
/**
 *  cell content显示格式,默认为0，最多显示5行；如果为1，则有多少显示多少
 */
@property(nonatomic, assign) NSInteger contentType;


-(void)setJokeData:(JokeModel *)joke;

-(void)resizeHeight;

@end
