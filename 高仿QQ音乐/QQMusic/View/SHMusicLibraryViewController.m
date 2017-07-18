
#import "SHMusicLibraryViewController.h"

@interface SHMusicLibraryViewController ()<UITableViewDataSource>

@end

@implementation SHMusicLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乐库";
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 3;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"我关注的歌手";
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"华语男歌手";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"华语女歌手";
        }else{
            cell.textLabel.text = @"华语组合";
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"日韩男歌手";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"日韩女歌手";
        }else{
            cell.textLabel.text = @"日韩组合";
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"欧美男歌手";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"欧美女歌手";
        }else{
            cell.textLabel.text = @"欧美组合";
        }
    }
    return cell;
}
@end
