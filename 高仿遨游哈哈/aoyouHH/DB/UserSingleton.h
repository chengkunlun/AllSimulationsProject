//
//  UserSingleton.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserSingleton : NSObject

@property(nonatomic, strong) UserModel* user;

+ (UserSingleton *)sharedManager;

/**
 *  保存用户信息到NSUserDefaults
 */
-(void)save;

-(void)load;
/**
 *  用户是否已登录
 */
-(BOOL)hasLogin;

-(void)setIcon:(NSString*)icon;

-(void)setUserWithoutSave:(UserModel *)newUser;


@end
