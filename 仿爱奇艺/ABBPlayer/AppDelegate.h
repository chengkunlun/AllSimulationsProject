//
//  AppDelegate.h
//  ABBPlayer
//
//  Created by beyondsoft-聂小波 on 16/9/20.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h" 

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *reach;  

- (NetworkStatus)currentReachabilityStatus;

@end

