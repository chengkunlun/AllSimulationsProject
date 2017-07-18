//
//  AppDelegate.m
//  ABBPlayer
//
//  Created by beyondsoft-聂小波 on 16/9/20.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ///开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
     self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reach startNotifier]; //开始监听，会启动一个run loop
    
    return YES;
}

//通知
-(void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
//        [self.window toastMid:@"网络已断开"];
        [[NSNotificationCenter defaultCenter]postNotificationName:ReachabilityChangedNotification object:NotReachable];
        
    }else if(status == ReachableViaWWAN){
//        [self.window toastMid:@"移动网络"];
        
    }else if(status == ReachableViaWiFi){
//        [self.window toastMid:@"WIfi网络"];
//        NSLog(@"Notification Says WIfi网络 wifinet");
    }
    
}

- (NetworkStatus)currentReachabilityStatus {
    
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSParameterAssert([appDlg.reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [appDlg.reach currentReachabilityStatus];
    
    return status;
}


- (void)dealloc {
    // 删除通知对象
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
