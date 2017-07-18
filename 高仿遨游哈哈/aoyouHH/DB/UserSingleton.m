//
//  UserSingleton.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "UserSingleton.h"

#define UD_USER @"UD_USER"

@implementation UserSingleton

@synthesize user = user;

+ (UserSingleton *)sharedManager
{
    static UserSingleton *sharedUserSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserSingleton = [[self alloc] init];
        [sharedUserSingleton load];
    });
    return sharedUserSingleton;
}

-(void)save{
    NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.user];
    [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:UD_USER];
}

-(void)load{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:UD_USER];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
}

-(void)setUser:(UserModel *)newUser{
    user = newUser;
    [self save];
}

-(void)setUserWithoutSave:(UserModel *)newUser{
    user = newUser;
}

-(void)setIcon:(NSString*)icon{
    if (user) {
        user.avatar = icon;
        [self save];
    }
}

-(BOOL)hasLogin{
    BOOL result = NO;
    if (self.user) {
        result = YES;
    }
    return result;
}

@end
