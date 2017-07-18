//
//  VideoListViewController.m
//  ABBPlayer
//
//  Created by beyondsoft-聂小波 on 16/9/20.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "VideoListViewController.h"
#import "ZFPlayerCell.h"
#import "ZFPlayerModel.h"
#import "ZFPlyerResolution.h"
#import <Masonry/Masonry.h>


#import "MoviePlayerViewController.h"
#import "DownLoadListViewController.h"
#import "DownloadModel.h"

@interface VideoListViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZFPlayerView   *playerView;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 379.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"离线视频中心" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

- (void)clickRightItem:(UIBarButtonItem *)sender{
    [self.navigationController pushViewController:[DownLoadListViewController new] animated:YES];
}

- (void)requestData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier        = @"playerCell";
    ZFPlayerCell *cell                 = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    // 取到对应cell的model
    __block ZFPlayerModel *model       = self.dataSource[indexPath.row];
    // 赋值model
    cell.model                         = model;
    
    __block NSIndexPath *weakIndexPath = indexPath;
    __block ZFPlayerCell *weakCell     = cell;
    __weak typeof(self) weakSelf       = self;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        weakSelf.playerView = [ZFPlayerView sharedPlayerView];
        // 设置播放前的站位图（需要在设置视频URL之前设置）
        weakSelf.playerView.placeholderImageName = @"loading_bgView1";
        
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (ZFPlyerResolution * resolution in model.playInfo) {
            [dic setValue:resolution.url forKey:resolution.name];
        }
        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
        
        // 设置player相关参数(需要设置imageView的tag值，此处设置的为101)
        [weakSelf.playerView setVideoURL:videoURL
                           withTableView:weakSelf.tableView
                             AtIndexPath:weakIndexPath
                        withImageViewTag:101];
        [weakSelf.playerView addPlayerToCellImageView:weakCell.picView];
        weakSelf.playerView.title = model.title;
        
        // 下载功能
        weakSelf.playerView.hasDownload   = YES;
        // 下载按钮的回调
        weakSelf.playerView.downloadBlock = ^(NSString *urlStr) {
            NSString *name = [urlStr lastPathComponent];
            //开始后台下载
            DownloadModel *downloadModel = [[DownloadModel alloc]init];
            downloadModel.showModelMssage= ^(NSString *message){
                //显示信息
                [weakSelf.view toast:message];
            };
            [downloadModel downLoadWith:urlStr title:name defaultFormat:@".mp4"];
        };
        
        // 赋值分辨率字典
        weakSelf.playerView.resolutionDic = dic;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    };
    
    return cell;
}

- (void)videoPlayer:(ZFPlayerModel *)playermodel {
       [self playMp4:playermodel.playUrl fileName:playermodel.title];
}

-(void) playMp4:(NSString*)url fileName:(NSString*)fileName{
    //播放器
//    MoviePlayerViewController *detailVC = [[MoviePlayerViewController alloc]init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoviePlayerViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"MoviePlayerViewController"];
    
    
    detailVC.videoURL = [NSURL URLWithString:url];
    detailVC.title = fileName;
    //    detailVC.isLocalURLString = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 取到对应cell的model
    ZFPlayerModel *playermodel = self.dataSource[indexPath.row];
    [self videoPlayer:playermodel];
    
}


@end
