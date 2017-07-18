//
//  UserModel.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "UserModel.h"

#define EC_USER_score       @"EC_USER_score"
#define EC_USER_level       @"EC_USER_level"
#define EC_USER_name        @"EC_USER_name"
#define EC_USER_avatar      @"EC_USER_avatar"
#define EC_USER_com         @"EC_USER_com"
#define EC_USER_mes         @"EC_USER_mes"

@implementation UserModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.score forKey:EC_USER_score];
    [aCoder encodeObject:self.level forKey:EC_USER_level];
    [aCoder encodeObject:self.name forKey:EC_USER_name];
    [aCoder encodeObject:self.avatar forKey:EC_USER_avatar];
    [aCoder encodeObject:self.com forKey:EC_USER_com];
    [aCoder encodeObject:self.mes forKey:EC_USER_mes];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        if (aDecoder == nil) {
            return self;
        }
        self.score = [aDecoder decodeObjectForKey:EC_USER_score];
        self.level = [aDecoder decodeObjectForKey:EC_USER_level];
        self.name = [aDecoder decodeObjectForKey:EC_USER_name];
        self.avatar = [aDecoder decodeObjectForKey:EC_USER_avatar];
        self.com = [aDecoder decodeObjectForKey:EC_USER_com];
        self.mes = [aDecoder decodeObjectForKey:EC_USER_mes];
    }
    return self;
}

@end
