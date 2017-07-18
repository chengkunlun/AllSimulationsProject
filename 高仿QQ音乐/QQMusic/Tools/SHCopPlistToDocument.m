//
//  SHCopPlistToDocument.m
//  QQMusic
//
//  Created by tarena on 15/5/14.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SHCopPlistToDocument.h"

@implementation SHCopPlistToDocument
+ (NSString *)copyPlistFromBoundsPlistName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *plistPath = [documentPath stringByAppendingPathComponent:name];
    NSLog(@"%@",documentPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *bundlePlist = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        [fileManager copyItemAtPath:bundlePlist toPath:plistPath error:nil];
    }
    return plistPath;
}
@end
