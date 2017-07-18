#import "AllMusicViewController.h"
#import "SHMusicTool.h"
#import "SHPlayingViewController.h"
#import "SHOnLineMusicViewCell.h"
#import "SHCurrentMusic.h"
#import "SHOnLineMusciActivity.h"
#import "SHCopPlistToDocument.h"
#import "SHMusicCell.h"

static NSString *const currentMusicURLString = @"http://douban.fm/j/mine/playlist?channel=1";
@interface AllMusicViewController ()
@property(nonatomic,strong) NSArray *musicInfos;
@property(nonatomic,strong) SHPlayingViewController *playingVC;
@property(nonatomic,strong) NSArray *musics;
@property(nonatomic,strong) UIActivityIndicatorView *indicatorView;
@end

@implementation AllMusicViewController
- (NSArray *)musics{
    if (!_musics) {
        _musics = [NSArray array];
    }
    return _musics;
}
- (SHPlayingViewController *)playingVC{
    if (!_playingVC) {
        _playingVC = [[SHPlayingViewController alloc] initWithNibName:@"SHPlayingViewController" bundle:nil];
    }
    return _playingVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.musicInfos = [SHMusicTool musics];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SHMusicCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SHOnLineMusicViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    if (self.indexPath.row == 1 && self.indexPath.section == 1) {
        self.title = @"在线听歌";
        self.indicatorView = [SHOnLineMusciActivity createActivityOnLineMusicView];
        [self.indicatorView startAnimating];
        [self.view addSubview:self.indicatorView];
        [self updateCurrentMusic];
    }
}
- (void)updateCurrentMusic{
    NSURL *url = [NSURL URLWithString:currentMusicURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.musics = [self musicFromJSON:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"解析成功");
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"解析数据错误:%@",error.userInfo);
    }];
    [operation start];
}
- (NSArray *)musicFromJSON:(id)json{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *currentMusics = json[@"song"];
    for (NSDictionary *currentMusicDict in currentMusics) {
        SHCurrentMusic *currentMusic = [SHCurrentMusic currentWithJSON:currentMusicDict];
        [array addObject:currentMusic];
    }
    return [array copy];
}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.indexPath.section == 1 && self.indexPath.row == 1) {
        return self.musics.count;
    }else{
        return self.musicInfos.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexPath.row == 1 && self.indexPath.section == 1){
        SHOnLineMusicViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        SHCurrentMusic *music = self.musics[indexPath.row];
        cell.titleLabel.text = music.name;
        cell.artistNameLabel.text = music.singer;
        NSURL *url = [NSURL URLWithString:music.singericon];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.pictureImageView.image = [UIImage imageWithData:data];
        [self.indicatorView stopAnimating];
        return cell;
    }else{
        SHMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        SHMusicModel *message = self.musicInfos[indexPath.row];
        cell.nameLabel.text = message.name;
        cell.singerLabel.text = message.singer;
        cell.iconView.image = [UIImage imageNamed:message.icon];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexPath.section == 1 && self.indexPath.row ==1) {
        return 44;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.indexPath.section == 0 && self.indexPath.row == 0) {
        self.playingVC.musics = self.musicInfos;
    }else if (self.indexPath.section == 1 && self.indexPath.row == 0) {
        self.playingVC.musics = self.musics;
    }else if (self.indexPath.section == 1 && self.indexPath.row == 1) {
        self.playingVC.musics = self.musics;
    }
    self.playingVC.index = indexPath.row;
//    [SHMusicTool setPlayingMusic:[SHMusicTool musics][indexPath.row]];
    [self.playingVC show:self.indexPath];
}

@end