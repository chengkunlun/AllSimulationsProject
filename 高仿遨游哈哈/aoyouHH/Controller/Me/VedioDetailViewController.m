//
//  VedioDetailViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/5/20.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "VedioDetailViewController.h"
#import "KSVideoPlayerView.h"
#import "JZVideoPlayerView.h"

@interface VedioDetailViewController ()<playerViewDelegate,JZPlayerViewDelegate>
{
    KSVideoPlayerView *_player;
    JZVideoPlayerView *_jzPlayer;
}

@end

@implementation VedioDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self initPlayer];
        [self initJZPlayer];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPlayer{
    //http://118.118.171.6/10e1ba8400000000-1432116853-2936408529/data12/v.chuanke.com/vedio/1/08/65/10865711ff6997a671e6622352385208.mp4
//    NSURL *url = [NSURL URLWithString:@"http://118.118.171.6/10e1ba8400000000-1432116853-2936408529/data12/v.chuanke.com/vedio/1/08/65/10865711ff6997a671e6622352385208.mp4"];
    
    NSURL *url = [NSURL URLWithString:self.FileUrl];
    _player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 300) contentURL:url];
    _player.delegate = self;
    [self.view addSubview:_player];
    _player.tintColor = [UIColor redColor];
    [_player play];
}

-(void)initJZPlayer{
    NSURL *url = [NSURL URLWithString:self.FileUrl];
    _jzPlayer = [[JZVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 300) contentURL:url];
    _jzPlayer.delegate = self;
    [self.view addSubview:_jzPlayer];
    [_jzPlayer play];
}


//屏幕旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//支持旋转的方向
//一开始的屏幕旋转方向

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [UIView animateWithDuration:0 animations:^{
        if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            _jzPlayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }else{
            _jzPlayer.frame = CGRectMake(0, 0, self.view.frame.size.height, 300);
        }
    } completion:^(BOOL finished){
        
    }];
}


-(void)playerViewZoomButtonClicked:(JZVideoPlayerView *)view{
    //强制横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }else{
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

#pragma mark - JZPlayerViewDelegate
-(void)JZOnBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
