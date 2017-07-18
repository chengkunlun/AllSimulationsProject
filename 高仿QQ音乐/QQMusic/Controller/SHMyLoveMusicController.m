
#import "SHMyLoveMusicController.h"
#import "SHMusicCell.h"
#import "SHMusicTool.h"
#import "SHMusicModel.h"
#import "SHPlayingViewController.h"

@interface SHMyLoveMusicController ()
@property(nonatomic,strong) NSArray *musics;
@property(nonatomic,strong) NSMutableArray *loveMusics;
@property(nonatomic,strong) SHPlayingViewController *playingVC;
@end

@implementation SHMyLoveMusicController
- (NSArray *)musics{
    if (!_musics) {
        _musics = [SHMusicTool musics];
    }
    return _musics;
}
- (NSMutableArray *)loveMusics{
    if (!_loveMusics) {
        _loveMusics = [NSMutableArray array];
    }
    return _loveMusics;
}

- (SHPlayingViewController *)playingVC{
    if (!_playingVC) {
        _playingVC = [[SHPlayingViewController alloc] initWithNibName:@"SHPlayingViewController" bundle:nil];
    }
    return _playingVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我喜欢";
    for (SHMusicModel *music in self.musics) {
        if (music.isLoveMusic) {
            [self.loveMusics addObject:music];
            self.musicVC.musicCount = self.loveMusics.count;
        }
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"SHMusicCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loveMusics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SHMusicModel *music = self.loveMusics[indexPath.row];
    cell.nameLabel.text = music.name;
    cell.singerLabel.text = music.singer;
    cell.iconView.image = [UIImage imageNamed:music.icon];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [SHMusicTool setPlayingMusic:self.loveMusics[indexPath.row]];
    self.playingVC.index = indexPath.row;
    self.playingVC.musics = self.loveMusics;
    [self.playingVC show:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
