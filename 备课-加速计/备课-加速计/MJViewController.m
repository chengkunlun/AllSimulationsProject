//
//  MJViewController.m
//  备课-加速计
//
//  Created by MJ Lee on 14/8/10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "UIView+Extension.h"

#define MJUpdateInterval (1.0/30.0)

@interface MJViewController () <UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (assign, nonatomic) CGPoint ballVelocity;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = MJUpdateInterval; // 1秒钟采样30次
}

#pragma mark - UIAccelerometerDelegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // 1.累加速度
    _ballVelocity.x += acceleration.x;
    _ballVelocity.y -= acceleration.y;
    
    // 2.计算小球的位置
    self.ball.x += _ballVelocity.x;
    self.ball.y += _ballVelocity.y;
    
    // 3.边界处理
    CGFloat damping = 0.5;
    if (self.ball.x <= 0) {
        self.ball.x = 0;
        _ballVelocity.x *= -damping;
    } else if (self.ball.maxX >= self.view.width) {
        self.ball.maxX = self.view.width;
        _ballVelocity.x *= -damping;
    }
    
    if (self.ball.y <= 0) {
        self.ball.y = 0;
        _ballVelocity.y *= -damping;
    } else if (self.ball.maxY >= self.view.height) {
        self.ball.maxY = self.view.height;
        _ballVelocity.y *= -damping;
    }
}
@end
