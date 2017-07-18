//
//  PlayViewController.m
//  WordAndVocabulary
//
//  Created by 杨兴义 on 15/4/3.
//  Copyright (c) 2015年 Tom. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
@property (strong, nonatomic) KSVideoPlayerView* player;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _fileModel.fileName;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initPlay];
}

- (void)initPlay{
   self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0,600, screen_width, 300) contentURL:[NSURL URLWithString:_fileModel.targetPath]];
    self.player.titleLabel.text = _fileModel.fileName;
    self.player.delegate = self;
    [self.view addSubview:self.player];
    [self.player play];

}

//是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    
    if (ios8) {
        __weak PlayViewController *weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
                weakSelf.player.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            } else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
                weakSelf.player.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            } else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown){
            } else{
                weakSelf.player.frame = CGRectMake(0, 0, 320, 204);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return UIInterfaceOrientationMaskAll;//UIInterfaceOrientationMaskAllButUpsideDown;
}

//一开始的屏幕旋转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    //    [self initOrientation:toInterfaceOrientation duration:duration];
    
    [UIView animateWithDuration:0 animations:^{
        
        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        } else {
            self.player.frame = CGRectMake(0, 0, 320, 204);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)playerViewZoomButtonClicked:(KSVideoPlayerView *)view{
    
    //强制横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        } else {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
