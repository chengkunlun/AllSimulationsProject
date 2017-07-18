//
//  HHConfig.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/24.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HHConfig.h"

@implementation HHConfig

+(HHConfig *)sharedManager{
    static HHConfig *hhconfig = nil;
    static dispatch_once_t ConfigPredicate;
    dispatch_once(&ConfigPredicate,^{
        hhconfig = [[self alloc] init];
    });
    return hhconfig;
}



@end
