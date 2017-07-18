//
//  JokeModel.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/22.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicModel.h"

@interface JokeModel : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSNumber *good;
@property(nonatomic, strong) NSNumber *bad;
@property(nonatomic, strong) NSNumber *vote;
@property(nonatomic, strong) NSNumber *comment_num;
@property(nonatomic, strong) NSNumber *anonymous;
@property(nonatomic, strong) NSNumber *appid;
@property(nonatomic, strong) NSNumber *topic;
@property(nonatomic, strong) NSString *topic_content;
@property(nonatomic, strong) PicModel *pic;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *user_pic;


@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat MaxHeight;






@end
