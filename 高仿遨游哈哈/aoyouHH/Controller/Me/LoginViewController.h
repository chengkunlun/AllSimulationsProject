//
//  LoginViewController.h
//  aoyouHH
//
//  Created by jinzelu on 15/5/4.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIButton *regBtn;

- (IBAction)OnLoginBtn:(id)sender;

- (IBAction)OnRegBtn:(id)sender;

@end
