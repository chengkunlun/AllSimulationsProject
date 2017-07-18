
#import "MyMusicViewController.h"
#import "AllMusicViewController.h"
#import "SHMyMusicViewCell.h"
#import "SHSingInViewController.h"
#import "SHMyLoveMusicController.h"
#import "SHMusicTool.h"
@interface MyMusicViewController ()
@property(nonatomic,strong) NSArray *musics;
@end

@implementation MyMusicViewController
- (NSArray *)musics{
    _musics = [SHMusicTool musics];
    return _musics;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的音乐";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSingInSuccess) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.account style:UIBarButtonItemStyleDone target:self action:nil];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleDone target:self action:@selector(longinView)];
    }
    [self.tableView reloadData];
}
- (void)longinView{
    SHSingInViewController *longinVC = [[SHSingInViewController alloc] init];
    longinVC.myMusicVC = self;
    [self.navigationController pushViewController:longinVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHMyMusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.numberLabel.textColor = [UIColor lightGrayColor];
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"全部歌曲";
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld首",self.musics.count];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"我喜欢";
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld首",self.musicCount];
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"在线听歌";
            cell.numberLabel.text = nil;
        }else{
            cell.titleLabel.text = @"点歌记录";
            cell.numberLabel.text = nil;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"下载歌曲";
            cell.numberLabel.text = @"1首";
        }else if(indexPath.row == 1){
            cell.titleLabel.text = @"最近播放";
            cell.numberLabel.text = @"30首";
        }else{
            cell.titleLabel.text = @"iPod歌曲";
            cell.numberLabel.text = @"66首";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
       AllMusicViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"music"];
//        self.storyboard instantiateViewControllerWithIdentifier:<#(NSString *)#>
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        SHMyLoveMusicController *myLoveVC = [[SHMyLoveMusicController alloc] init];;
        myLoveVC.musicVC = self;
        [self.navigationController pushViewController:myLoveVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        AllMusicViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"music"];
        vc.indexPath = indexPath;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
