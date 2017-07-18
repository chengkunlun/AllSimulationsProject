//
//  MoviePlayerViewController.m
//  ABBPlayer
//
//  Created by beyondsoft-聂小波 on 16/9/20.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
#import "DownloadModel.h"

@interface MoviePlayerViewController ()
@property (weak, nonatomic) IBOutlet ZFPlayerView *playerView;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation MoviePlayerViewController

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
    [self.playerView cancelAutoFadeOutControlBar];
}

//#pragma mark - 代码初始化ZFPlayerView
//- (ZFPlayerView *)playerView {
//    if (!_playerView) {
//        _playerView = [[ZFPlayerView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height*0.4)];
//        [self.view addSubview:_playerView];
//        [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(20);
//            make.left.right.equalTo(self.view);
//            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
//            make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
//        }];
//        _playerView.videoURL = self.videoURL;
//        // Back button event
//        __weak typeof(self) weakSelf = self;
//        _playerView.goBackBlock = ^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        };
//    }
//    return _playerView;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 调用playerView的layoutSubviews方法
    if (self.playerView) { [self.playerView setNeedsLayout]; }
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf       = self;
    
    //if use Masonry,Please open this annotation
    /*
     UIView *topView = [[UIView alloc] init];
     topView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:topView];
     [topView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.top.left.right.equalTo(self.view);
     make.height.mas_offset(20);
     }];
     
     self.playerView = [[ZFPlayerView alloc] init];
     [self.view addSubview:self.playerView];
     [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.view).offset(20);
     make.left.right.equalTo(self.view);
     // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
     make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
     }];
     */
    
    // 设置播放前的占位图（需要在设置视频URL之前设置）
    self.playerView.placeholderImageName = @"loading_bgView1";
    // 设置视频的URL
    self.playerView.videoURL = self.videoURL;
    // 设置标题
    self.playerView.title = self.title;
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    // 打开下载功能（默认没有这个功能）
    self.playerView.hasDownload = YES;
    // 下载按钮的回调
    self.playerView.downloadBlock = ^(NSString *urlStr) {
        // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
        NSString *name = [urlStr lastPathComponent];
        //开始后台下载
        DownloadModel *downloadModel = [[DownloadModel alloc]init];
        downloadModel.showModelMssage= ^(NSString *message){
            //显示信息
            [weakSelf.view toast:message];
        };
        [downloadModel downLoadWith:urlStr title:name defaultFormat:@".mp4"];
    };
    
    // 如果想从xx秒开始播放视频
    // self.playerView.seekTime = 15;
    
    // 是否自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
    self.playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
         */
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         */
    }
}

-(void)btnClick
{
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSParameterAssert([appDlg.reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [appDlg.reach currentReachabilityStatus];
    
    if (status == NotReachable) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
        NSLog(@"----Notification Says Unreachable");
    }else if(status == ReachableViaWWAN){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"移动网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
        NSLog(@"----Notification Says mobilenet");
    }else if(status == ReachableViaWiFi){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"WIfi网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
        NSLog(@"----Notification Says wifinet");
    }  
}
@end
