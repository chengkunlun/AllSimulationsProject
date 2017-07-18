//
//  UserModel.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>


@property(nonatomic, strong) NSNumber *score;
@property(nonatomic, strong) NSNumber *level;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSNumber *com;
@property(nonatomic, strong) NSNumber *mes;

@end
