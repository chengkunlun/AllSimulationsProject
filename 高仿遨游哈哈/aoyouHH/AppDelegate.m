//
//  AppDelegate.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/20.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "MsgViewController.h"
#import "MeViewController.h"
#import "UserSingleton.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
//    bar.barTintColor = RGB(56, 184, 80);
    bar.barTintColor = navigationBarColor;
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    //都行
    //    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //1.
    HomeViewController *VC1 = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    DiscoverViewController *VC2 = [[DiscoverViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:VC2];
    UIViewController *VC3 = [[UIViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:VC3];
    VC3.view.backgroundColor = [UIColor whiteColor];
    MsgViewController *VC4 = [[MsgViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:VC4];
    MeViewController *VC5 = [[MeViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:VC5];
    
    VC2.title = @"发现";
    VC4.title = @"消息";
    VC5.title = @"我";
    //2.
    NSArray *viewCtrs = @[nav1,nav2,nav3,nav4,nav5];
    //3.
    UITabBarController *tabbarCtr = [[UITabBarController alloc] init];
    //4.
    [tabbarCtr setViewControllers:viewCtrs];
    tabbarCtr.delegate = self;
    //5.
    self.window.rootViewController = tabbarCtr;
    
    
    UITabBar *tabbar = tabbarCtr.tabBar;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:3];
    UITabBarItem *item5 = [tabbar.items objectAtIndex:4];
    item1.tag = 0;
    item2.tag = 1;
    item3.tag = 2;
    item4.tag = 3;
    item5.tag = 4;
    item1.title = @"首页";
    item2.title = @"发现";
//    item3.title = @"首页";
    item4.title = @"消息";
    item5.title = @"我";
    
    item1.selectedImage = [[UIImage imageNamed:@"home_press_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"home_normal_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"discovery_press_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"discovery_normal_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"add_img_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"add_img_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//注意这里的两个值
    
    item4.selectedImage = [[UIImage imageNamed:@"message_press_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"message_normal_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.selectedImage = [[UIImage imageNamed:@"my_press_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = [[UIImage imageNamed:@"my_normal_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //改变UITabBarItem字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(56, 184, 80),UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    
    [self setNav];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];    
    [self.window makeKeyAndVisible];
    
    return YES;
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

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([[url scheme] isEqualToString:@"openchuankekkiphone"]) {
        [application setApplicationIconBadgeNumber:10];
        return YES;
    }
    return NO;
}


#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([tabBarController.viewControllers indexOfObject:viewController] != 2) {
        return YES;
    }else{
        if ([[UserSingleton sharedManager] hasLogin]) {
            return YES;
        }else{
            UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginVC.view.backgroundColor = [UIColor purpleColor];
            [tabController presentViewController:loginVC animated:YES completion:nil];
            
            
//            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            loginVC.view.backgroundColor = [UIColor purpleColor];
////            [viewController.navigationController pushViewController:loginVC animated:YES];
//            [viewController presentViewController:loginVC animated:YES completion:nil];
            return NO;
        }
    }
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"dddd");
}
//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    if (item.tag == 0) {
//        NSLog(@"000");
//    }else if (item.tag == 1){
//        NSLog(@"111");
//    }
//}

@end
