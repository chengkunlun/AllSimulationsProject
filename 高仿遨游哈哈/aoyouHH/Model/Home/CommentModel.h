//
//  CommentModel.h
//  aoyouHH
//
//  Created by jinzelu on 15/5/4.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSNumber *user_id;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *user_pic;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSNumber *light;
@property(nonatomic, strong) NSNumber *able;

@end
